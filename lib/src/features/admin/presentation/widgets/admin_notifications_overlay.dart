import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../layout/admin_layout.dart';

class AdminNotificationsOverlay extends StatelessWidget {
  const AdminNotificationsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 400,
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdminColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Notifications',
                  style: AdminTextStyles.sectionTitle,
                ),
                const Spacer(),
                Text(
                  'Mark all as read',
                  style: AdminTextStyles.label.copyWith(
                    color: AdminColors.accentBlue,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AdminColors.border, height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 4,
              separatorBuilder: (_, _) => const Divider(
                color: AdminColors.border,
                height: 1,
                indent: 20,
                endIndent: 20,
              ),
              itemBuilder: (context, i) {
                final items = [
                  {
                    'id': '1',
                    'title': 'New Booking',
                    'desc': 'Zamalek Pitch booked for 8 PM tonight.',
                    'time': '2 mins ago',
                    'icon': IconsaxPlusBold.calendar_1,
                    'color': AdminColors.accent,
                  },
                  {
                    'id': '2',
                    'title': 'Payment Received',
                    'desc': 'Transaction #7291 was successful.',
                    'time': '1 hour ago',
                    'icon': IconsaxPlusBold.card,
                    'color': AdminColors.accentBlue,
                  },
                  {
                    'id': '3',
                    'title': 'Maintenance Alert',
                    'desc': 'Cairo Arena lights require attention.',
                    'time': '3 hours ago',
                    'icon': IconsaxPlusBold.danger,
                    'color': AdminColors.accentAmber,
                  },
                  {
                    'id': '4',
                    'title': 'New User Signup',
                    'desc': 'Ahmed Ali joined as a player.',
                    'time': 'Yesterday',
                    'icon': IconsaxPlusBold.user,
                    'color': AdminColors.accentPurple,
                  },
                ];
                final item = items[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item['title'] as String,
                    style: AdminTextStyles.sectionTitle.copyWith(fontSize: 13),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        item['desc'] as String,
                        style: AdminTextStyles.label.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['time'] as String,
                        style: AdminTextStyles.label.copyWith(
                          fontSize: 10,
                          color: AdminColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
          const Divider(color: AdminColors.border, height: 1),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View All Notifications',
                style: AdminTextStyles.label,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
