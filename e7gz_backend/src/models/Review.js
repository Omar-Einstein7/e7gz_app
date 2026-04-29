import mongoose from 'mongoose';

const reviewSchema = new mongoose.Schema(
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
    rating: {
      type: Number,
      required: [true, 'Rating is required'],
      min: 1,
      max: 5,
    },
    comment: {
      type: String,
      trim: true,
      maxlength: 500,
    },
  },
  { timestamps: true }
);

// Update Pitch rating when a review is added
reviewSchema.post('save', async function () {
  const Pitch = mongoose.model('Pitch');
  const stats = await mongoose.model('Review').aggregate([
    { $match: { pitchId: this.pitchId } },
    {
      $group: {
        _id: '$pitchId',
        nRating: { $sum: 1 },
        avgRating: { $avg: '$rating' },
      },
    },
  ]);

  if (stats.length > 0) {
    await Pitch.findByIdAndUpdate(this.pitchId, {
      rating: stats[0].avgRating.toFixed(1),
      reviewsCount: stats[0].nRating,
    });
  }
});

export default mongoose.model('Review', reviewSchema);
