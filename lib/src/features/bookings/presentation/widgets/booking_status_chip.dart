import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;
  final bool isUpcoming;

  const BookingStatusChip({
    super.key,
    required this.status,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final isCancelled = status == BookingStatus.cancelled;

    final Color bgColor;
    final Color textColor;
    final String label;

    if (isCancelled) {
      bgColor = cs.errorContainer.withValues(alpha: 0.1);
      textColor = cs.error;
      label = 'CANCELLED';
    } else if (isUpcoming) {
      bgColor = cs.primary.withValues(alpha: 0.1);
      textColor = cs.primary;
      label = 'UPCOMING';
    } else {
      bgColor = cs.onSurfaceVariant.withValues(alpha: 0.1);
      textColor = cs.onSurfaceVariant;
      label = 'COMPLETED';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w, vertical: AppSpacing.xs.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
