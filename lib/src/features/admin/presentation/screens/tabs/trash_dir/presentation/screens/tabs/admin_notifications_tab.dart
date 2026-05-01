import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AdminNotificationsTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminNotificationsTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataSource.getNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        }

        final notifications = snapshot.data ?? [];
        
        if (notifications.isEmpty) {
          return const Center(child: Text('No notifications', style: TextStyle(color: Colors.white70)));
        }

        return ListView.separated(
          padding: EdgeInsets.all(24.w),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isRead = notification['read'] ?? false;
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              tileColor: isRead ? Colors.transparent : Colors.white.withOpacity(0.03),
              leading: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: (isRead ? Colors.grey : const Color(0xFF4BE277)).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications,
                  color: isRead ? Colors.grey : const Color(0xFF4BE277),
                  size: 20.sp,
                ),
              ),
              title: Text(
                notification['title'] ?? 'System Alert',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Text(
                notification['message'] ?? '',
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              trailing: !isRead ? Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(color: Color(0xFF4BE277), shape: BoxShape.circle),
              ) : null,
            );
          },
        );
      },
    );
  }
}
