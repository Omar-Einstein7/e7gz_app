import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'booking_card.dart';

class BookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final bool isUpcoming;

  const BookingsList({
    super.key,
    required this.bookings,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          isUpcoming ? 'bookings.no_upcoming'.tr() : 'bookings.no_past'.tr(),
          style: TextStyle(
            color: context.colors.onSurfaceVariant,
            fontSize: 14.sp,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(
          booking: bookings[index],
          isUpcoming: isUpcoming,
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
      },
    );
  }
}
