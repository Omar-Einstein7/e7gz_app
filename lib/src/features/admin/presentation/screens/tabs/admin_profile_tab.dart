import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';

class AdminProfileTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminProfileTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataSource.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4BE277)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        }

        final profile = snapshot.data ?? {};
        
        return Center(
          child: Container(
            width: 200.w,
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
          
              children: [
                Stack(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4BE277).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF4BE277), width: 1),
                      ),
                      child: Center(
                        child: Icon(IconsaxPlusBold.user, size: 10.sp, color: const Color(0xFF4BE277)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                        child: Icon(IconsaxPlusBold.edit_2, color: Colors.white, size: 5.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  profile['name'] ?? 'Admin User',
                  style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  profile['email'] ?? 'admin@e7gz.com',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 5.sp),
                ),
                SizedBox(height: 10.h),
                
                _profileItem(IconsaxPlusBold.mobile, 'Phone Number', profile['phone'] ?? '+20 123 456 7890'),
                _profileItem(IconsaxPlusBold.verify, 'Account Type', profile['role']?.toString().toUpperCase() ?? 'ADMINISTRATOR'),
                _profileItem(IconsaxPlusBold.calendar_circle, 'Member Since', 'January 2024'),
                
                SizedBox(height: 5.h),
                Divider(color: Colors.white.withOpacity(0.05)),
                SizedBox(height: 5.h),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4BE277), width: 0.5),
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                        ),
                        child: Text('Switch View', style: TextStyle(color: Colors.white, fontSize: 6.sp)),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                        ),
                        child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 5.sp)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: Colors.white.withOpacity(0.5), size: 5.sp),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 4.sp)),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 4.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

