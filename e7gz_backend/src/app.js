
import dotenv from 'dotenv';

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

import connectDB from './config/db.js';
import authRoutes from './routes/auth.routes.js';
import pitchRoutes from './routes/pitch.routes.js';
import bookingRoutes from './routes/booking.routes.js';
import mapsRoutes from './routes/maps.routes.js';
import matchRoutes from './routes/match.routes.js';
import reviewRoutes from './routes/review.routes.js';
import ownerRoutes from './routes/owner.routes.js';
import paymentRoutes from './routes/payment.routes.js';
import notificationRoutes from './routes/notification.routes.js';
dotenv.config();
import dns from "node:dns/promises";
dns.setServers(["1.1.1.1", "8.8.8.8"]);

// ─── Connect DB ───────────────────────────────────────────────────────────────
connectDB();

// ─── App Setup ────────────────────────────────────────────────────────────────
const app = express();

app.use(helmet());
app.use(cors({ origin: '*' })); // Restrict to your app's domain in production
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ─── Health Check ─────────────────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// ─── API Routes ───────────────────────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/pitches', pitchRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/maps', mapsRoutes);
app.use('/api/matches', matchRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/owner', ownerRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/notifications', notificationRoutes);

// ─── 404 Handler ──────────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.originalUrl} not found` });
});

// ─── Global Error Handler ─────────────────────────────────────────────────────
app.use((err, req, res, _next) => {
  console.error('💥 Unhandled error:', err);
  res.status(500).json({ success: false, message: err.message || 'Internal Server Error' });
});

// ─── Start ────────────────────────────────────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 E7gzz API running on http://localhost:${PORT}`);
});


