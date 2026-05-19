import 'package:e7gz/src/imports/core_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String role;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: AppRadius.blg.r,
          border: Border.all(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: colors.primary, size: 28),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  title,
                  style: typography.titleLarge?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  subtitle,
                  style: typography.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
