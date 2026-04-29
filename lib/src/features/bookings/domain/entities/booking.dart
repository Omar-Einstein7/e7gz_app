import 'package:equatable/equatable.dart';

/// Domain entity for a single booking.
class Booking extends Equatable {
  final String id;
  final String userId;
  final String pitchId;
  final String pitchName;
  final String pitchAddress;
  final String? pitchImage;
  final String date;        // "YYYY-MM-DD"
  final String startTime;   // "HH:MM"
  final String endTime;     // "HH:MM"
  final double totalPrice;
  final BookingStatus status;
  final String? paymentStatus;
  final String? notes;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.pitchId,
    required this.pitchName,
    required this.pitchAddress,
    this.pitchImage,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    this.paymentStatus,
    this.notes,
    required this.createdAt,
  });

  String get timeRange => '$startTime - $endTime';

  @override
  List<Object?> get props =>
      [id, pitchId, date, startTime, endTime, status];
}

enum BookingStatus { pending, confirmed, cancelled, completed }

extension BookingStatusX on BookingStatus {
  String get name {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.completed:
        return 'completed';
    }
  }

  static BookingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }
}

/// A single available time slot.
class TimeSlot extends Equatable {
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final double price;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.price,
  });

  String get label => '$startTime - $endTime';

  @override
  List<Object?> get props => [startTime, endTime, isAvailable];
}
