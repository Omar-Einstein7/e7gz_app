import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/bookings/domain/usecases/booking_usecases.dart';
import 'booking_state.dart';

// ─── My Bookings Cubit ────────────────────────────────────────────────────────

class BookingsCubit extends Cubit<BookingsState> {
  final GetMyBookingsUseCase _getMyBookings;
  final CancelBookingUseCase _cancelBooking;

  BookingsCubit({
    required GetMyBookingsUseCase getMyBookings,
    required CancelBookingUseCase cancelBooking,
  }) : _getMyBookings = getMyBookings,
       _cancelBooking = cancelBooking,
       super(const BookingsState());

  Future<void> loadBookings({BookingStatus? status}) async {
    emit(state.copyWith(status: BookingsStatus.loading));
    final result = await _getMyBookings(status: status);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bookings) => emit(
        state.copyWith(status: BookingsStatus.success, bookings: bookings),
      ),
    );
  }

  Future<void> cancelBooking(String bookingId) async {
    final result = await _cancelBooking(bookingId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cancelled) {
        final updated = state.bookings.map((b) {
          return b.id == bookingId ? cancelled : b;
        }).toList();
        emit(state.copyWith(status: BookingsStatus.success, bookings: updated));
      },
    );
  }
}

// ─── Slots Cubit ──────────────────────────────────────────────────────────────

class SlotsCubit extends Cubit<SlotsState> {
  final GetAvailableSlotsUseCase _getAvailableSlots;
  final String pitchId;

  SlotsCubit({
    required GetAvailableSlotsUseCase getAvailableSlots,
    required this.pitchId,
  }) : _getAvailableSlots = getAvailableSlots,
       super(const SlotsState());

  Future<void> loadSlots(String date) async {
    emit(
      state.copyWith(
        status: SlotsStatus.loading,
        selectedDate: date,
        selectedSlot: null,
      ),
    );
    final result = await _getAvailableSlots(pitchId: pitchId, date: date);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SlotsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (slots) =>
          emit(state.copyWith(status: SlotsStatus.success, slots: slots)),
    );
  }

  void selectSlot(TimeSlot slot) {
    if (!slot.isAvailable) return;
    emit(state.copyWith(selectedSlot: slot));
  }
}

// ─── Create Booking Cubit ─────────────────────────────────────────────────────

class CreateBookingCubit extends Cubit<CreateBookingState> {
  final CreateBookingUseCase _createBooking;

  CreateBookingCubit({required CreateBookingUseCase createBooking})
    : _createBooking = createBooking,
      super(const CreateBookingState());

  Future<void> createBooking({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    emit(state.copyWith(status: CreateBookingStatus.loading));
    final result = await _createBooking(
      pitchId: pitchId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      notes: notes,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateBookingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (booking) => emit(
        state.copyWith(
          status: CreateBookingStatus.success,
          createdBooking: booking,
        ),
      ),
    );
  }

  void reset() => emit(const CreateBookingState());
}
