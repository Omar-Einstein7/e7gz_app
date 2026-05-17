import 'package:equatable/equatable.dart';

class AdminStats extends Equatable {
  final double totalRevenue;
  final int totalBookings;
  final int pitchCount;
  final int userCount;

  const AdminStats({
    required this.totalRevenue,
    required this.totalBookings,
    required this.pitchCount,
    required this.userCount,
  });

  @override
  List<Object?> get props => [
    totalRevenue,
    totalBookings,
    pitchCount,
    userCount,
  ];
}
