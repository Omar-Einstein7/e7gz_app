import 'package:e7gz/src/imports/imports.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLogout;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isLogout = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    final bgColor = isLogout
        ? cs.errorContainer.withValues(alpha: 0.1)
        : cs.surfaceContainerLow;
    final iconBgColor = isLogout
        ? cs.errorContainer.withValues(alpha: 0.2)
        : cs.surfaceContainerHigh;
    final iconColor = isLogout ? cs.error : cs.primary;
    final textColor = cs.onSurface;
    final subtitleColor = cs.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.bxl.r,
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: AppRadius.blg.r,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: typography.bodySmall?.copyWith(color: subtitleColor),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: subtitleColor.withValues(alpha: 0.3),
                ),
          ],
        ),
      ),
    );
  }
}
