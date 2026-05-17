import 'package:e7gz/src/utils/typedefs.dart';
import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetMyBookingsUseCase {
  final BookingRepository _repository;
  const GetMyBookingsUseCase(this._repository);

  FutureEither<List<Booking>> call({BookingStatus? status}) =>
      _repository.getMyBookings(status: status);
}

class GetBookingDetailsUseCase {
  final BookingRepository _repository;
  const GetBookingDetailsUseCase(this._repository);

  FutureEither<Booking> call(String id) => _repository.getBookingById(id);
}

class CreateBookingUseCase {
  final BookingRepository _repository;
  const CreateBookingUseCase(this._repository);

  FutureEither<Booking> call({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
    String? notes,
  }) => _repository.createBooking(
    pitchId: pitchId,
    date: date,
    startTime: startTime,
    endTime: endTime,
    notes: notes,
  );
}

class CancelBookingUseCase {
  final BookingRepository _repository;
  const CancelBookingUseCase(this._repository);

  FutureEither<Booking> call(String bookingId) =>
      _repository.cancelBooking(bookingId);
}

class GetAvailableSlotsUseCase {
  final BookingRepository _repository;
  const GetAvailableSlotsUseCase(this._repository);

  FutureEither<List<TimeSlot>> call({
    required String pitchId,
    required String date,
  }) => _repository.getAvailableSlots(pitchId: pitchId, date: date);
}
