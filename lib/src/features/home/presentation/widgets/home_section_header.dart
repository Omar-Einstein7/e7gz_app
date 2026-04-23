
import 'package:e7gz/src/imports/imports.dart';
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showViewAll;
  final VoidCallback? onViewAllPressed;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.subtitle = 'CURATED FOR YOU',
    this.showViewAll = true,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle.toUpperCase(),
                  style: typography.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  title,
                  style: typography.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllPressed,
              child: Text(
                'View All',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            )
          else
            const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}
