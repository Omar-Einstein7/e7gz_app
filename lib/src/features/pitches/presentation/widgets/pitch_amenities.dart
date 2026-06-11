import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/presentation/widgets/widgets.dart';

class PitchAmenitiesSection extends StatelessWidget {
  final List<String> amenities;
  const PitchAmenitiesSection({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PitchSectionHeader(title: 'pitch_details.amenities'),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: amenities.map((amenity) {
            IconData iconData = IconsaxPlusLinear.star;
            if (amenity.toLowerCase().contains('shower')) {
              iconData = IconsaxPlusLinear.cloud_drizzle;
            }
            if (amenity.toLowerCase().contains('parking')) {
              iconData = IconsaxPlusLinear.car;
            }
            if (amenity.toLowerCase().contains('wifi')) {
              iconData = IconsaxPlusLinear.wifi;
            }
            if (amenity.toLowerCase().contains('cafe')) {
              iconData = IconsaxPlusLinear.cup;
            }
            return AmenityItem(label: amenity, icon: iconData);
          }).toList(),
        ),
      ],
    );
  }
}
