import Match from '../models/Match.js';
import Booking from '../models/Booking.js';
import {
  sendSuccess,
  sendCreated,
  sendBadRequest,
  sendError,
  sendNotFound,
} from '../utils/response.js';

/**
 * GET /api/matches
 * Query: pitchId, date, status
 */
export const getMatches = async (req, res) => {
  try {
    const { pitchId, date, status = 'open' } = req.query;
    const filter = {};
    if (pitchId) filter.pitchId = pitchId;
    if (date) filter.date = date;
    if (status) filter.status = status;

    const matches = await Match.find(filter)
      .populate('pitchId', 'name location images pricePerHour')
      .populate('creatorId', 'name photoUrl')
      .populate('participantIds', 'name photoUrl')
      .sort({ date: 1, startTime: 1 });

    return sendSuccess(res, { matches });
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * POST /api/matches
 * Body: { title, pitchId, date, startTime, endTime, maxPlayers, skillLevel }
 */
export const createMatch = async (req, res) => {
  try {
    const { title, pitchId, date, startTime, endTime, maxPlayers, skillLevel } = req.body;

    // Check if user already has a match or booking at this time
    const existing = await Match.findOne({
      creatorId: req.user.id,
      date,
      startTime,
    });
    if (existing) return sendBadRequest(res, 'You already have a match at this time');

    // Calculate price per player (mock logic: pitch price / max players + 10% platform fee)
    // In a real app, this would be more complex
    const match = await Match.create({
      title,
      pitchId,
      creatorId: req.user.id,
      date,
      startTime,
      endTime,
      maxPlayers,
      participantIds: [req.user.id],
      pricePerPlayer: 50, // Mock fixed price for now, or calculate based on pitch
      skillLevel,
    });

    return sendCreated(res, { match }, 'Match created successfully');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * POST /api/matches/:id/join
 */
export const joinMatch = async (req, res) => {
  try {
    const match = await Match.findById(req.params.id);
    if (!match) return sendNotFound(res, 'Match not found');

    if (match.status === 'full' || match.participantIds.length >= match.maxPlayers) {
      return sendBadRequest(res, 'Match is already full');
    }

    if (match.participantIds.includes(req.user.id)) {
      return sendBadRequest(res, 'You are already in this match');
    }

    match.participantIds.push(req.user.id);
    await match.save();

    return sendSuccess(res, { match }, 'Joined match successfully');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * GET /api/matches/:id
 */
export const getMatchById = async (req, res) => {
  try {
    const match = await Match.findById(req.params.id)
      .populate('pitchId')
      .populate('creatorId', 'name photoUrl')
      .populate('participantIds', 'name photoUrl');

    if (!match) return sendNotFound(res, 'Match not found');
    return sendSuccess(res, { match });
  } catch (err) {
    return sendError(res, err.message);
  }
};
