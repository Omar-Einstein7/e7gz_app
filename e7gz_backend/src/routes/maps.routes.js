import { Router } from 'express';
import { getRoute, geocode, reverseGeocode } from '../controllers/maps.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = Router();

router.use(protect); // ORS key is proxied; require auth to prevent abuse

router.get('/route', getRoute);
router.get('/geocode', geocode);
router.get('/reverse-geocode', reverseGeocode);

export default router;
