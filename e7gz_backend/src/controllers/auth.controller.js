import User from '../models/User.js';
import { signToken } from '../utils/jwt.js';
import {
  sendSuccess,
  sendCreated,
  sendBadRequest,
  sendUnauthorized,
  sendError,
  sendNotFound,
} from '../utils/response.js';

// ─── Helpers ─────────────────────────────────────────────────────────────────

const formatUser = (user, token) => ({
  token,
  user: {
    id: user._id.toString(),
    name: user.name,
    email: user.email,
    phone: user.phone,
    photoUrl: user.photoUrl,
    role: user.role,
    loyaltyPoints: user.loyaltyPoints,
  },
});

// ─── Controllers ─────────────────────────────────────────────────────────────

/**
 * POST /api/auth/signup
 */
const signup = async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    const existing = await User.findOne({ email });
    if (existing) {
      return sendBadRequest(res, 'Email already in use');
    }

    const user = await User.create({ name, email, password, phone });
    const token = signToken({ id: user._id, role: user.role });

    return sendCreated(res, formatUser(user, token), 'Account created successfully');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * POST /api/auth/login
 */
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email }).select('+password');
    if (!user || !(await user.comparePassword(password))) {
      return sendUnauthorized(res, 'Invalid email or password');
    }

    const token = signToken({ id: user._id, role: user.role });

    return sendSuccess(res, formatUser(user, token), 'Login successful');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * POST /api/auth/logout
 */
const logout = async (req, res) => {
  // Stateless JWT: client just drops the token.
  return sendSuccess(res, null, 'Logged out successfully');
};

/**
 * POST /api/auth/forgot-password
 */
const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      // Don't reveal if email exists
      return sendSuccess(res, null, 'If this email is registered, a reset link has been sent');
    }
    // TODO: Send OTP email via nodemailer / SendGrid
    return sendSuccess(res, null, 'Password reset email sent');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * GET /api/auth/me
 */
const getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return sendNotFound(res, 'User not found');
    return sendSuccess(res, formatUser(user, null));
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * PUT /api/auth/me
 */
const updateMe = async (req, res) => {
  try {
    const allowedFields = ['name', 'phone', 'photoUrl'];
    const updates = {};
    allowedFields.forEach((field) => {
      if (req.body[field] !== undefined) updates[field] = req.body[field];
    });

    const user = await User.findByIdAndUpdate(req.user.id, updates, {
      new: true,
      runValidators: true,
    });

    return sendSuccess(res, formatUser(user, null), 'Profile updated');
  } catch (err) {
    return sendError(res, err.message);
  }
};

export { signup, login, logout, forgotPassword, getMe, updateMe };
