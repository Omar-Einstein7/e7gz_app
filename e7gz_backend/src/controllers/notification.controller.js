import Notification from '../models/Notification.js';
import { sendSuccess, sendError } from '../utils/response.js';

/**
 * GET /api/notifications
 */
export const getMyNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ userId: req.user.id })
      .sort({ createdAt: -1 })
      .limit(50);

    return sendSuccess(res, { notifications });
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * PUT /api/notifications/mark-read
 */
export const markAllRead = async (req, res) => {
  try {
    await Notification.updateMany({ userId: req.user.id, isRead: false }, { isRead: true });
    return sendSuccess(res, null, 'All notifications marked as read');
  } catch (err) {
    return sendError(res, err.message);
  }
};

/**
 * Helper to create a notification
 */
export const createNotification = async (userId, title, body, type = 'system', metadata = {}) => {
  try {
    await Notification.create({ userId, title, body, type, metadata });
  } catch (err) {
    console.error('Failed to create notification:', err.message);
  }
};
