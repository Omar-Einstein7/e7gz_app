import 'package:e7gz/src/features/auth/presentation/providers/session_bloc.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/profile_tile.dart';
import '../widgets/support_action.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;
    
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final user = state.user;
        final name = user?.name ?? 'profile.guest'.tr();
        final email = user?.email ?? '';
        final points = user?.loyaltyPoints ?? 0;
        final photoUrl =
            user?.photoUrl ??
            'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80';

        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            // leading: IconButton(
            //   icon: Icon(IconsaxPlusLinear.menu_1, color: cs.onSurface),
            //   onPressed: () => Scaffold.of(context).openDrawer(),
            // ),
            title: Text(
              'e7gzz',
              style: typography.headlineSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            // actions: [
            //   Padding(
            //     padding: EdgeInsets.only(right: AppSpacing.md.w),
            //     child: CircleAvatar(
            //       radius: 18.r,
            //       backgroundColor: cs.surfaceContainerHigh,
            //       child: Icon(
            //         IconsaxPlusBold.user,
            //         size: 20,
            //         color: cs.onSurfaceVariant,
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Column(
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cs.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60.r,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: cs.onPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.md.h),

                Text(
                  name,
                  style: typography.headlineSmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 32.sp,
                  ),
                ),
                Text(
                  email,
                  style: typography.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: AppSpacing.xxl.h),

                // Loyalty Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.xl.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
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
                          color: cs.primary.withValues(alpha: 0.05),
                          size: 120,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'profile.points_title'.tr().toUpperCase(),
                            style: typography.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs.h),
                          RichText(
                            text: TextSpan(
                              text: '$points ',
                              style: typography.displayMedium?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(
                                  text: 'profile.pts'.tr(),
                                  style: TextStyle(
                                    color: cs.primary,
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
                ),

                SizedBox(height: AppSpacing.xl.h),

                // Tiles
                ProfileTile(
                  title: 'profile.tile_bookings'.tr(),
                  subtitle: 'profile.tile_bookings_sub'.tr(),
                  icon: IconsaxPlusBold.calendar_1,
                  onTap: () => context.go(AppRoutes.myBookings),
                ),
                SizedBox(height: AppSpacing.md.h),
                ProfileTile(
                  title: 'profile.tile_loyalty'.tr(),
                  subtitle: 'profile.tile_loyalty_sub'.tr(),
                  icon: IconsaxPlusBold.medal,
                  onTap: () => context.push(AppRoutes.loyalty),
                ),
                SizedBox(height: AppSpacing.md.h),
                if ((user?.isAdmin ?? false) || (user?.isOwner ?? false)) ...[
                  ProfileTile(
                    title: 'profile.tile_owner'.tr(),
                    subtitle: 'profile.tile_owner_sub'.tr(),
                    icon: IconsaxPlusBold.element_3,
                    onTap: () => context.push(AppRoutes.ownerDashboard),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  ProfileTile(
                    title: 'profile.tile_admin'.tr(),
                    subtitle: 'profile.tile_admin_sub'.tr(),
                    icon: IconsaxPlusBold.shield_tick,
                    onTap: () => context.push(AppRoutes.admin),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                ProfileTile(
                  title: 'profile.tile_settings'.tr(),
                  subtitle: 'profile.tile_settings_sub'.tr(),
                  icon: IconsaxPlusBold.setting_2,
                  onTap: () => context.push(AppRoutes.settings),
                ),
                SizedBox(height: AppSpacing.md.h),
                ProfileTile(
                  title: 'profile.tile_logout'.tr(),
                  subtitle: 'profile.tile_logout_sub'.tr(),
                  icon: IconsaxPlusBold.logout,
                  isLogout: true,
                  onTap: () => context.read<SessionBloc>().add(
                    const SessionLogoutRequested(),
                  ),
                ),

                SizedBox(height: AppSpacing.xxl.h),

                Text(
                  'profile.need_help'.tr(),
                  style: typography.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SupportAction(
                      label: 'profile.support'.tr().toUpperCase(),
                      icon: IconsaxPlusBold.headphone,
                    ),
                    SizedBox(width: AppSpacing.xxl.w),
                    SupportAction(
                      label: 'profile.faq'.tr().toUpperCase(),
                      icon: IconsaxPlusBold.info_circle,
                    ),
                  ],
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
