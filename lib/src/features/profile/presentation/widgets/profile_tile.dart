import 'package:e7gz/src/imports/imports.dart';
class ProfileTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLogout;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isLogout = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isLogout ? const Color(0xFF200F15) : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Row(
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
                color: isLogout ? Colors.red : Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: typography.bodySmall?.copyWith(
                      color: const Color(0xFFBCC7DE).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFFBCC7DE).withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
