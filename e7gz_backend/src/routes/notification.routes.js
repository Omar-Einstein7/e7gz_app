import { Router } from 'express';
import { getMyNotifications, markAllRead } from '../controllers/notification.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = Router();

router.use(protect);

router.get('/', getMyNotifications);
router.put('/mark-read', markAllRead);

export default router;
