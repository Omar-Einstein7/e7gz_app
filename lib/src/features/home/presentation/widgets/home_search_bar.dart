import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/imports.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: () => StatefulNavigationShell.of(context).goBranch(1),
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Row(
            children: [
              Icon(
                IconsaxPlusLinear.search_normal_1,
                color: colors.onSurfaceVariant,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'home.search_placeholder'.tr(),
                  style: TextStyle(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
