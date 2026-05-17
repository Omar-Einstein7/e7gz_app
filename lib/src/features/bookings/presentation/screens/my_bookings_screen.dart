import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import '../widgets/booking_card.dart';

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
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          'bookings.title'.tr(),
          style: typography.headlineSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: cs.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          labelColor: cs.primary,
          unselectedLabelColor: cs.onSurfaceVariant,
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
              child: _BookingsList(
                bookings: List.generate(5, (_) => Booking.empty()),
                isUpcoming: true,
              ),
            );
          }
          if (state.status == BookingsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'bookings.failed_load'.tr(),
                style: TextStyle(color: cs.error, fontSize: 14.sp),
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
              _BookingsList(
                bookings: upcomingBookings,
                isUpcoming: true,
              ),
              _BookingsList(
                bookings: pastBookings,
                isUpcoming: false,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final bool isUpcoming;

  const _BookingsList({
    required this.bookings,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          isUpcoming ? 'bookings.no_upcoming'.tr() : 'bookings.no_past'.tr(),
          style: TextStyle(color: context.colorScheme.onSurfaceVariant, fontSize: 14.sp),
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

