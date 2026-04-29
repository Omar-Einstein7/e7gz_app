import Review from '../models/Review.js';
import { sendSuccess, sendCreated, sendBadRequest, sendError } from '../utils/response.js';

/**
 * GET /api/pitches/:pitchId/reviews
 */
export const getPitchReviews = async (req, res) => {
  try {
    const reviews = await Review.find({ pitchId: req.params.pitchId })
      .populate('userId', 'name photoUrl')
      .sort({ createdAt: -1 });

    return sendSuccess(res, { reviews });
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * POST /api/reviews
 * Body: { pitchId, rating, comment }
 */
export const createReview = async (req, res) => {
  try {
    const { pitchId, rating, comment } = req.body;

    // Optional: Check if user actually booked this pitch before
    // (Skipping for now for simplicity)

    const existing = await Review.findOne({ userId: req.user.id, pitchId });
    if (existing) {
      return sendBadRequest(res, 'You have already reviewed this pitch');
    }

    const review = await Review.create({
      userId: req.user.id,
      pitchId,
      rating,
      comment,
    });

    return sendCreated(res, { review }, 'Review submitted successfully');
  } catch (err) {
    return sendError(res, err.message);
  }
};
