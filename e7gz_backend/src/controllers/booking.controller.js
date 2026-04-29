import Booking from '../models/Booking.js';
import Pitch from '../models/Pitch.js';
import User from '../models/User.js';
import {
  sendSuccess,
  sendCreated,
  sendBadRequest,
  sendError,
  sendNotFound,
  sendForbidden,
} from '../utils/response.js';
import { createNotification } from './notification.controller.js';

// ─── Time Slot Helpers ────────────────────────────────────────────────────────

const timeToMinutes = (t) => {
  const [h, m] = t.split(':').map(Number);
  return h * 60 + m;
};

const minutesToTime = (mins) => {
  const h = Math.floor(mins / 60).toString().padStart(2, '0');
  const m = (mins % 60).toString().padStart(2, '0');
  return `${h}:${m}`;
};

// ─── Get Available Slots ─────────────────────────────────────────────────────

/**
 * GET /api/bookings/pitch/:pitchId/slots?date=YYYY-MM-DD
 */
const getAvailableSlots = async (req, res) => {
  try {
    const { pitchId } = req.params;
    const { date } = req.query;

    if (!date) return sendBadRequest(res, 'date query param is required (YYYY-MM-DD)');

    const pitch = await Pitch.findById(pitchId);
    if (!pitch) return sendNotFound(res, 'Pitch not found');

    const open = timeToMinutes(pitch.openingTime || '06:00');
    const close = timeToMinutes(pitch.closingTime || '24:00');
    const duration = pitch.slotDurationMinutes || 60;

    // Get existing bookings for that pitch/date
    const booked = await Booking.find({
      pitchId,
      date,
      status: { $ne: 'cancelled' },
    }).select('startTime endTime');

    const bookedMinutes = new Set();
    booked.forEach((b) => {
      const start = timeToMinutes(b.startTime);
      const end = timeToMinutes(b.endTime);
      for (let m = start; m < end; m += 30) bookedMinutes.add(m);
    });

    const slots = [];
    for (let start = open; start + duration <= close; start += duration) {
      const end = start + duration;
      let isBooked = false;
      for (let m = start; m < end; m += 30) {
        if (bookedMinutes.has(m)) { isBooked = true; break; }
      }
      slots.push({
        startTime: minutesToTime(start),
        endTime: minutesToTime(end),
        isAvailable: !isBooked,
        price: pitch.pricePerHour * (duration / 60),
      });
    }

    return sendSuccess(res, { slots, date, pitchId });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Create Booking ───────────────────────────────────────────────────────────

/**
 * POST /api/bookings
 * Body: { pitchId, date, startTime, endTime, notes? }
 */
const createBooking = async (req, res) => {
  try {
    const { pitchId, date, startTime, endTime, notes } = req.body;

    const pitch = await Pitch.findById(pitchId);
    if (!pitch) return sendNotFound(res, 'Pitch not found');
    if (!pitch.isAvailable) return sendBadRequest(res, 'Pitch is not available');

    // Check for conflict
    const conflict = await Booking.findOne({
      pitchId,
      date,
      status: { $ne: 'cancelled' },
      $or: [
        { startTime: { $lt: endTime }, endTime: { $gt: startTime } },
      ],
    });

    if (conflict) {
      return sendBadRequest(res, 'This time slot is already booked');
    }

    const durationHours =
      (timeToMinutes(endTime) - timeToMinutes(startTime)) / 60;
    const totalPrice = pitch.pricePerHour * durationHours;

    const booking = await Booking.create({
      userId: req.user.id,
      pitchId,
      date,
      startTime,
      endTime,
      totalPrice,
      notes,
    });

    // Award loyalty points: 1 point for every 10 EGP
    const pointsAwarded = Math.floor(totalPrice / 10);
    await User.findByIdAndUpdate(req.user.id, {
      $inc: { loyaltyPoints: pointsAwarded },
    });

    await booking.populate([
      { path: 'pitchId', select: 'name location images pricePerHour' },
      { path: 'userId', select: 'name email' },
    ]);

    return sendCreated(res, { booking }, 'Booking confirmed');
  } catch (err) {
    if (err.code === 11000) {
      return sendBadRequest(res, 'This time slot is already booked');
    }
    return sendError(res, err.message);
  }
};

// ─── Get My Bookings ──────────────────────────────────────────────────────────

/**
 * GET /api/bookings
 * Query: status, page, limit
 */
const getMyBookings = async (req, res) => {
  try {
    const { status, page = 1, limit = 10 } = req.query;
    const filter = { userId: req.user.id };
    if (status) filter.status = status;

    const skip = (Number(page) - 1) * Number(limit);
    const [bookings, total] = await Promise.all([
      Booking.find(filter)
        .populate('pitchId', 'name location images pricePerHour')
        .sort({ date: -1, startTime: -1 })
        .skip(skip)
        .limit(Number(limit)),
      Booking.countDocuments(filter),
    ]);

    return sendSuccess(res, {
      bookings,
      pagination: { total, page: Number(page), limit: Number(limit) },
    });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Get Single Booking ───────────────────────────────────────────────────────

/**
 * GET /api/bookings/:id
 */
const getBookingById = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id).populate(
      'pitchId',
      'name location images pricePerHour ownerId'
    );

    if (!booking) return sendNotFound(res, 'Booking not found');
    if (booking.userId.toString() !== req.user.id && req.user.role !== 'admin') {
      return sendForbidden(res);
    }

    return sendSuccess(res, { booking });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Cancel Booking ───────────────────────────────────────────────────────────

/**
 * DELETE /api/bookings/:id
 */
const cancelBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) return sendNotFound(res, 'Booking not found');
    if (booking.userId.toString() !== req.user.id && req.user.role !== 'admin') {
      return sendForbidden(res);
    }
    if (booking.status === 'cancelled') {
      return sendBadRequest(res, 'Booking is already cancelled');
    }

    booking.status = 'cancelled';
    await booking.save();

    await booking.populate('pitchId', 'name');

    await createNotification(
      req.user.id,
      'Booking Cancelled',
      `Your booking at ${booking.pitchId.name} for ${booking.date} has been cancelled.`,
      'booking',
      { bookingId: booking._id.toString() }
    );

    return sendSuccess(res, { booking }, 'Booking cancelled');
  } catch (err) {
    return sendError(res, err.message);
  }
};

export {
  getAvailableSlots,
  createBooking,
  getMyBookings,
  getBookingById,
  cancelBooking,
};
