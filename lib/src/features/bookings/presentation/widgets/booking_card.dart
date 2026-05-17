import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import 'booking_status_chip.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isUpcoming;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;
    final isCancelled = booking.status == BookingStatus.cancelled;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md.h),
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _PitchImage(imageUrl: booking.pitchImage),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.pitchName.isNotEmpty
                          ? booking.pitchName
                          : 'Pitch Details',
                      style: typography.titleMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      booking.pitchAddress.isNotEmpty
                          ? booking.pitchAddress
                          : 'Unknown Location',
                      style: typography.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              BookingStatusChip(status: booking.status, isUpcoming: isUpcoming),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailItem(label: 'DATE', value: booking.date),
              _DetailItem(
                label: 'TIME',
                value: '${booking.startTime} - ${booking.endTime}',
              ),
              _DetailItem(
                label: 'PRICE',
                value: '${booking.totalPrice.toInt()} EGP',
                highlight: true,
              ),
            ],
          ),
          if (isUpcoming && !isCancelled) ...[
            SizedBox(height: AppSpacing.lg.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'CANCEL',
                    height: ButtonSize.small,
                    color: cs.errorContainer.withValues(alpha: 0.1),
                    textColor: cs.error,
                    onPressed: () => _showCancelDialog(context),
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                _LocationActionButton(onTap: () {}),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    final cs = context.colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.bxxl.r),
        title: Text(
          'Cancel Booking?',
          style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'NO, KEEP IT',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BookingsCubit>().cancelBooking(booking.id);
              context.pop();
            },
            child: Text(
              'YES, CANCEL',
              style: TextStyle(color: cs.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchImage extends StatelessWidget {
  final String? imageUrl;
  const _PitchImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AppCachedImage(
      imageUrl: imageUrl != null && imageUrl!.isNotEmpty
          ? imageUrl!
          : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
      width: 64.w,
      height: 64.w,
      borderRadius: AppRadius.blg.r,
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _DetailItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: 8.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          value,
          style: TextStyle(
            color: highlight ? cs.primary : cs.onSurface,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _LocationActionButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LocationActionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Icon(IconsaxPlusLinear.location, color: cs.onSurface, size: 20),
      ),
    );
  }
}
