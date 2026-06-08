import 'package:e7gz/src/imports/imports.dart';

class ProfileLoyaltyCard extends StatelessWidget {
  final int points;
  const ProfileLoyaltyCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.star,
              color: colors.primary.withValues(alpha: 0.05),
              size: 120,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile.points_title'.tr().toUpperCase(),
                style: typography.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              RichText(
                text: TextSpan(
                  text: '$points ',
                  style: typography.displayMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(
                      text: 'profile.pts'.tr(),
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              AppButton(
                label: 'profile.redeem_rewards'.tr(),
                onPressed: () => context.push(AppRoutes.loyalty),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
