import Payment from '../models/Payment.js';
import Booking from '../models/Booking.js';
import { createNotification } from './notification.controller.js';
import { sendSuccess, sendCreated, sendError, sendBadRequest } from '../utils/response.js';

/**
 * POST /api/payments/checkout
 * Body: { bookingId, matchId, amount, paymentMethod }
 */
export const checkout = async (req, res) => {
  try {
    const { bookingId, matchId, amount, paymentMethod } = req.body;

    if (!bookingId && !matchId) {
      return sendBadRequest(res, 'Either bookingId or matchId is required');
    }

    // 1. Create a pending payment record
    const transactionId = `txn_${Math.random().toString(36).substr(2, 9)}`;
    const payment = await Payment.create({
      userId: req.user.id,
      bookingId,
      matchId,
      amount,
      paymentMethod,
      transactionId,
      status: 'completed', // Auto-complete for mock
    });

    // 2. If it's a booking, update booking status to confirmed/paid
    if (bookingId) {
      const updatedBooking = await Booking.findByIdAndUpdate(bookingId, {
        status: 'confirmed',
        paymentStatus: 'paid',
      }).populate('pitchId');

      if (updatedBooking) {
        await createNotification(
          req.user.id,
          'Booking Confirmed!',
          `Your match at ${updatedBooking.pitchId.name} is confirmed for ${updatedBooking.date}.`,
          'booking',
          { bookingId: updatedBooking._id.toString() }
        );
      }
    }

    // 3. (Optional) Award more loyalty points here if not done during booking creation
    // But we already did it in booking creation.

    return sendCreated(res, { payment }, 'Payment successful');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * GET /api/payments/my-transactions
 */
export const getMyTransactions = async (req, res) => {
  try {
    const payments = await Payment.find({ userId: req.user.id })
      .populate('bookingId')
      .populate('matchId')
      .sort({ createdAt: -1 });

    return sendSuccess(res, { payments });
  } catch (err) {
    return sendError(res, err.message);
  }
};
