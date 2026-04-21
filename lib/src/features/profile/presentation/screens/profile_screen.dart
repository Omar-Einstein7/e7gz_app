import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          icon: const Icon(IconsaxPlusLinear.menu_1, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'e7gzz',
          style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFF2D3449),
              child: const Icon(IconsaxPlusBold.user, size: 20, color: Colors.white),
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
                      border: Border.all(color: const Color(0xFF222A3D), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80'),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Color(0xFF4BE277), shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Color(0xFF003915), size: 16),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Text(
              'Ahmed Hassan',
              style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32.sp),
            ),
            Text(
              'ahmed.hassan@example.com',
              style: tt.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE)),
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
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 15))
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Icon(Icons.star, color: Colors.white.withValues(alpha: 0.03), size: 120),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E7GZZ POINTS',
                        style: tt.labelSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      SizedBox(height: 8.h),
                      RichText(
                        text: TextSpan(
                          text: '2,450 ',
                          style: tt.displayMedium?.copyWith(color: const Color(0xFF4BE277), fontWeight: FontWeight.w900),
                          children: [
                            TextSpan(text: 'PTS', style: TextStyle(color: const Color(0xFF4BE277), fontSize: 18.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      AppButton(
                        label: 'Redeem Rewards',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Tiles
            GestureDetector(
              onTap: () => context.push(AppRoutes.myBookings),
              child: profileTile('Booking History', 'Manage your upcoming and past matches', IconsaxPlusBold.calendar_1),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => context.push(AppRoutes.loyalty),
              child: profileTile('Loyalty Program', 'Check your tier status and benefits', IconsaxPlusBold.medal),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => context.push(AppRoutes.ownerDashboard),
              child: profileTile('Owner Dashboard', 'Manage your stadiums and revenue', IconsaxPlusBold.element_3),
            ),
            SizedBox(height: 16.h),
            profileTile('Settings', 'Privacy, notifications, and app preferences', IconsaxPlusBold.setting_2),
            SizedBox(height: 16.h),
            profileTile('Logout', 'Sign out of your account', IconsaxPlusBold.logout, isLogout: true),
            
            SizedBox(height: 48.h),
            
            Text(
              'Need help with your booking?',
              style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                supportIcon('SUPPORT', IconsaxPlusBold.headphone),
                SizedBox(width: 40.w),
                supportIcon('FAQ', IconsaxPlusBold.info_circle),
              ],
            ),
            
            SizedBox(height: 100.h),
          ],
        ),
      ),
      bottomNavigationBar: customBottomNav(cs),
    );
  }

  Widget profileTile(String title, String subtitle, IconData icon, {bool isLogout = false}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isLogout ? const Color(0xFF200F15) : const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFF171F33),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: isLogout ? Colors.red : Colors.white, size: 20),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: context.theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFBCC7DE).withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: const Color(0xFFBCC7DE).withValues(alpha: 0.3)),
        ],
      ),
    );
  }

  Widget supportIcon(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(color: const Color(0xFF171F33), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF4BE277), size: 24),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget customBottomNav(ColorScheme cs) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1326),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navItem(0, 'HOME', IconsaxPlusLinear.home, false, cs),
          navItem(1, 'SEARCH', IconsaxPlusLinear.search_normal_1, false, cs),
          navItem(2, 'MATCHES', IconsaxPlusLinear.user_octagon, false, cs),
          navItem(3, 'BOOKINGS', IconsaxPlusLinear.calendar_1, false, cs),
          navItem(4, 'PROFILE', IconsaxPlusBold.user, true, cs),
        ],
      ),
    );
  }

  Widget navItem(int index, String label, IconData icon, bool isSelected, ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSelected)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF003915), size: 24),
          )
        else
          Icon(icon, color: const Color(0xFFBCC7DE), size: 24),
      ],
    );
  }
}
