import 'package:e7gz/src/features/auth/presentation/providers/session_bloc.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class LoyaltyRewardsScreen extends StatelessWidget {
  const LoyaltyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Loyalty Program',
          style: tt.headlineSmall?.copyWith(
            color: Colors.white,
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
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(40.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
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
                          color: cs.primary.withValues(alpha: 0.05),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'E7GZZ POINTS',
                            style: TextStyle(
                              color: const Color(0xFFBCC7DE),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              BlocBuilder<SessionBloc, SessionState>(
                                builder: (context, sessionState) {
                                  final points =
                                      sessionState.user?.loyaltyPoints ?? 0;
                                  return Text(
                                    points.toString().replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]},',
                                    ),
                                    style: tt.displayMedium?.copyWith(
                                      color: cs.primary,
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
                                  'PTS',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          AppButton(
                            label: 'REDEEM REWARDS',
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
                    color: const Color(0xFF171F33),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tier['currentTier'] ?? 'Gold Tier Status',
                              style: tt.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tier['nextTierInfo'] ??
                                  'You are 550 points away from Platinum',
                              style: TextStyle(
                                color: const Color(0xFFBCC7DE),
                                fontSize: 12.sp,
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
                      'AVAILABLE REWARDS',
                      style: TextStyle(
                        color: const Color(0xFFBCC7DE),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFF4BE277),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                if (state.rewards.isEmpty)
                  const Center(
                    child: Text(
                      'No rewards available at the moment',
                      style: TextStyle(color: Color(0xFFBCC7DE)),
                    ),
                  ),

                ...state.rewards
                    .map(
                      (reward) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: rewardItem(
                          reward.title,
                          reward.description,
                          '${reward.pointsCost} PTS',
                          Icons.confirmation_number,
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF131B2E),
                                title: Text(
                                  'Redeem Reward',
                                  style: tt.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to redeem "${reward.title}" for ${reward.pointsCost} points?',
                                  style: const TextStyle(
                                    color: Color(0xFFBCC7DE),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                  AppButton(
                                    label: 'Redeem',
                                    height: ButtonSize.small,
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      context.read<ProfileCubit>().redeemReward(
                                        reward.id,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Successfully redeemed ${reward.title}!',
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
                    )
                    .toList(),

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
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFF4BE277).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: const Color(0xFF4BE277), size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFBCC7DE),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              cost,
              style: const TextStyle(
                color: Color(0xFF4BE277),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
