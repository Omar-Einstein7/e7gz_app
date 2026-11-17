import 'package:e7gz/src/features/auth/presentation/cubit/session_cubit.dart';
import 'package:e7gz/src/features/auth/presentation/cubit/session_state.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class LoyaltyRewardsScreen extends StatelessWidget {
  const LoyaltyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.onSurface),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'profile.loyalty_program'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.rewards.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final tier = state.tierStatus;

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                // Points Bento Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: colors.outlineVariant,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20.w,
                        top: -20.h,
                        child: Icon(
                          IconsaxPlusBold.medal_star,
                          size: 150,
                          color: colors.primary.withValues(alpha: 0.05),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'profile.e7gzz_points'.tr().toUpperCase(),
                            style: tt.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              BlocBuilder<SessionCubit, SessionState>(
                                builder: (context, sessionState) {
                                  final points =
                                      sessionState.user?.loyaltyPoints ?? 0;
                                  return Text(
                                    points.toString().replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]},',
                                    ),
                                    style: tt.displayMedium?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 12.h,
                                  left: 8.w,
                                ),
                                child: Text(
                                  'profile.pts'.tr(),
                                  style: tt.titleMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          AppButton(
                            label: 'profile.redeem_rewards'.tr().toUpperCase(),
                            height: ButtonSize.small,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Tier Section
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: context.semanticColors.warning.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          color: context.semanticColors.warning,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tier['currentTier'] ?? 'profile.gold_tier'.tr(),
                              style: tt.titleMedium?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tier['nextTierInfo'] ??
                                  'profile.next_tier_desc'.tr(),
                              style: tt.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                // Available Rewards Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'profile.available_rewards'.tr().toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'profile.view_all'.tr(),
                      style: tt.labelMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                if (state.rewards.isEmpty)
                  Center(
                    child: Text(
                      'profile.no_rewards'.tr(),
                      style: tt.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ),

                ...state.rewards.map(
                  (reward) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: rewardItem(
                      reward.title,
                      reward.description,
                      '${reward.pointsCost} PTS',
                      Icons.confirmation_number,
                      context,
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: colors.surfaceContainer,
                            title: Text(
                              'profile.redeem_dialog_title'.tr(),
                              style: tt.titleLarge?.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            content: Text(
                              'profile.redeem_confirm_desc'.tr(
                                namedArgs: {
                                  'title': reward.title,
                                  'cost': reward.pointsCost.toString(),
                                },
                              ),
                              style: tt.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'profile.cancel'.tr(),
                                  style: tt.labelMedium?.copyWith(color: colors.onSurfaceVariant),
                                ),
                              ),
                              AppButton(
                                label: 'profile.redeem'.tr(),
                                height: ButtonSize.small,
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.read<ProfileCubit>().redeemReward(
                                    reward.id,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'profile.redeem_success'.tr(
                                          namedArgs: {'title': reward.title},
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget rewardItem(
    String title,
    String subtitle,
    String cost,
    IconData icon,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    final colors = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: colors.primary, size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.bodyMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: tt.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              cost,
              style: tt.labelMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
