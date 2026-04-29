import { verifyToken } from '../utils/jwt.js';
import User from '../models/User.js';
import { sendUnauthorized, sendForbidden } from '../utils/response.js';

/**
 * Middleware: Require a valid JWT token in Authorization header.
 * Attaches req.user = { id, role } on success.
 */
const protect = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return sendUnauthorized(res, 'No token provided');
    }

    const token = authHeader.split(' ')[1];
    const decoded = verifyToken(token);
    if (!decoded) {
      return sendUnauthorized(res, 'Invalid or expired token');
    }

    const user = await User.findById(decoded.id).select('_id role email name');
    if (!user) {
      return sendUnauthorized(res, 'User no longer exists');
    }

    req.user = { id: user._id.toString(), role: user.role, email: user.email, name: user.name };
    next();
  } catch (err) {
    return sendUnauthorized(res, err.message);
  }
};

/**
 * Middleware factory: Restrict to specific roles.
 * Usage: restrictTo('admin', 'owner')
 */
const restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user?.role)) {
      return sendForbidden(res, 'You do not have permission to perform this action');
    }
    next();
  };
};

export { protect, restrictTo };
