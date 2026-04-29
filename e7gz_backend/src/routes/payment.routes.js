import { Router } from 'express';
import { checkout, getMyTransactions } from '../controllers/payment.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = Router();

router.use(protect);

router.post('/checkout', checkout);
router.get('/my-transactions', getMyTransactions);

export default router;
