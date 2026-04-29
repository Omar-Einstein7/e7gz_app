/**
 * Standardised API response helpers.
 */

const sendSuccess = (res, data, message = 'Success', statusCode = 200) => {
  return res.status(statusCode).json({
    success: true,
    message,
    data,
  });
};

const sendCreated = (res, data, message = 'Created successfully') => {
  return sendSuccess(res, data, message, 201);
};

const sendError = (res, message = 'Something went wrong', statusCode = 500, errors = null) => {
  const body = { success: false, message };
  if (errors) body.errors = errors;
  return res.status(statusCode).json(body);
};

const sendNotFound = (res, message = 'Resource not found') => {
  return sendError(res, message, 404);
};

const sendUnauthorized = (res, message = 'Unauthorized') => {
  return sendError(res, message, 401);
};

const sendForbidden = (res, message = 'Forbidden') => {
  return sendError(res, message, 403);
};

const sendBadRequest = (res, message = 'Bad request', errors = null) => {
  return sendError(res, message, 400, errors);
};

export {
  sendSuccess,
  sendCreated,
  sendError,
  sendNotFound,
  sendUnauthorized,
  sendForbidden,
  sendBadRequest,
};
