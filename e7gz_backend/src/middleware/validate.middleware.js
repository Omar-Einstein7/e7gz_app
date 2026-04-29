import { validationResult } from 'express-validator';
import { sendBadRequest } from '../utils/response.js';

/**
 * Middleware: Run after express-validator rules.
 * If there are validation errors, respond with 400.
 */
const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return sendBadRequest(
      res,
      'Validation failed',
      errors.array().map((e) => ({ field: e.path, message: e.msg }))
    );
  }
  next();
};

export default validate;
