import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/bookings/domain/repositories/booking_repository.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/features/bookings/data/datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remote;

  const BookingRepositoryImpl(this._remote);

  @override
  FutureEither<List<Booking>> getMyBookings({BookingStatus? status}) async {
    return runTask(() async {
      final bookings = await _remote.getMyBookings(status: status?.name);
      return bookings;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<Booking> getBookingById(String id) async {
    return runTask(() async {
      final booking = await _remote.getBookingById(id);
      return booking;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<Booking> createBooking({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    return runTask(() async {
      final booking = await _remote.createBooking(
        pitchId: pitchId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        notes: notes,
      );
      return booking;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<Booking> cancelBooking(String bookingId) async {
    return runTask(() async {
      final booking = await _remote.cancelBooking(bookingId);
      return booking;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<TimeSlot>> getAvailableSlots({
    required String pitchId,
    required String date,
  }) async {
    return runTask(() async {
      final slots = await _remote.getAvailableSlots(
        pitchId: pitchId,
        date: date,
      );
      return slots;
    }, requiresNetwork: true);
  }
}
