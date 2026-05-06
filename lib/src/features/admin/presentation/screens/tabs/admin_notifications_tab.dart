import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';

class AdminNotificationsTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminNotificationsTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => dataSource.markNotificationsAsRead(),
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
          FutureBuilder<List<dynamic>>(
            future: dataSource.getNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }
              final notifications = snapshot.data ?? [];
              if (notifications.isEmpty) {
                return _EmptyNotifications();
              }
              return AdminCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ...List.generate(notifications.length, (i) {
                      final n = notifications[i];
                      final isRead = n['read'] ?? false;
                      final isLast = i == notifications.length - 1;
                      return Column(
                        children: [
                          _NotificationTile(notification: n, isRead: isRead),
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
  final Map<String, dynamic> notification;
  final bool isRead;

  const _NotificationTile({required this.notification, required this.isRead});

  @override
  Widget build(BuildContext context) {
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
                  notification['title'] ?? 'System Update',
                  style: TextStyle(
                    color: AdminColors.textPrimary,
                    fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'] ?? '',
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
              const Text(
                '2h ago',
                style: TextStyle(color: AdminColors.textMuted, fontSize: 11),
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
    return AdminCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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
