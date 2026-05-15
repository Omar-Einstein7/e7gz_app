import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingsCubit>().loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isDark = context.theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0B1326) : cs.surface;
    final textColor = isDark ? Colors.white : cs.onSurface;
    final unselectedColor = isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(
          'My Bookings',
          style: tt.headlineSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: cs.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          labelColor: cs.primary,
          unselectedLabelColor: unselectedColor,
          labelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
          tabs: const [
            Tab(text: 'UPCOMING'),
            Tab(text: 'PAST'),
          ],
        ),
      ),
      body: BlocBuilder<BookingsCubit, BookingsState>(
        builder: (context, state) {
          if (state.status == BookingsStatus.loading ||
              state.status == BookingsStatus.initial) {
            return Center(child: CircularProgressIndicator(color: cs.primary));
          }
          if (state.status == BookingsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load bookings',
                style: TextStyle(color: Colors.redAccent, fontSize: 14.sp),
              ),
            );
          }

          final now = DateTime.now();
          final upcomingBookings = state.bookings.where((b) {
            final date = DateTime.tryParse(b.date);
            return date != null &&
                date.isAfter(now.subtract(const Duration(days: 1))) &&
                b.status != BookingStatus.cancelled;
          }).toList();

          final pastBookings = state.bookings.where((b) {
            final date = DateTime.tryParse(b.date);
            return (date != null && date.isBefore(now)) ||
                b.status == BookingStatus.cancelled;
          }).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              bookingsList(
                bookings: upcomingBookings,
                isUpcoming: true,
                cs: cs,
                tt: tt,
                isDark: isDark,
              ),
              bookingsList(
                bookings: pastBookings,
                isUpcoming: false,
                cs: cs,
                tt: tt,
                isDark: isDark,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget bookingsList({
    required List<Booking> bookings,
    required bool isUpcoming,
    required ColorScheme cs,
    required TextTheme tt,
    required bool isDark,
  }) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          isUpcoming ? 'No upcoming bookings' : 'No past bookings',
          style: TextStyle(color: isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant, fontSize: 14.sp),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return bookingCard(
          booking: bookings[index],
          isUpcoming: isUpcoming,
          cs: cs,
          tt: tt,
          isDark: isDark,
        );
      },
    );
  }

  Widget bookingCard({
    required Booking booking,
    required bool isUpcoming,
    required ColorScheme cs,
    required TextTheme tt,
    required bool isDark,
  }) {
    final bool isCancelled = booking.status == BookingStatus.cancelled;
    final cardBg = isDark ? const Color(0xFF131B2E) : cs.surfaceContainerLow;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : cs.outlineVariant;
    final textColor = isDark ? Colors.white : cs.onSurface;
    final subtitleColor = isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant;
    final primaryAccent = isDark ? const Color(0xFF4BE277) : cs.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      booking.pitchImage != null &&
                              booking.pitchImage!.isNotEmpty
                          ? booking.pitchImage!
                          : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.pitchName.isNotEmpty
                          ? booking.pitchName
                          : 'Pitch Details',
                      style: tt.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      booking.pitchAddress.isNotEmpty
                          ? booking.pitchAddress
                          : 'Unknown Location',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? Colors.red.withValues(alpha: 0.1)
                      : (isUpcoming
                            ? primaryAccent.withValues(alpha: 0.1)
                            : (isDark ? const Color(0xFF2D3449) : cs.surfaceContainerHighest)),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  isCancelled
                      ? 'CANCELLED'
                      : (isUpcoming ? 'UPCOMING' : 'COMPLETED'),
                  style: TextStyle(
                    color: isCancelled
                        ? Colors.redAccent
                        : (isUpcoming
                              ? primaryAccent
                              : subtitleColor),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              detailItem('DATE', booking.date, isDark: isDark, cs: cs),
              detailItem('TIME', '${booking.startTime} - ${booking.endTime}', isDark: isDark, cs: cs),
              detailItem(
                'PRICE',
                '${booking.totalPrice.toInt()} EGP',
                highlight: true,
                isDark: isDark,
                cs: cs,
              ),
            ],
          ),
          if (isUpcoming && !isCancelled) ...[
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'CANCEL',
                    height: ButtonSize.small,
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    textColor: Colors.redAccent,
                    onPressed: () => _showCancelDialog(context, booking.id, isDark, cs),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF171F33) : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(
                      IconsaxPlusLinear.location,
                      color: isDark ? Colors.white : cs.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId, bool isDark, ColorScheme cs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF131B2E) : cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
        ),
        title: Text(
          'Cancel Booking?',
          style: TextStyle(color: isDark ? Colors.white : cs.onSurface, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(color: isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'NO, KEEP IT',
              style: TextStyle(color: isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BookingsCubit>().cancelBooking(bookingId);
              context.pop();
            },
            child: const Text(
              'YES, CANCEL',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailItem(String label, String value, {bool highlight = false, required bool isDark, required ColorScheme cs}) {
    final primaryAccent = isDark ? const Color(0xFF4BE277) : cs.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFBCC7DE).withValues(alpha: 0.5) : cs.onSurfaceVariant.withValues(alpha: 0.8),
            fontSize: 8.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: highlight ? primaryAccent : (isDark ? Colors.white : cs.onSurface),
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

