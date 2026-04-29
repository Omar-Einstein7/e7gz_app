import { Router } from 'express';
import { body } from 'express-validator';
import {
  signup,
  login,
  logout,
  forgotPassword,
  getMe,
  updateMe,
} from '../controllers/auth.controller.js';
import { protect } from '../middleware/auth.middleware.js';
import validate from '../middleware/validate.middleware.js';

const router = Router();

router.post(
  '/signup',
  [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Valid email is required'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  ],
  validate,
  signup
);

router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Valid email is required'),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  validate,
  login
);

router.post('/logout', protect, logout);
router.post('/forgot-password', forgotPassword);
router.get('/me', protect, getMe);
router.put('/me', protect, updateMe);

export default router;
