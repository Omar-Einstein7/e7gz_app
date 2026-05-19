import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import '../widgets/widgets.dart';

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
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bookings.title'.tr(),
          style: typography.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          labelColor: colors.primary,
          unselectedLabelColor: colors.onSurfaceVariant,
          labelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
          tabs: [
            Tab(text: 'bookings.upcoming'.tr().toUpperCase()),
            Tab(text: 'bookings.past'.tr().toUpperCase()),
          ],
        ),
      ),
      body: BlocBuilder<BookingsCubit, BookingsState>(
        builder: (context, state) {
          if (state.status == BookingsStatus.loading ||
              state.status == BookingsStatus.initial) {
            return Skeletonizer(
              enabled: true,
              child: BookingsList(
                bookings: List.generate(5, (_) => Booking.empty()),
                isUpcoming: true,
              ),
            );
          }
          if (state.status == BookingsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'bookings.failed_load'.tr(),
                style: TextStyle(color: colors.error, fontSize: 14.sp),
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
              BookingsList(bookings: upcomingBookings, isUpcoming: true),
              BookingsList(bookings: pastBookings, isUpcoming: false),
            ],
          );
        },
      ),
    );
  }
}
