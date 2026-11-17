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
          icon: Icon(IconsaxPlusLinear.arrow_left, color: colors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'nav.notifications'.tr(),
          style: tt.titleLarge?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationsCubit>().markAllRead(),
            child: Text(
              'Mark as read',
              style: tt.labelMedium?.copyWith(
                color: colors.primary,
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
                  Icon(
                    IconsaxPlusLinear.notification,
                    color: colors.onSurfaceVariant,
                    size: 64,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No notifications yet',
                    style: tt.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
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
                    tt: tt,
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

  Widget sectionHeader(String title, BuildContext context) {
    final tt = context.theme.textTheme;
    final colors = context.theme.colorScheme;
    return Text(
      title,
      style: tt.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
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
    required TextTheme tt,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isUnread ? colors.surfaceContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUnread
              ? colors.primary.withValues(alpha: 0.15)
              : colors.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: isUnread ? colors.primary : colors.onSurfaceVariant,
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
                      style: tt.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: isUnread
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: tt.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: tt.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
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
