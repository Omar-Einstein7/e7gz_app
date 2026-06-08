import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        final user = state.user;
        final name = user?.name ?? 'profile.guest'.tr();
        final email = user?.email ?? '';
        final points = user?.loyaltyPoints ?? 0;
        final photoUrl = user?.photoUrl;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'e7gzz',
              style: typography.headlineSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Column(
              children: [
                ProfileHeader(
                  name: name,
                  email: email,
                  photoUrl: photoUrl,
                  onImageTap: () => context.push(AppRoutes.editProfile),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                ProfileLoyaltyCard(points: points),
                SizedBox(height: AppSpacing.xl.h),
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
                ProfileTile(
                  title: 'profile.edit_profile'.tr(),
                  subtitle: 'profile.edit_profile_sub'.tr(),
                  icon: IconsaxPlusBold.user_edit,
                  onTap: () => context.push(AppRoutes.editProfile),
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
                  onTap: () => context.read<SessionCubit>().logout(),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                Text(
                  'profile.need_help'.tr(),
                  style: typography.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
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
