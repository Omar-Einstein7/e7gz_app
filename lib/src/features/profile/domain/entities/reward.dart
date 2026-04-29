import 'package:equatable/equatable.dart';

class Reward extends Equatable {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String icon;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, description, pointsCost, icon];
}
