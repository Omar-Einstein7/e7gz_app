import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';

abstract class BookingRepository {
  /// Get the current user's bookings (optionally filtered by status).
  FutureEither<List<Booking>> getMyBookings({BookingStatus? status});

  /// Get a single booking by ID.
  FutureEither<Booking> getBookingById(String id);

  /// Create a new booking.
  FutureEither<Booking> createBooking({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
    String? notes,
  });

  /// Cancel a booking.
  FutureEither<Booking> cancelBooking(String bookingId);

  /// Get available time slots for a pitch on a given date.
  FutureEither<List<TimeSlot>> getAvailableSlots({
    required String pitchId,
    required String date,
  });
}
