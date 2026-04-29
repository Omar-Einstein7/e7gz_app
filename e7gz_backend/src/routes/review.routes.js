import { Router } from 'express';
import { createReview } from '../controllers/review.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = Router();

router.use(protect);

router.post('/', createReview);

export default router;
