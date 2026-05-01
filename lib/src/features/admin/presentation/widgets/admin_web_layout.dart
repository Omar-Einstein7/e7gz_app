import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AdminWebLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const AdminWebLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a narrow screen (mobile/small tablet)
    final isNarrow = MediaQuery.of(context).size.width < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      // On narrow screens, we use a Drawer instead of a persistent sidebar
      drawer: isNarrow ? _buildSidebar(context) : null,
      appBar: isNarrow 
        ? AppBar(
            backgroundColor: const Color(0xFF1E293B),
            title: Text(_getTitle(), style:  TextStyle(color: Colors.white , fontSize: 5.sp)),
            iconTheme: const IconThemeData(color: Colors.white),
          )
        : null,
      body: Row(
        children: [
          if (!isNarrow) _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                if (!isNarrow) _buildTopBar(),
                Expanded(
                  child: ClipRRect(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isNarrow ? 16.w : 16.w),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 55.w,
      color: const Color(0xFF1E293B),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          // Brand
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4BE277),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(IconsaxPlusBold.flash, color: Colors.white, size: 10.sp),
                ),
                SizedBox(width: 5.w),
                const Text(
                  'E7GZ ADMIN',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(context, 0, IconsaxPlusBold.category, 'Dashboard'),
                _buildNavItem(context, 1, IconsaxPlusBold.location, 'Pitches'),
                _buildNavItem(context, 2, IconsaxPlusBold.calendar_1, 'Bookings'),
                _buildNavItem(context, 3, IconsaxPlusBold.user_octagon, 'Matches'),
                _buildNavItem(context, 4, IconsaxPlusBold.notification, 'Alerts'),
                _buildNavItem(context, 5, IconsaxPlusBold.profile_2user, 'Profile'),
              ],
            ),
          ),
          _buildLogoutBtn(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return ListTile(
      onTap: () {
        onIndexChanged(index);
        if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
      },
      leading: Icon(icon, color: isSelected ? const Color(0xFF4BE277) : Colors.white54),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF4BE277).withOpacity(0.1),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Text(
            _getTitle(),
            style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(IconsaxPlusBold.search_normal, color: Colors.white54),
          SizedBox(width: 20.w),
          const Icon(IconsaxPlusBold.notification, color: Colors.white54),
          SizedBox(width: 20.w),
          CircleAvatar(
            radius: 18.r,
            backgroundColor: const Color(0xFF4BE277),
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutBtn() {
    return ListTile(
      onTap: () {},
      leading: const Icon(IconsaxPlusBold.logout, color: Colors.redAccent),
      title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
    );
  }

  String _getTitle() {
    switch (selectedIndex) {
      case 0: return 'Dashboard';
      case 1: return 'Pitches';
      case 2: return 'Bookings';
      case 3: return 'Matches';
      case 4: return 'Alerts';
      case 5: return 'Profile';
      default: return 'Admin';
    }
  }
}
