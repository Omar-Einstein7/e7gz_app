import 'package:e7gz/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialJoinDivider extends StatelessWidget {
  const SocialJoinDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      children: [
        Expanded(child: Divider(color: colors.outlineVariant)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Text(
            'auth.or_continue_with'.tr().toUpperCase(),
            style: typography.labelSmall?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.outlineVariant)),
      ],
    );
  }
}
