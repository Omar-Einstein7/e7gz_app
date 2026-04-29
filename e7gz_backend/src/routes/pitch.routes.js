import { Router } from 'express';
import {
  getPitches,
  getNearbyPitches,
  getPitchById,
  createPitch,
  updatePitch,
  deletePitch,
  getOwnerPitches,
} from '../controllers/pitch.controller.js';
import { protect, restrictTo } from '../middleware/auth.middleware.js';
import { getPitchReviews } from '../controllers/review.controller.js';

const router = Router();

router.get('/', getPitches);
router.get('/nearby', getNearbyPitches);
router.get('/:id', getPitchById);
router.get('/:id/reviews', getPitchReviews);

router.use(protect); // all routes below require login

router.get('/owner/my-pitches', restrictTo('owner', 'admin'), getOwnerPitches);
router.post('/', restrictTo('owner', 'admin'), createPitch);
router.put('/:id', restrictTo('owner', 'admin'), updatePitch);
router.delete('/:id', restrictTo('owner', 'admin'), deletePitch);

export default router;
