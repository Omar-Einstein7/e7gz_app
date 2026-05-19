import 'package:e7gz/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthInputLabel extends StatelessWidget {
  final String label;
  final bool isCompact;

  const AuthInputLabel({
    super.key,
    required this.label,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
        child: Text(
          label.toUpperCase(),
          style: context.typography.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
      child: Text(
        label,
        style: context.typography.labelMedium?.copyWith(
          color: context.colors.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
