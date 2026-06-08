import 'package:e7gz/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderBranding extends StatelessWidget {
  const HeaderBranding({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      children: [
        Text(
          'e7gzz',
          style: typography.displaySmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'auth.join_arena'.tr(),
          style: typography.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'auth.join_arena_subtitle'.tr(),
          textAlign: TextAlign.center,
          style: typography.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
