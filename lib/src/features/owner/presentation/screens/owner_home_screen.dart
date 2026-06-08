import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_state.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/section_label.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/stat_card.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/pitch_card.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/empty_pitches.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class OwnerHomeScreen extends StatelessWidget {
  final OwnerState state;
  const OwnerHomeScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final colors = context.colors;
    final tt = context.typography;

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<OwnerCubit>().loadDashboardData(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: colors.surface,
            floating: true,
            pinned: false,
            actions: [
              IconButton(
                icon: Icon(
                  IconsaxPlusLinear.notification,
                  color: colors.onSurface,
                ),
                onPressed: () => context.push(AppRoutes.notifications),
              ),
            ],
            automaticallyImplyLeading: false,
            title: Text(
              'e7gz',
              style: tt.headlineSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Error banner
                if (state.status == OwnerStatus.failure &&
                    state.errorMessage != null)
                  RawToast(
                    animationDuration: Durations.medium1,
                    toastPosition: ToastPosition.top,
                    snackbarDuration: const Duration(milliseconds: 2000),
                    onRemove: () {},
                    getPosition: () {
                      return 1;
                    },
                    getscaleFactor: () {
                      return 1;
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppSpacing.md.h),
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      decoration: BoxDecoration(
                        color: colors.errorContainer,
                        borderRadius: AppRadius.blg.r,
                        border: Border.all(
                          color: colors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: colors.error,
                            size: 18,
                          ),
                          SizedBox(width: AppSpacing.xs.w),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: tt.bodySmall?.copyWith(
                                color: colors.onErrorContainer,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.read<OwnerCubit>().loadDashboardData(),
                            child: Text(
                              'RETRY',
                              style: TextStyle(color: colors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Greeting
                Text(
                  'Welcome back,',
                  style: tt.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                ),
                Text(
                  'Dashboard Overview',
                  style: tt.headlineMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),

                // Stats Cards
                const SectionLabel('STATISTICS'),
                SizedBox(height: AppSpacing.sm.h),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md.h,
                  crossAxisSpacing: AppSpacing.md.w,
                  childAspectRatio: 1.6,
                  children: [
                    StatCard(
                      'Total Revenue',
                      _fmt(stats['totalRevenue']),
                      'EGP',
                    ),
                    StatCard('Net Earnings', _fmt(stats['netEarnings']), 'EGP'),
                    StatCard(
                      'Active Bookings',
                      _fmt(stats['activeBookingsCount']),
                      '',
                      accent: false,
                    ),
                    StatCard(
                      'My Pitches',
                      _fmt(stats['pitchesCount']),
                      '',
                      accent: false,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl.h),

                // Recent pitches preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionLabel('MY PITCHES'),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm.h),
                if (state.status == OwnerStatus.loading)
                  Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  )
                else if (state.myPitches.isEmpty)
                  EmptyPitches(onAdd: () => context.push(AppRoutes.addPitch))
                else
                  ...state.myPitches
                      .take(3)
                      .map(
                        (p) => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: PitchCard(pitch: p),
                        ),
                      ),
                SizedBox(height: 100.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(dynamic value) {
    if (value == null) return '0';
    if (value is double) return value.toStringAsFixed(0);
    return value.toString();
  }
}
