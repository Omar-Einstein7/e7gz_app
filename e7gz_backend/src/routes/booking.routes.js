import { Router } from 'express';
import {
  getAvailableSlots,
  createBooking,
  getMyBookings,
  getBookingById,
  cancelBooking,
} from '../controllers/booking.controller.js';
import { protect } from '../middleware/auth.middleware.js';
import { body } from 'express-validator';
import validate from '../middleware/validate.middleware.js';

const router = Router();

router.use(protect); // All booking routes require authentication

router.get('/pitch/:pitchId/slots', getAvailableSlots);
router.get('/', getMyBookings);
router.get('/:id', getBookingById);
router.delete('/:id', cancelBooking);

router.post(
  '/',
  [
    body('pitchId').notEmpty().withMessage('pitchId is required'),
    body('date')
      .matches(/^\d{4}-\d{2}-\d{2}$/)
      .withMessage('date must be YYYY-MM-DD'),
    body('startTime')
      .matches(/^\d{2}:\d{2}$/)
      .withMessage('startTime must be HH:mm'),
    body('endTime')
      .matches(/^\d{2}:\d{2}$/)
      .withMessage('endTime must be HH:mm'),
  ],
  validate,
  createBooking
);

export default router;
