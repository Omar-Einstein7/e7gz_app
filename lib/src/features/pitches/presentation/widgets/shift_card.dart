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
    final typography = context.typography;
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D2942) : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4BE277).withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4BE277).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4BE277).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
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
                    ? const Color(0xFF4BE277).withValues(alpha: 0.1)
                    : const Color(0xFF171F33),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF4BE277)
                    : const Color(0xFFBCC7DE),
                size: 24.sp,
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
                      color: isSelected
                          ? const Color(0xFF4BE277)
                          : const Color(0xFFBCC7DE),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: typography.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: const Color(0xFFBCC7DE).withValues(alpha: 0.4),
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        timeRange,
                        style: TextStyle(
                          color: const Color(0xFFBCC7DE).withValues(alpha: 0.6),
                          fontSize: 12.sp,
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
                  style: typography.headlineSmall?.copyWith(
                    color: isSelected ? const Color(0xFF4BE277) : Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22.sp,
                  ),
                ),
                Text(
                  'EGP / HR',
                  style: TextStyle(
                    color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
                    fontSize: 9.sp,
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
