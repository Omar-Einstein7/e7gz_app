import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

/// The main application scaffold that handles bottom navigation with [StatefulNavigationShell].
class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding > 0 ? bottomPadding : AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: cs.background,
        border: Border(top: BorderSide(color: cs.outlineVariant, width: 1)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: AppSpacing.sm.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _NavItem(
                    label: 'nav.home'.tr(),
                    icon: IconsaxPlusLinear.home,
                    activeIcon: IconsaxPlusBold.home,
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'nav.search'.tr(),
                    icon: IconsaxPlusLinear.search_normal_1,
                    activeIcon: IconsaxPlusBold.search_normal_1,
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'nav.matches'.tr(),
                    icon: IconsaxPlusLinear.user_octagon,
                    activeIcon: IconsaxPlusBold.user_octagon,
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'nav.bookings'.tr(),
                    icon: IconsaxPlusLinear.calendar_1,
                    activeIcon: IconsaxPlusBold.calendar_1,
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'nav.profile'.tr(),
                    icon: IconsaxPlusLinear.user,
                    activeIcon: IconsaxPlusBold.user,
                    isSelected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppRadius.bxxl.r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                  size: 24.sp,
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 200.ms,
                )
                .shimmer(
                  delay: 200.ms,
                  duration: 1000.ms,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
