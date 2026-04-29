import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/bookings/domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remote;

  const BookingRepositoryImpl(this._remote);

  @override
  FutureEither<List<Booking>> getMyBookings({BookingStatus? status}) async {
    try {
      final bookings =
          await _remote.getMyBookings(status: status?.name);
      return right(bookings);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Booking> getBookingById(String id) async {
    try {
      final booking = await _remote.getBookingById(id);
      return right(booking);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Booking> createBooking({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    try {
      final booking = await _remote.createBooking(
        pitchId: pitchId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        notes: notes,
      );
      return right(booking);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Booking> cancelBooking(String bookingId) async {
    try {
      final booking = await _remote.cancelBooking(bookingId);
      return right(booking);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<TimeSlot>> getAvailableSlots({
    required String pitchId,
    required String date,
  }) async {
    try {
      final slots =
          await _remote.getAvailableSlots(pitchId: pitchId, date: date);
      return right(slots);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
