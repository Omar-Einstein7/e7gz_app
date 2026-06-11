import 'package:e7gz/src/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.arrow_left, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'nav.notifications'.tr(),
          style: tt.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationsCubit>().markAllRead(),
            child: Text(
              'Mark as read',
              style: TextStyle(
                color: colors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading &&
              state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    IconsaxPlusLinear.notification,
                    color: Color(0xFFBCC7DE),
                    size: 64,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      color: const Color(0xFFBCC7DE),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationsCubit>().loadNotifications(),
            child: ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final n = state.notifications[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: notificationTile(
                    title: n.title,
                    body: n.body,
                    time: _formatTime(n.createdAt),
                    icon: _getIconForType(n.type),
                    isUnread: !n.isRead,
                    colors: colors,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'booking':
        return IconsaxPlusBold.calendar_1;
      case 'match':
        return IconsaxPlusBold.user_octagon;
      case 'loyalty':
        return IconsaxPlusBold.medal_star;
      default:
        return IconsaxPlusBold.info_circle;
    }
  }

  Widget sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
        fontSize: 10.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }

  Widget notificationTile({
    required String title,
    required String body,
    required String time,
    required IconData icon,
    required bool isUnread,
    required ColorScheme colors,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFF131B2E) : Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isUnread
              ? colors.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFF171F33),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: isUnread ? colors.primary : const Color(0xFFBCC7DE),
              size: 24,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isUnread
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFFBCC7DE),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: TextStyle(
                    color: const Color(0xFFBCC7DE).withValues(alpha: 0.8),
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.only(left: 12.w, top: 4.h),
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
