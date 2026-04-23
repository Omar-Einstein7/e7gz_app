import 'package:e7gz/src/imports/imports.dart';
class LeaderboardTile extends StatelessWidget {
  final String rank;
  final String name;
  final String progress;
  final bool isMvp;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    required this.progress,
    this.isMvp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              color: const Color(0xFFBCC7DE).withValues(alpha: 0.3),
              fontWeight: FontWeight.w900,
              fontSize: 20.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 16.w),
          CircleAvatar(radius: 20.r, backgroundColor: Colors.blueGrey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  progress,
                  style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp),
                ),
              ],
            ),
          ),
          if (isMvp)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF4BE277).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'MVP',
                style: TextStyle(
                  color: const Color(0xFF4BE277),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
