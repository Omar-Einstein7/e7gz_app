import axios from 'axios';
import { sendSuccess, sendBadRequest, sendError } from '../utils/response.js';

const ORS_BASE = process.env.ORS_BASE_URL || 'https://api.openrouteservice.org';
const ORS_KEY = process.env.ORS_API_KEY;

// ─── Get Driving Route ────────────────────────────────────────────────────────

/**
 * GET /api/maps/route
 * Query: fromLat, fromLng, toLat, toLng, profile (driving-car | cycling | foot-walking)
 */
const getRoute = async (req, res) => {
  try {
    const { fromLat, fromLng, toLat, toLng, profile = 'driving-car' } = req.query;

    if (!fromLat || !fromLng || !toLat || !toLng) {
      return sendBadRequest(res, 'fromLat, fromLng, toLat, toLng are all required');
    }

    const response = await axios.post(
      `${ORS_BASE}/v2/directions/${profile}`,
      {
        coordinates: [
          [parseFloat(fromLng), parseFloat(fromLat)],
          [parseFloat(toLng), parseFloat(toLat)],
        ],
      },
      {
        headers: {
          Authorization: ORS_KEY,
          'Content-Type': 'application/json',
        },
      }
    );

    const route = response.data.routes?.[0];
    if (!route) return sendBadRequest(res, 'No route found');

    const summary = route.summary;
    const geometry = route.geometry; // encoded polyline

    return sendSuccess(res, {
      distanceMeters: summary.distance,
      durationSeconds: summary.duration,
      geometry, // pass this to flutter_map for polyline decoding
    });
  } catch (err) {
    const orsError = err.response?.data?.error?.message || err.message;
    return sendError(res, `Route error: ${orsError}`);
  }
};

// ─── Forward Geocode ──────────────────────────────────────────────────────────

/**
 * GET /api/maps/geocode?address=...
 */
const geocode = async (req, res) => {
  try {
    const { address } = req.query;
    if (!address) return sendBadRequest(res, 'address query param is required');

    const response = await axios.get(`${ORS_BASE}/geocode/search`, {
      params: {
        api_key: ORS_KEY,
        text: address,
        size: 5,
      },
    });

    const features = response.data.features || [];
    const results = features.map((f) => ({
      label: f.properties.label,
      lat: f.geometry.coordinates[1],
      lng: f.geometry.coordinates[0],
    }));

    return sendSuccess(res, { results });
  } catch (err) {
    return sendError(res, err.message);
  }
};

// ─── Reverse Geocode ──────────────────────────────────────────────────────────

/**
 * GET /api/maps/reverse-geocode?lat=...&lng=...
 */
const reverseGeocode = async (req, res) => {
  try {
    const { lat, lng } = req.query;
    if (!lat || !lng) return sendBadRequest(res, 'lat and lng are required');

    const response = await axios.get(`${ORS_BASE}/geocode/reverse`, {
      params: {
        api_key: ORS_KEY,
        'point.lat': lat,
        'point.lon': lng,
        size: 1,
      },
    });

    const feature = response.data.features?.[0];
    if (!feature) return sendSuccess(res, { address: null });

    return sendSuccess(res, {
      address: feature.properties.label,
      city: feature.properties.locality || feature.properties.county,
      country: feature.properties.country,
    });
  } catch (err) {
    return sendError(res, err.message);
  }
};

export { getRoute, geocode, reverseGeocode };
