import { Router } from 'express';
import {
  getMatches,
  createMatch,
  joinMatch,
  getMatchById,
} from '../controllers/match.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = Router();

router.get('/', getMatches);
router.get('/:id', getMatchById);

router.use(protect);

router.post('/', createMatch);
router.post('/:id/join', joinMatch);

export default router;
