import '../../domain/entities/reward.dart';

class RewardModel extends Reward {
  const RewardModel({
    required super.id,
    required super.title,
    required super.description,
    required super.pointsCost,
    required super.icon,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pointsCost: json['pointsCost'] ?? 0,
      icon: json['icon'] ?? '',
    );
  }
}
