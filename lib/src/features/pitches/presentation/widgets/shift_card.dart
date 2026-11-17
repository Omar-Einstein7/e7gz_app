import 'package:e7gz/src/imports/imports.dart';

class ShiftCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String timeRange;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const ShiftCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.timeRange,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.surfaceContainerHighest
              : cs.surfaceContainer,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? cs.primary.withValues(alpha: 0.5)
                : cs.outlineVariant,
            width: 1.5,
          ),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.15)
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
                size: 24,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle.toUpperCase(),
                    style: typography.labelSmall?.copyWith(
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: typography.titleMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: cs.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        timeRange,
                        style: typography.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: typography.titleLarge?.copyWith(
                    color: isSelected ? cs.primary : cs.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'EGP / HR',
                  style: typography.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
