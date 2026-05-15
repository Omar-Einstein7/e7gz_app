import '../../domain/entities/home_data.dart';
import '../../../pitches/data/models/pitch_model.dart';

class HomeModel extends HomeData {
  const HomeModel({
    required super.banners,
    required super.categories,
    required super.featuredPitches,
    required super.nearbyPitches,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      banners: (json['banners'] as List? ?? [])
          .map((e) => HomeBannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List? ?? [])
          .map((e) => HomeCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredPitches: (json['featuredPitches'] as List? ?? [])
          .map((e) => PitchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyPitches: (json['nearbyPitches'] as List? ?? [])
          .map((e) => PitchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HomeBannerModel extends HomeBanner {
  const HomeBannerModel({required super.id, required super.imageUrl, super.link});

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      link: json['link']?.toString(),
    );
  }
}

class HomeCategoryModel extends HomeCategory {
  const HomeCategoryModel({required super.id, required super.name, required super.icon});

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
    );
  }
}
