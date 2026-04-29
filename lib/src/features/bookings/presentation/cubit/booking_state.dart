import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';

// ─── My Bookings State ────────────────────────────────────────────────────────

enum BookingsStatus { initial, loading, success, failure }

class BookingsState extends Equatable {
  final BookingsStatus status;
  final List<Booking> bookings;
  final String? errorMessage;

  const BookingsState({
    this.status = BookingsStatus.initial,
    this.bookings = const [],
    this.errorMessage,
  });

  BookingsState copyWith({
    BookingsStatus? status,
    List<Booking>? bookings,
    String? errorMessage,
  }) {
    return BookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, errorMessage];
}

// ─── Booking Slots State ──────────────────────────────────────────────────────

enum SlotsStatus { initial, loading, success, failure }

class SlotsState extends Equatable {
  final SlotsStatus status;
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final String? selectedDate;
  final String? errorMessage;

  const SlotsState({
    this.status = SlotsStatus.initial,
    this.slots = const [],
    this.selectedSlot,
    this.selectedDate,
    this.errorMessage,
  });

  SlotsState copyWith({
    SlotsStatus? status,
    List<TimeSlot>? slots,
    TimeSlot? selectedSlot,
    String? selectedDate,
    String? errorMessage,
  }) {
    return SlotsState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, slots, selectedSlot, selectedDate, errorMessage];
}

// ─── Create Booking State ─────────────────────────────────────────────────────

enum CreateBookingStatus { initial, loading, success, failure }

class CreateBookingState extends Equatable {
  final CreateBookingStatus status;
  final Booking? createdBooking;
  final String? errorMessage;

  const CreateBookingState({
    this.status = CreateBookingStatus.initial,
    this.createdBooking,
    this.errorMessage,
  });

  CreateBookingState copyWith({
    CreateBookingStatus? status,
    Booking? createdBooking,
    String? errorMessage,
  }) {
    return CreateBookingState(
      status: status ?? this.status,
      createdBooking: createdBooking ?? this.createdBooking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, createdBooking, errorMessage];
}
