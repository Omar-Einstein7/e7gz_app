import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

class HomeData extends Equatable {
  final List<HomeBanner> banners;
  final List<HomeCategory> categories;
  final List<Pitch> featuredPitches;
  final List<Pitch> nearbyPitches;

  const HomeData({
    required this.banners,
    required this.categories,
    required this.featuredPitches,
    required this.nearbyPitches,
  });

  @override
  List<Object?> get props => [
    banners,
    categories,
    featuredPitches,
    nearbyPitches,
  ];
}

class HomeBanner extends Equatable {
  final String id;
  final String imageUrl;
  final String? link;

  const HomeBanner({required this.id, required this.imageUrl, this.link});

  @override
  List<Object?> get props => [id, imageUrl, link];
}

class HomeCategory extends Equatable {
  final String id;
  final String name;
  final String icon;

  const HomeCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}
