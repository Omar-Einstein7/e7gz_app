import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AdminDashboardTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminDashboardTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataSource.getDashboardStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4BE277)));
        }
        
        final stats = snapshot.data?['data'] ?? snapshot.data ?? {};
        
        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Stat Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: constraints.maxWidth > 1500 ? 8 : (constraints.maxWidth > 900 ? 5 : 3),
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio:  constraints.maxWidth > 1200 ? 1.8 : 2.5,
                    children: [
                      _StatCard(
                        title: 'Revenue',
                        value: 'EGP ${stats['totalRevenue'] ?? "42.8k"}',
                        icon: IconsaxPlusBold.wallet_3,
                        color: const Color(0xFF4BE277),
                      ),
                      _StatCard(
                        title: 'Bookings',
                        value: '${stats['totalBookings'] ?? "156"}',
                        icon: IconsaxPlusBold.calendar_tick,
                        color: const Color(0xFF3B82F6),
                      ),
                      _StatCard(
                        title: 'Pitches',
                        value: '${stats['pitchCount'] ?? "12"}',
                        icon: IconsaxPlusBold.location,
                        color: const Color(0xFFF59E0B),
                      ),
                      _StatCard(
                        title: 'Users',
                        value: '${stats['userCount'] ?? "1.2k"}',
                        icon: IconsaxPlusBold.user_square,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  
                  Expanded(
                    child: constraints.maxWidth > 900
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildActivitySection()),
                            SizedBox(width: 10.w),
                            Expanded(flex: 1, child: _buildPerformanceSection()),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(child: _buildActivitySection()),
                            SizedBox(height: 16.h),
                            Expanded(child: _buildPerformanceSection()),
                          ],
                        ),
                  ),
                ],
              );
          },
        );
      },
    );
  }

  Widget _buildActivitySection() {
    return _DashboardCard(
      title: 'Recent Activity',
      child: SingleChildScrollView(
        child: Column(
          children: [
            _activityRow('New Pitch: Champions Arena', '2m ago', IconsaxPlusBold.location, Colors.green),
            _activityRow('Booking: Ali Hassan', '15m ago', IconsaxPlusBold.ticket, Colors.blue),
            _activityRow('Payment: EGP 350', '1h ago', IconsaxPlusBold.card, Colors.orange),
            _activityRow('Match: 5v5 Football', '3h ago', IconsaxPlusBold.user_octagon, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return _DashboardCard(
      title: 'Top Venues',
      child: SingleChildScrollView(
        child: Column(
          children: [
            _performanceRow('Wembley Field', '92%'),
            _performanceRow('Champions Arena', '85%'),
            _performanceRow('Elite Turf', '78%'),
          ],
        ),
      ),
    );
  }

  Widget _activityRow(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 6.sp),
          SizedBox(width: 4.w),
          Expanded(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 5.sp))),
          Text(time, style: TextStyle(color: Colors.white24, fontSize: 4.sp)),
        ],
      ),
    );
  }

  Widget _performanceRow(String name, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(color: Colors.white70, fontSize: 6.sp)),
          Text(value, style: TextStyle(color: const Color(0xFF4BE277), fontWeight: FontWeight.bold, fontSize: 6.sp)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
       
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, color: color, size: 4.sp),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    value, 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 4.sp, 
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                ),
                Text(
                  title, 
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4), 
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashboardCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: TextStyle(color: Colors.white, fontSize: 6.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.h),
          child,
        ],
      ),
    );
  }
}
