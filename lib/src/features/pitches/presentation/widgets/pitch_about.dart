import 'package:e7gz/src/imports/core_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widgets.dart';

class PitchAboutSection extends StatelessWidget {
  final String description;
  const PitchAboutSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PitchSectionHeader(title: 'pitch_details.description'),
        SizedBox(height: AppSpacing.md.h),
        Text(
          description.isNotEmpty
              ? description
              : "Featuring high-grade FIFA certified artificial turf, this pitch offers a premium playing surface that reduces injury risk and ensures optimal ball roll.",
          style: context.typography.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}
