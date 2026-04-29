import Booking from '../models/Booking.js';
import Pitch from '../models/Pitch.js';
import { sendSuccess, sendError } from '../utils/response.js';

/**
 * GET /api/owner/stats
 */
export const getOwnerStats = async (req, res) => {
  try {
    const ownerId = req.user.id;

    // Get all pitches for this owner
    const pitches = await Pitch.find({ ownerId });
    const pitchIds = pitches.map(p => p._id);

    // Calculate total revenue from confirmed/completed bookings
    const bookings = await Booking.find({
      pitchId: { $in: pitchIds },
      status: { $in: ['confirmed', 'completed'] }
    });

    const totalRevenue = bookings.reduce((sum, b) => sum + b.totalPrice, 0);
    const platformCommission = totalRevenue * 0.10; // 10% Platform fee
    const netEarnings = totalRevenue - platformCommission;

    // Active bookings (today and future)
    const activeBookingsCount = await Booking.countDocuments({
      pitchId: { $in: pitchIds },
      status: 'confirmed',
      date: { $gte: new Date().toISOString().split('T')[0] }
    });

    // Simple Monthly Revenue (current month)
    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();
    const monthlyRevenue = bookings
      .filter(b => {
        const d = new Date(b.date);
        return d.getMonth() === currentMonth && d.getFullYear() === currentYear;
      })
      .reduce((sum, b) => sum + b.totalPrice, 0);

    return sendSuccess(res, {
      stats: {
        totalRevenue,
        monthlyRevenue,
        platformCommission,
        netEarnings,
        activeBookingsCount,
        pitchesCount: pitches.length,
        loyaltyPoints: req.user.loyaltyPoints || 0
      }
    });
  } catch (err) {
    return sendError(res, err.message);
  }
};
