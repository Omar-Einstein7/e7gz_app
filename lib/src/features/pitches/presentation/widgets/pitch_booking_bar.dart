import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/imports.dart';

class PitchBookingBar extends StatelessWidget {
  final Pitch pitch;
  const PitchBookingBar({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'pitch_details.price_per_hour'.tr().toUpperCase(),
                    style: context.typography.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  RichText(
                    text: TextSpan(
                      text: '${pitch.pricePerHour.toInt()} ',
                      style: context.typography.titleMedium?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        TextSpan(
                          text: 'pitch_details.egp'.tr(),
                          style: context.typography.labelMedium?.copyWith(
                            color: pc.accentGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            _BookNowButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push(
                  AppRoutes.bookingSlots.replaceFirst(':id', pitch.id),
                  extra: pitch,
                );
              },
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 100.ms)
        .moveY(begin: 10, end: 0);
  }
}

class _BookNowButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BookNowButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.bxl.r,
        boxShadow: [
          BoxShadow(
            color: pc.accentGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: pc.accentGreen,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.md.h,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.bxl.r),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'pitch_details.book_now'.tr().toUpperCase(),
              style: context.typography.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            const Icon(IconsaxPlusBold.calendar_2, size: 18),
          ],
        ),
      ),
    );
  }
}
