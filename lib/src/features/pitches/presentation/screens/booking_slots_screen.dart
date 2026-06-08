import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/domain/usecases/booking_usecases.dart';
import 'package:e7gz/src/di/injection_container.dart';

import '../widgets/pitch_mini_hero.dart';
import '../widgets/calendar_strip.dart';
import '../widgets/slots_grid.dart';
import '../widgets/payment_plan_selector.dart';
import '../widgets/booking_checkout_bar.dart';

class BookingSlotsScreen extends StatefulWidget {
  final String pitchId;
  final dynamic extraPitch;

  const BookingSlotsScreen({super.key, required this.pitchId, this.extraPitch});

  @override
  State<BookingSlotsScreen> createState() => _BookingSlotsScreenState();
}

class _BookingSlotsScreenState extends State<BookingSlotsScreen> {
  int _selectedDateIndex = 0;
  bool _isFullPayment = true;
  late List<DateTime> _weekDates;
  late SlotsCubit _slotsCubit;

  @override
  void initState() {
    super.initState();
    _weekDates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    _slotsCubit = SlotsCubit(
      getAvailableSlots: sl<GetAvailableSlotsUseCase>(),
      pitchId: widget.pitchId,
    );
    _loadSlotsForDate(_weekDates[_selectedDateIndex]);
  }

  void _loadSlotsForDate(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    _slotsCubit.loadSlots(dateString);
  }

  @override
  void dispose() {
    _slotsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return BlocProvider.value(
      value: _slotsCubit,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: colors.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'e7gzz',
            style: typography.headlineSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.md.w),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: colors.surfaceContainerHigh,
                child: Icon(
                  IconsaxPlusBold.user,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PitchMiniHero(extraPitch: widget.extraPitch),

              SizedBox(height: AppSpacing.md.h),

              CalendarStrip(
                weekDates: _weekDates,
                selectedDateIndex: _selectedDateIndex,
                onDateSelected: (index, date) {
                  setState(() => _selectedDateIndex = index);
                  _loadSlotsForDate(date);
                },
              ),

              SizedBox(height: AppSpacing.xxl.h),

              const SlotsGrid(),

              SizedBox(height: AppSpacing.xxl.h),

              PaymentPlanSelector(
                isFullPayment: _isFullPayment,
                onPlanChanged: (isFull) =>
                    setState(() => _isFullPayment = isFull),
              ),

              SizedBox(height: AppSpacing.xxl.h),

              BookingCheckoutBar(
                pitchId: widget.pitchId,
                extraPitch: widget.extraPitch,
                isFullPayment: _isFullPayment,
              ),

              SizedBox(height: AppSpacing.xl.h),
            ],
          ),
        ),
      ),
    );
  }
}
