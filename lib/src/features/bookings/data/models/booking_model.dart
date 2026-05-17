import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    super.userName,
    super.userPhone,
    required super.pitchId,
    required super.pitchName,
    required super.pitchAddress,
    super.pitchImage,
    super.pitchLatitude,
    super.pitchLongitude,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.totalPrice,
    required super.status,
    super.paymentStatus,
    super.notes,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // pitchId can be a string or a populated object from backend
    final pitchRaw = json['pitchId'];
    final String pitchId;
    final String pitchName;
    final String pitchAddress;
    String? pitchImage;
    double? pitchLatitude;
    double? pitchLongitude;

    if (pitchRaw is Map<String, dynamic>) {
      pitchId = pitchRaw['_id']?.toString() ?? '';
      pitchName = pitchRaw['name'] ?? '';
      final loc = pitchRaw['location'] as Map<String, dynamic>? ?? {};
      pitchAddress = loc['address'] ?? '';
      final images = pitchRaw['images'] as List<dynamic>? ?? [];
      pitchImage = images.isNotEmpty ? images.first.toString() : null;
      final coords = loc['coordinates']?['coordinates'];
      if (coords is List && coords.length >= 2) {
        pitchLongitude = (coords[0] as num?)?.toDouble();
        pitchLatitude = (coords[1] as num?)?.toDouble();
      }
    } else {
      pitchId = pitchRaw?.toString() ?? '';
      pitchName = '';
      pitchAddress = '';
    }

    final userRaw = json['user'] ?? json['userId'];
    final String? userName;
    final String? userPhone;
    if (userRaw is Map<String, dynamic>) {
      userName = userRaw['name']?.toString();
      userPhone = userRaw['phone']?.toString();
    } else {
      userName = null;
      userPhone = null;
    }

    return BookingModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: _extractId(json['userId']),
      userName: userName,
      userPhone: userPhone,
      pitchId: pitchId,
      pitchName: pitchName,
      pitchAddress: pitchAddress,
      pitchImage: pitchImage,
      pitchLatitude: pitchLatitude,
      pitchLongitude: pitchLongitude,
      date: json['date']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: BookingStatusX.fromString(json['status']?.toString() ?? ''),
      paymentStatus: json['paymentStatus']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  static String _extractId(dynamic val) {
    if (val == null) return '';
    if (val is String) return val;
    if (val is Map) return val['_id']?.toString() ?? '';
    return '';
  }

  static DateTime _parseDate(dynamic val) {
    if (val == null) return DateTime.now();
    try {
      return DateTime.parse(val.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => {
    'pitchId': pitchId,
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    if (notes != null) 'notes': notes,
  };
}

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
    required super.price,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
