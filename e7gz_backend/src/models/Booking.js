import mongoose from 'mongoose';
import User from './User.js';

const bookingSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    pitchId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Pitch',
      required: true,
    },
    date: {
      type: String, // 'YYYY-MM-DD'
      required: true,
    },
    startTime: {
      type: String, // 'HH:mm'
      required: true,
    },
    endTime: {
      type: String, // 'HH:mm'
      required: true,
    },
    totalPrice: {
      type: Number,
      required: true,
      min: 0,
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'cancelled', 'completed'],
      default: 'confirmed',
    },
    paymentStatus: {
      type: String,
      enum: ['unpaid', 'paid', 'refunded'],
      default: 'unpaid',
    },
    notes: {
      type: String,
    },
  },
  { timestamps: true }
);

// Compound index to prevent double-bookings
bookingSchema.index({ pitchId: 1, date: 1, startTime: 1 }, { unique: true });

// Award loyalty points on booking
bookingSchema.post('save', async function (doc) {
  if (doc.status === 'confirmed') {
    const points = Math.floor(doc.totalPrice / 10);
    await User.findByIdAndUpdate(doc.userId, {
      $inc: { loyaltyPoints: points },
    });
  }
});

export default mongoose.model('Booking', bookingSchema);
