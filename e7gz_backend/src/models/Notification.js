import mongoose from 'mongoose';

const notificationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      enum: ['booking', 'match', 'system', 'loyalty'],
      default: 'system',
    },
    isRead: {
      type: Boolean,
      default: false,
    },
    metadata: {
      type: Map,
      of: String,
    },
  },
  { timestamps: true }
);

export default mongoose.model('Notification', notificationSchema);
