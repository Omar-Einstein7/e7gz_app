import Pitch from '../models/Pitch.js';
import {
  sendSuccess,
  sendCreated,
  sendBadRequest,
  sendError,
  sendNotFound,
  sendForbidden,
} from '../utils/response.js';

// ─── List & Search ────────────────────────────────────────────────────────────

/**
 * GET /api/pitches
 * Query: search, city, sportType, minPrice, maxPrice, page, limit
 */
const getPitches = async (req, res) => {
  try {
    const {
      search,
      city,
      sportType,
      minPrice,
      maxPrice,
      page = 1,
      limit = 10,
    } = req.query;

    const filter = { isAvailable: true };

    if (search) {
      filter.$or = [
        { name: { $regex: search, $options: 'i' } },
        { 'location.address': { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } },
      ];
    }
    if (city) filter['location.city'] = { $regex: city, $options: 'i' };
    if (sportType) filter.sportType = sportType;
    if (minPrice || maxPrice) {
      filter.pricePerHour = {};
      if (minPrice) filter.pricePerHour.$gte = Number(minPrice);
      if (maxPrice) filter.pricePerHour.$lte = Number(maxPrice);
    }

    const skip = (Number(page) - 1) * Number(limit);
    const [pitches, total] = await Promise.all([
      Pitch.find(filter)
        .populate('ownerId', 'name email phone')
        .sort({ rating: -1, createdAt: -1 })
        .skip(skip)
        .limit(Number(limit)),
      Pitch.countDocuments(filter),
    ]);

    return sendSuccess(res, {
      pitches,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: Math.ceil(total / Number(limit)),
      },
    });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Nearby ───────────────────────────────────────────────────────────────────

/**
 * GET /api/pitches/nearby
 * Query: lat, lng, radius (meters, default 5000)
 */
const getNearbyPitches = async (req, res) => {
  try {
    const { lat, lng, radius = 5000 } = req.query;
    if (!lat || !lng) {
      return sendBadRequest(res, 'lat and lng query parameters are required');
    }

    const pitches = await Pitch.find({
      isAvailable: true,
      'location.coordinates': {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(lng), parseFloat(lat)],
          },
          $maxDistance: Number(radius),
        },
      },
    })
      .populate('ownerId', 'name')
      .limit(20);

    return sendSuccess(res, { pitches });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Single Pitch ─────────────────────────────────────────────────────────────

/**
 * GET /api/pitches/:id
 */
const getPitchById = async (req, res) => {
  try {
    const pitch = await Pitch.findById(req.params.id).populate('ownerId', 'name email phone');
    if (!pitch) return sendNotFound(res, 'Pitch not found');
    return sendSuccess(res, { pitch });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Create (Owner) ───────────────────────────────────────────────────────────

/**
 * POST /api/pitches
 */
const createPitch = async (req, res) => {
  try {
    const pitchData = {
      ...req.body,
      ownerId: req.user.id,
    };

    const pitch = await Pitch.create(pitchData);
    return sendCreated(res, { pitch }, 'Pitch created successfully');
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Update (Owner) ───────────────────────────────────────────────────────────

/**
 * PUT /api/pitches/:id
 */
const updatePitch = async (req, res) => {
  try {
    const pitch = await Pitch.findById(req.params.id);
    if (!pitch) return sendNotFound(res, 'Pitch not found');

    if (pitch.ownerId.toString() !== req.user.id && req.user.role !== 'admin') {
      return sendForbidden(res, 'You are not the owner of this pitch');
    }

    const updated = await Pitch.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    return sendSuccess(res, { pitch: updated }, 'Pitch updated');
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Delete (Owner) ───────────────────────────────────────────────────────────

/**
 * DELETE /api/pitches/:id
 */
const deletePitch = async (req, res) => {
  try {
    const pitch = await Pitch.findById(req.params.id);
    if (!pitch) return sendNotFound(res, 'Pitch not found');

    if (pitch.ownerId.toString() !== req.user.id && req.user.role !== 'admin') {
      return sendForbidden(res, 'You are not the owner of this pitch');
    }

    await pitch.deleteOne();
    return sendSuccess(res, null, 'Pitch deleted');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * GET /api/pitches/owner/my-pitches
 */
const getOwnerPitches = async (req, res) => {
  try {
    const pitches = await Pitch.find({ ownerId: req.user.id });
    return sendSuccess(res, { pitches });
  } catch (err) {
    return sendError(res, err.message);
  }
};

export {
  getPitches,
  getNearbyPitches,
  getPitchById,
  createPitch,
  updatePitch,
  deletePitch,
  getOwnerPitches,
};
