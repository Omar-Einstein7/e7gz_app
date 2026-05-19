import 'package:equatable/equatable.dart';

/// Domain entity for a single booking.
class Booking extends Equatable {
  final String id;
  final String userId;
  final String? userName;
  final String? userPhone;
  final String pitchId;
  final String pitchName;
  final String pitchAddress;
  final String? pitchImage;
  final double? pitchLatitude;
  final double? pitchLongitude;
  final String date; // "YYYY-MM-DD"
  final String startTime; // "HH:MM"
  final String endTime; // "HH:MM"
  final double totalPrice;
  final BookingStatus status;
  final String? paymentStatus;
  final String? notes;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    this.userName,
    this.userPhone,
    required this.pitchId,
    required this.pitchName,
    required this.pitchAddress,
    this.pitchImage,
    this.pitchLatitude,
    this.pitchLongitude,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    this.paymentStatus,
    this.notes,
    required this.createdAt,
  });

  factory Booking.empty() => Booking(
    id: '',
    userId: '',
    pitchId: '',
    pitchName: 'Stadium Name Placeholder',
    pitchAddress: 'Address Placeholder',
    date: '2025-01-01',
    startTime: '00:00',
    endTime: '00:00',
    totalPrice: 0,
    status: BookingStatus.confirmed,
    createdAt: DateTime.now(),
  );

  String get timeRange => '$startTime - $endTime';

  Booking copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? pitchId,
    String? pitchName,
    String? pitchAddress,
    String? pitchImage,
    double? pitchLatitude,
    double? pitchLongitude,
    String? date,
    String? startTime,
    String? endTime,
    double? totalPrice,
    BookingStatus? status,
    String? paymentStatus,
    String? notes,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      pitchId: pitchId ?? this.pitchId,
      pitchName: pitchName ?? this.pitchName,
      pitchAddress: pitchAddress ?? this.pitchAddress,
      pitchImage: pitchImage ?? this.pitchImage,
      pitchLatitude: pitchLatitude ?? this.pitchLatitude,
      pitchLongitude: pitchLongitude ?? this.pitchLongitude,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, pitchId, date, startTime, endTime, status];
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
