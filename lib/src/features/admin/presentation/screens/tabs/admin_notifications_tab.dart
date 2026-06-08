import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../cubit/admin_cubit.dart';
import '../../cubit/admin_state.dart';

class AdminNotificationsTab extends StatefulWidget {
  const AdminNotificationsTab({super.key});

  @override
  State<AdminNotificationsTab> createState() => _AdminNotificationsTabState();
}

class _AdminNotificationsTabState extends State<AdminNotificationsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadNotifications();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notifications', style: AdminTextStyles.pageTitle),
                  SizedBox(height: 2),
                  Text('System & user alerts', style: AdminTextStyles.label),
                ],
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () =>
                    context.read<AdminCubit>().markNotificationsAsRead(),
                icon: const Icon(
                  IconsaxPlusBold.tick_square,
                  color: AdminColors.accent,
                  size: 16,
                ),
                label: const Text(
                  'Mark all read',
                  style: TextStyle(color: AdminColors.accent, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── List ─────────────────────────────────────────────
          BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state.notificationsStatus == AdminStatus.loading ||
                  state.notificationsStatus == AdminStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }

              if (state.notificationsStatus == AdminStatus.failure) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(
                        IconsaxPlusBold.warning_2,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load alerts: ${state.notificationsError}',
                        style: const TextStyle(
                          color: AdminColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            context.read<AdminCubit>().loadNotifications(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return _EmptyNotifications();
              }
              return AdminCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ...List.generate(notifications.length, (i) {
                      final n = notifications[i];
                      final isLast = i == notifications.length - 1;
                      return Column(
                        children: [
                          _NotificationTile(notification: n),
                          if (!isLast)
                            const Divider(color: AdminColors.border, height: 1),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.isNegative) return 'just now';
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    final color = isRead ? AdminColors.textMuted : AdminColors.accent;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isRead
                  ? IconsaxPlusBold.notification_status
                  : IconsaxPlusBold.notification_bing,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title.isEmpty
                      ? 'System Update'
                      : notification.title,
                  style: TextStyle(
                    color: AdminColors.textPrimary,
                    fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _timeAgo(notification.createdAt),
                style: const TextStyle(
                  color: AdminColors.textMuted,
                  fontSize: 11,
                ),
              ),
              if (!isRead) ...[
                const SizedBox(height: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AdminColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AdminCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 48),
          Icon(
            IconsaxPlusBold.notification_status,
            color: AdminColors.textMuted,
            size: 48,
          ),
          SizedBox(height: 16),
          Text('All caught up!', style: AdminTextStyles.sectionTitle),
          SizedBox(height: 4),
          Text('No new notifications', style: AdminTextStyles.label),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}
