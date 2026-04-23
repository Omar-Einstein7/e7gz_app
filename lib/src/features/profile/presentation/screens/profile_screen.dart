import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
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
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.menu_1, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'e7gzz',
          style: typography.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFF2D3449),
              child: const Icon(
                IconsaxPlusBold.user,
                size: 20,
                color: Colors.white,
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
                        color: const Color(0xFF222A3D),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4BE277),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF003915),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              'Ahmed Hassan',
              style: typography.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 32.sp,
              ),
            ),
            Text(
              'ahmed.hassan@example.com',
              style: typography.bodyMedium?.copyWith(
                color: const Color(0xFFBCC7DE),
              ),
            ),

            SizedBox(height: 48.h),

            // Loyalty Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(48.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
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
                      color: Colors.white.withValues(alpha: 0.03),
                      size: 120,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E7GZZ POINTS',
                        style: typography.labelSmall?.copyWith(
                          color: const Color(0xFFBCC7DE),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      RichText(
                        text: TextSpan(
                          text: '2,450 ',
                          style: typography.displayMedium?.copyWith(
                            color: const Color(0xFF4BE277),
                            fontWeight: FontWeight.w900,
                          ),
                          children: [
                            TextSpan(
                              text: 'PTS',
                              style: TextStyle(
                                color: const Color(0xFF4BE277),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      AppButton(label: 'Redeem Rewards', onPressed: () {}),
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
            ProfileTile(
              title: 'Owner Dashboard',
              subtitle: 'Manage your stadiums and revenue',
              icon: IconsaxPlusBold.element_3,
              onTap: () => context.push(AppRoutes.ownerDashboard),
            ),
            SizedBox(height: 16.h),
            const ProfileTile(
              title: 'Settings',
              subtitle: 'Privacy, notifications, and app preferences',
              icon: IconsaxPlusBold.setting_2,
            ),
            SizedBox(height: 16.h),
            const ProfileTile(
              title: 'Logout',
              subtitle: 'Sign out of your account',
              icon: IconsaxPlusBold.logout,
              isLogout: true,
            ),

            SizedBox(height: 48.h),

            Text(
              'Need help with your booking?',
              style: typography.bodySmall?.copyWith(
                color: const Color(0xFFBCC7DE),
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
  }
}
