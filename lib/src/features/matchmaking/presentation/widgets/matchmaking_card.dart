import 'package:e7gz/src/imports/imports.dart';
import '../../domain/entities/match.dart';

class MatchmakingCard extends StatelessWidget {
  final MatchmakingMatch match;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  const MatchmakingCard({
    super.key,
    required this.match,
    this.onTap,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                  child: Image.network(
                    match.pitchImage ??
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: 160.h,
                        width: double.infinity,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white24),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: match.isFull ? Colors.red : const Color(0xFF4BE277),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      match.isFull ? 'FULL' : '${match.slotsLeft} SLOTS LEFT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.title,
                              style: typography.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFFBCC7DE),
                                  size: 14,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  match.pitchName ?? 'Premium Pitch',
                                  style: TextStyle(
                                    color: const Color(0xFFBCC7DE),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${match.pricePerPlayer.toInt()}',
                            style: typography.titleLarge?.copyWith(
                              color: const Color(0xFF4BE277),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'EGP / PLAYER',
                            style: TextStyle(
                              color: const Color(0xFFBCC7DE),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      // Participants Avatars (Mock for now)
                      SizedBox(
                        width: 80.w,
                        child: Stack(
                          children: [
                            CircleAvatar(radius: 14.r, backgroundColor: Colors.grey),
                            if (match.participantIds.length > 1)
                              Positioned(
                                left: 20.w,
                                child: CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: Colors.blueGrey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '+${match.participantIds.length}',
                        style: TextStyle(
                          color: const Color(0xFFBCC7DE),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'KICKOFF',
                            style: TextStyle(
                              color: const Color(0xFFBCC7DE),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '${match.startTime} Today',
                            style: typography.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    label: match.isFull ? 'Match Full' : 'Join Match',
                    isFullWidth: true,
                    height: ButtonSize.large,
                    onPressed: match.isFull ? null : onJoin,
                    suffixIcon: match.isFull
                        ? const Icon(Icons.hourglass_empty, size: 18)
                        : const Icon(Icons.arrow_forward),
                    variant: match.isFull ? ButtonVariant.secondary : ButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
