import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark as read', 
              style: TextStyle(color: cs.primary, fontSize: 12.sp, fontWeight: FontWeight.bold)
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          sectionHeader('NEW'),
          SizedBox(height: 16.h),
          notificationTile(
            title: 'Booking Confirmed!',
            body: 'Your match at Anfield Arena is set for tonight at 21:00.',
            time: '2m ago',
            icon: IconsaxPlusBold.calendar_1,
            isUnread: true,
            cs: cs,
          ),
          SizedBox(height: 16.h),
          notificationTile(
            title: 'New Match in Maadi',
            body: 'Amira Khaled invited you to a public match today.',
            time: '15m ago',
            icon: IconsaxPlusBold.user_octagon,
            isUnread: true,
            cs: cs,
          ),
          
          SizedBox(height: 48.h),
          
          sectionHeader('EARLIER'),
          SizedBox(height: 16.h),
          notificationTile(
            title: 'Points Earned!',
            body: 'You earned 150 PTS from your last match win.',
            time: 'Yesterday',
            icon: IconsaxPlusBold.medal_star,
            isUnread: false,
            cs: cs,
          ),
          SizedBox(height: 16.h),
          notificationTile(
            title: 'System Update',
            body: 'New pitches added in Sheikh Zayed! Check them out.',
            time: '2 days ago',
            icon: IconsaxPlusBold.info_circle,
            isUnread: false,
            cs: cs,
          ),
          SizedBox(height: 16.h),
          notificationTile(
            title: 'Verification Success',
            body: 'Your profile has been verified as an Elite Player.',
            time: '4 days ago',
            icon: IconsaxPlusBold.verify,
            isUnread: false,
            cs: cs,
          ),
        ],
      ),
    );
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
    required ColorScheme cs,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFF131B2E) : Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isUnread ? cs.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05)
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
            child: Icon(icon, color: isUnread ? cs.primary : const Color(0xFFBCC7DE), size: 24),
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
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        fontSize: 14.sp,
                      )
                    ),
                    Text(time, style: const TextStyle(color: Color(0xFFBCC7DE), fontSize: 10)),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: TextStyle(
                    color: const Color(0xFFBCC7DE).withValues(alpha: 0.8), 
                    fontSize: 12.sp, 
                    height: 1.4
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
              decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
