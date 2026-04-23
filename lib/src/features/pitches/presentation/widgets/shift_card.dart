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
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(32.r),
          border: isSelected
              ? Border.all(color: const Color(0xFF4BE277), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle.toUpperCase(),
                    style: typography.labelSmall?.copyWith(
                      color: isSelected ? const Color(0xFF4BE277) : const Color(0xFFBCC7DE),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    title,
                    style: typography.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    timeRange,
                    style: TextStyle(
                      color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: '$price ',
                    style: typography.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: 'EGP / HOUR',
                        style: TextStyle(
                          color: const Color(0xFFBCC7DE),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
