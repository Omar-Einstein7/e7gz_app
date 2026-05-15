import 'package:e7gz/src/features/auth/presentation/providers/session_bloc.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typography = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF0B1326) : colorScheme.surface;
    final primaryColor = isDark ? const Color(0xFF4BE277) : colorScheme.primary;
    final textColor = isDark ? Colors.white : colorScheme.onSurface;
    final secondaryTextColor = isDark ? const Color(0xFFBCC7DE) : colorScheme.onSurfaceVariant;
    final cardColor = isDark ? const Color(0xFF131B2E) : colorScheme.surfaceContainerLow;

    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final user = state.user;
        final name = user?.name ?? 'Guest';
        final email = user?.email ?? '';
        final points = user?.loyaltyPoints ?? 0;
        final photoUrl =
            user?.photoUrl ??
            'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80';

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(IconsaxPlusLinear.menu_1, color: textColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(
              'e7gzz',
              style: typography.headlineSmall?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: isDark ? const Color(0xFF2D3449) : colorScheme.surfaceContainerHighest,
                  child: Icon(
                    IconsaxPlusBold.user,
                    size: 20,
                    color: isDark ? Colors.white : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
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
                            color: isDark ? const Color(0xFF222A3D) : colorScheme.outlineVariant,
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
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: isDark ? const Color(0xFF003915) : colorScheme.onPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  name,
                  style: typography.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 32.sp,
                  ),
                ),
                Text(
                  email,
                  style: typography.bodyMedium?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),

                SizedBox(height: 48.h),

                // Loyalty Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(48.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        top: -10,
                        child: Icon(
                          Icons.star,
                          color: isDark ? Colors.white.withValues(alpha: 0.03) : colorScheme.primary.withValues(alpha: 0.05),
                          size: 120,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'E7GZZ POINTS',
                            style: typography.labelSmall?.copyWith(
                              color: secondaryTextColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          RichText(
                            text: TextSpan(
                              text: '$points ',
                              style: typography.displayMedium?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(
                                  text: 'PTS',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          AppButton(
                            label: 'Redeem Rewards',
                            onPressed: () => context.push(AppRoutes.loyalty),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                // Tiles
                ProfileTile(
                  title: 'Booking History',
                  subtitle: 'Manage your upcoming and past matches',
                  icon: IconsaxPlusBold.calendar_1,
                  onTap: () => context.push(AppRoutes.myBookings),
                ),
                SizedBox(height: 16.h),
                ProfileTile(
                  title: 'Loyalty Program',
                  subtitle: 'Check your tier status and benefits',
                  icon: IconsaxPlusBold.medal,
                  onTap: () => context.push(AppRoutes.loyalty),
                ),
                SizedBox(height: 16.h),
                if ((user?.isAdmin ?? false) || (user?.isOwner ?? false)) ...[
                  SizedBox(height: 16.h),
                  ProfileTile(
                    title: 'Owner Dashboard',
                    subtitle: 'Manage your stadiums and revenue',
                    icon: IconsaxPlusBold.element_3,
                    onTap: () => context.push(AppRoutes.ownerDashboard),
                  ),
                  SizedBox(height: 16.h),
                  ProfileTile(
                    title: 'Admin Panel',
                    subtitle: 'Full system management and reports',
                    icon: IconsaxPlusBold.shield_tick,
                    onTap: () => context.push(AppRoutes.admin),
                  ),
                ],

                SizedBox(height: 16.h),

                // Theme Switcher integrated directly into Settings
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, mode) {
                    final currentIsDark = mode == ThemeMode.dark || (mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
                    return ProfileTile(
                      title: currentIsDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                      subtitle: 'Change app appearance',
                      icon: currentIsDark ? IconsaxPlusBold.sun_1 : IconsaxPlusBold.moon,
                      onTap: () => context.read<ThemeCubit>().setTheme(currentIsDark ? ThemeMode.light : ThemeMode.dark),
                    );
                  },
                ),
                
                SizedBox(height: 16.h),
                const ProfileTile(
                  title: 'Settings',
                  subtitle: 'Privacy, notifications, and app preferences',
                  icon: IconsaxPlusBold.setting_2,
                ),
                SizedBox(height: 16.h),
                ProfileTile(
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  icon: IconsaxPlusBold.logout,
                  isLogout: true,
                  onTap: () => context.read<SessionBloc>().add(
                    const SessionLogoutRequested(),
                  ),
                ),

                SizedBox(height: 48.h),

                Text(
                  'Need help with your booking?',
                  style: typography.bodySmall?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SupportAction(
                      label: 'SUPPORT',
                      icon: IconsaxPlusBold.headphone,
                    ),
                    SizedBox(width: 40.w),
                    const SupportAction(
                      label: 'FAQ',
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
