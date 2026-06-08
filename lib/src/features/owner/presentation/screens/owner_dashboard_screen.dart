import 'dart:ui';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_state.dart';
import 'package:e7gz/src/features/owner/presentation/screens/owner_home_screen.dart';
import 'package:e7gz/src/features/owner/presentation/screens/owner_pitches_screen.dart';
import 'package:e7gz/src/features/owner/presentation/screens/owner_revenue_screen.dart';
import 'package:e7gz/src/features/owner/presentation/screens/owner_profile_screen.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/owner_nav_item.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerCubit>().loadDashboardData();
    });
  }

  final List<_TabConfig> _tabs = const [
    _TabConfig('Home', IconsaxPlusBold.element_3, IconsaxPlusLinear.element_3),
    _TabConfig('Pitches', IconsaxPlusBold.ranking, IconsaxPlusLinear.ranking),
    _TabConfig(
      'Revenue',
      IconsaxPlusBold.empty_wallet_tick,
      IconsaxPlusLinear.empty_wallet_tick,
    ),
    _TabConfig('Profile', IconsaxPlusBold.user, IconsaxPlusLinear.user),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerCubit, OwnerState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(child: _buildBody(context, state)),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OwnerState state) {
    // Global loading (first load, no data yet)
    if (state.status == OwnerStatus.loading &&
        state.stats.isEmpty &&
        state.myPitches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.colors.primary),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'Loading dashboard...',
              style: context.typography.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return IndexedStack(
      index: _currentTab,
      children: [
        OwnerHomeScreen(state: state),
        OwnerPitchesScreen(state: state),
        OwnerRevenueScreen(state: state),
        const OwnerProfileScreen(),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.sm.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              return Expanded(
                child: OwnerNavItem(
                  label: tab.label,
                  icon: tab.inactiveIcon,
                  activeIcon: tab.activeIcon,
                  isSelected: _currentTab == index,
                  onTap: () => setState(() => _currentTab = index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  const _TabConfig(this.label, this.activeIcon, this.inactiveIcon);
}
