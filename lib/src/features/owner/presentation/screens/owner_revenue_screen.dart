import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_state.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/revenue_mini_stat.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class OwnerRevenueScreen extends StatelessWidget {
  final OwnerState state;
  const OwnerRevenueScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final total = (stats['totalRevenue'] as num?)?.toDouble() ?? 0;
    final commission = (stats['platformCommission'] as num?)?.toDouble() ?? 0;
    final net = (stats['netEarnings'] as num?)?.toDouble() ?? 0;
    final monthly = (stats['monthlyRevenue'] as num?)?.toDouble() ?? 0;

    final colors = context.colors;
    final tt = context.typography;

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<OwnerCubit>().loadDashboardData(),
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        children: [
          Text(
            'Revenue',
            style: tt.headlineMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Financial overview of your pitches',
            style: tt.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.xl.h),

          // Big revenue card
          Container(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primaryContainer, colors.surfaceContainerHigh],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.bxxl.r,
              border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Lifetime Revenue',
                  style: tt.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  '${total.toStringAsFixed(0)} EGP',
                  style: tt.displaySmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Row(
                  children: [
                    RevenueMiniStat(
                      'This Month',
                      '${monthly.toStringAsFixed(0)} EGP',
                    ),
                    SizedBox(width: AppSpacing.lg.w),
                    RevenueMiniStat(
                      'Commission',
                      '${commission.toStringAsFixed(0)} EGP',
                    ),
                    SizedBox(width: AppSpacing.lg.w),
                    RevenueMiniStat(
                      'Net Payout',
                      '${net.toStringAsFixed(0)} EGP',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),

          if (state.status == OwnerStatus.loading)
            Center(child: CircularProgressIndicator(color: colors.primary))
          else if (total == 0)
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppRadius.blg.r,
              ),
              child: Center(
                child: Text(
                  'No revenue yet.\nBookings will appear here once confirmed.',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
