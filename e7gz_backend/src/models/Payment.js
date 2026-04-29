import mongoose from 'mongoose';

const paymentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    bookingId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Booking',
    },
    matchId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Match',
    },
    amount: {
      type: Number,
      required: true,
    },
    currency: {
      type: String,
      default: 'EGP',
    },
    paymentMethod: {
      type: String,
      enum: ['card', 'wallet', 'instapay', 'cash'],
      required: true,
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed', 'refunded'],
      default: 'pending',
    },
    transactionId: {
      type: String,
      unique: true,
    },
    metadata: {
      type: Map,
      of: String,
    },
  },
  { timestamps: true }
);

export default mongoose.model('Payment', paymentSchema);
