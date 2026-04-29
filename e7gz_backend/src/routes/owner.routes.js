import { Router } from 'express';
import { getOwnerStats } from '../controllers/owner.controller.js';
import { protect, restrictTo } from '../middleware/auth.middleware.js';

const router = Router();

router.use(protect);
router.use(restrictTo('owner', 'admin'));

router.get('/stats', getOwnerStats);

export default router;
