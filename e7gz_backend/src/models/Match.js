import mongoose from 'mongoose';

const matchSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Match title is required'],
      trim: true,
    },
    pitchId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Pitch',
      required: true,
    },
    creatorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
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
    maxPlayers: {
      type: Number,
      required: true,
      min: 2,
    },
    participantIds: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    ],
    pricePerPlayer: {
      type: Number,
      required: true,
    },
    skillLevel: {
      type: String,
      enum: ['beginner', 'intermediate', 'advanced', 'all'],
      default: 'all',
    },
    status: {
      type: String,
      enum: ['open', 'full', 'completed', 'cancelled'],
      default: 'open',
    },
    bookingId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Booking',
    },
  },
  { timestamps: true }
);

// Virtual to check if match is full
matchSchema.virtual('isFull').get(function () {
  return this.participantIds.length >= this.maxPlayers;
});

// Auto-update status when participant joins
matchSchema.pre('save', function (next) {
  if (this.participantIds.length >= this.maxPlayers) {
    this.status = 'full';
  } else if (this.status === 'full' && this.participantIds.length < this.maxPlayers) {
    this.status = 'open';
  }
  next();
});

export default mongoose.model('Match', matchSchema);
