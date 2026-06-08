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
    final typography = context.typography;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final cardBg = isDark
        ? const Color(0xFF131B2E)
        : theme.colorScheme.surfaceContainerLow;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final subtitleColor = isDark
        ? const Color(0xFFBCC7DE)
        : theme.colorScheme.onSurfaceVariant;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.2)
        : theme.colorScheme.shadow.withValues(alpha: 0.05);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 20)],
        ),
        child: Column(
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40.r),
                  ),
                  child: AppCachedImage(
                    imageUrl:
                        match.pitchImage ??
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: match.isFull
                          ? Colors.red
                          : (isDark
                                ? const Color(0xFF4BE277)
                                : theme.colorScheme.primary),
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
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: subtitleColor,
                                  size: 14,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  match.pitchName ?? 'Premium Pitch',
                                  style: TextStyle(
                                    color: subtitleColor,
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
                              color: isDark
                                  ? const Color(0xFF4BE277)
                                  : theme.colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'EGP / PLAYER',
                            style: TextStyle(
                              color: subtitleColor,
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
                            CircleAvatar(
                              radius: 14.r,
                              backgroundColor: Colors.grey,
                            ),
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
                          color: subtitleColor,
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
                              color: subtitleColor,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '${match.startTime} Today',
                            style: typography.bodySmall?.copyWith(
                              color: textColor,
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
                    variant: match.isFull
                        ? ButtonVariant.secondary
                        : ButtonVariant.primary,
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
