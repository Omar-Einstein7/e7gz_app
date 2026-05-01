import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AdminNotificationsTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminNotificationsTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications Center',
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => dataSource.markNotificationsAsRead(),
              icon: const Icon(IconsaxPlusBold.tick_square, color: Color(0xFF4BE277)),
              label: const Text('Mark all as read', style: TextStyle(color: Color(0xFF4BE277))),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: FutureBuilder<List<dynamic>>(
              future: dataSource.getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF4BE277)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }

                final notifications = snapshot.data ?? [];
                
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(IconsaxPlusBold.notification_status, color: Colors.white.withOpacity(0.2), size: 64.sp),
                        SizedBox(height: 16.h),
                        const Text('All caught up!', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final isRead = notification['read'] ?? false;
                    
                    return ListTile(
                      contentPadding: EdgeInsets.all(24.w),
                      leading: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: (isRead ? Colors.grey : const Color(0xFF4BE277)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          isRead ? IconsaxPlusBold.notification_status : IconsaxPlusBold.notification_bing,
                          color: isRead ? Colors.grey : const Color(0xFF4BE277),
                          size: 24.sp,
                        ),
                      ),
                      title: Text(
                        notification['title'] ?? 'System Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          notification['message'] ?? '',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14.sp),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatDate(notification['createdAt']),
                            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12.sp),
                          ),
                          if (!isRead) ...[
                            SizedBox(height: 8.h),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(color: Color(0xFF4BE277), shape: BoxShape.circle),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Today';
    // Simple mock formatting
    return '2h ago';
  }
}
