
import 'package:e7gz/src/imports/imports.dart';
import 'package:easy_localization/easy_localization.dart';
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllPressed,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Text(
                  'home.view_all'.tr(),
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
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
