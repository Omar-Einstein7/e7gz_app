import mongoose from 'mongoose';

const pitchSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Pitch name is required'],
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    sportType: {
      type: String,
      enum: ['football', 'basketball', 'tennis', 'padel', 'volleyball', 'multi'],
      default: 'football',
    },
    location: {
      address: { type: String, required: true },
      city: { type: String, required: true },
      country: { type: String, default: 'Egypt' },
      // GeoJSON for geospatial queries
      coordinates: {
        type: {
          type: String,
          enum: ['Point'],
          default: 'Point',
        },
        coordinates: {
          type: [Number], // [longitude, latitude]
          required: true,
        },
      },
    },
    pricePerHour: {
      type: Number,
      required: [true, 'Price per hour is required'],
      min: 0,
    },
    amenities: {
      type: [String],
      default: [],
    },
    images: {
      type: [String],
      default: [],
    },
    rating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },
    reviewsCount: {
      type: Number,
      default: 0,
    },
    isAvailable: {
      type: Boolean,
      default: true,
    },
    openingTime: {
      type: String,
      default: '06:00', // HH:mm
    },
    closingTime: {
      type: String,
      default: '24:00',
    },
    slotDurationMinutes: {
      type: Number,
      default: 60,
    },
  },
  { timestamps: true }
);

// Create 2dsphere index for geo queries
pitchSchema.index({ 'location.coordinates': '2dsphere' });

export default mongoose.model('Pitch', pitchSchema);
