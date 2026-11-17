import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';

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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardBg = cs.surfaceContainer;
    final textColor = cs.onSurface;
    final subtitleColor = cs.onSurfaceVariant;
    final shadowColor = cs.shadow.withValues(alpha: 0.08);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 16)],
        ),
        child: Column(
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
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
                      color: match.isFull ? cs.error : cs.primary,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      match.isFull ? 'FULL' : '${match.slotsLeft} SLOTS LEFT',
                      style: typography.labelSmall?.copyWith(
                        color: cs.onPrimary,
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
                                  style: typography.bodySmall?.copyWith(
                                    color: subtitleColor,
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
                              color: cs.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'EGP / PLAYER',
                            style: typography.labelSmall?.copyWith(
                              color: subtitleColor,
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
                      // Participants Avatars
                      SizedBox(
                        width: 80.w,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 14.r,
                              backgroundColor: cs.surfaceContainerHighest,
                            ),
                            if (match.participantIds.length > 1)
                              Positioned(
                                left: 20.w,
                                child: CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: cs.surfaceContainerHighest,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '+${match.participantIds.length}',
                        style: typography.labelMedium?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'KICKOFF',
                            style: typography.labelSmall?.copyWith(
                              color: subtitleColor,
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
