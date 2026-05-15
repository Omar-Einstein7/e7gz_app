import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/bookings/domain/usecases/booking_usecases.dart';
import 'package:e7gz/src/di/injection_container.dart';

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
    final dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    _slotsCubit.loadSlots(dateString);
  }

  @override
  void dispose() {
    _slotsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isDark = context.theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0B1326) : cs.surface;
    final cardBg = isDark ? const Color(0xFF131B2E) : cs.surfaceContainerLow;
    final textColor = isDark ? Colors.white : cs.onSurface;
    final subtitleColor = isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant;
    final primaryAccent = isDark ? const Color(0xFF4BE277) : cs.primary;
    final unselectedCardBg = isDark ? const Color(0xFF171F33) : cs.surfaceContainerHighest;

    return BlocProvider.value(
      value: _slotsCubit,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => context.pop(),
            ),
          ),
          title: Text(
            'e7gzz',
            style: tt.headlineSmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? const Color(0xFF2D3449) : cs.surfaceContainerHighest,
                child: Icon(
                  IconsaxPlusBold.user,
                  size: 20,
                  color: isDark ? Colors.white : cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pitch Mini-Hero
              Container(
                height: 180.h,
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.extraPitch is Pitch &&
                              (widget.extraPitch as Pitch).imageUrl.isNotEmpty
                          ? (widget.extraPitch as Pitch).imageUrl
                          : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF22C55E,
                              ).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'PREMIUM TURF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.extraPitch is Pitch
                                ? (widget.extraPitch as Pitch).name
                                : 'Pitch Details',
                            style: tt.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFFBCC7DE),
                                size: 14,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  widget.extraPitch is Pitch
                                      ? (widget.extraPitch as Pitch)
                                            .location
                                            .city
                                      : '',
                                  style: TextStyle(
                                    color: const Color(0xFFBCC7DE),
                                    fontSize: 13.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Select Date
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: tt.headlineSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'MMMM yyyy',
                      ).format(_weekDates[_selectedDateIndex]),
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final date = _weekDates[index];
                    final isSelected = index == _selectedDateIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedDateIndex = index);
                        _loadSlotsForDate(date);
                      },
                      child: Container(
                        width: 76.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primary
                              : unselectedCardBg,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date).toUpperCase(),
                              style: TextStyle(
                                color: isSelected
                                    ? (isDark ? const Color(0xFF003915) : cs.onPrimary)
                                    : subtitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? (isDark ? const Color(0xFF003915) : cs.onPrimary)
                                    : textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 24.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 40.h),

              // Available Slots
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Slots',
                      style: tt.headlineSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        indicatorChip('AVAILABLE', cs.primary, subtitleColor),
                        SizedBox(width: 12.w),
                        indicatorChip('BOOKED', isDark ? const Color(0xFF3E495D) : cs.outlineVariant, subtitleColor),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Slots Grid
              BlocBuilder<SlotsCubit, SlotsState>(
                builder: (context, state) {
                  if (state.status == SlotsStatus.loading) {
                    return Center(child: CircularProgressIndicator(color: cs.primary));
                  }
                  if (state.status == SlotsStatus.failure) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'Error loading slots',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }
                  if (state.slots.isEmpty) {
                    return Center(
                      child: Text(
                        'No slots available on this date',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: state.slots.length,
                    itemBuilder: (context, index) {
                      final slot = state.slots[index];
                      final isSelected = state.selectedSlot == slot;
                      return slotBox(slot, isSelected, cs, context, isDark, unselectedCardBg, subtitleColor, textColor);
                    },
                  );
                },
              ),

              SizedBox(height: 48.h),

              // Payment Plan
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Icon(
                      IconsaxPlusBold.card,
                      color: primaryAccent,
                      size: 24,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Payment Plan',
                      style: tt.titleLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  children: [
                    paymentOption(
                      title: 'Full Payment',
                      subtitle:
                          'Pay the total amount now to secure your pitch immediately. No hassle at the venue.',
                      price: '500',
                      isSelected: _isFullPayment,
                      onTap: () => setState(() => _isFullPayment = true),
                      cs: cs,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    SizedBox(height: 24.h),
                    Divider(color: isDark ? Colors.white.withValues(alpha: 0.05) : cs.outlineVariant),
                    SizedBox(height: 24.h),
                    paymentOption(
                      title: 'Deposit',
                      subtitle:
                          'Pay only 150 EGP now. The remaining 350 EGP will be paid at the stadium entrance.',
                      price: '150',
                      isSelected: !_isFullPayment,
                      onTap: () => setState(() => _isFullPayment = false),
                      cs: cs,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 48.h),

              // Checkout Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(48.r),
                  border: isDark ? null : Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: unselectedCardBg,
                          child: Icon(
                            IconsaxPlusBold.ticket,
                            color: primaryAccent,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL PRICE',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '500 EGP',
                              style: tt.titleLarge?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    BlocListener<CreateBookingCubit, CreateBookingState>(
                      listener: (context, state) {
                        if (state.status == CreateBookingStatus.success &&
                            state.createdBooking != null) {
                          final booking = state.createdBooking!;
                          context.push(
                            AppRoutes.paymentCheckout,
                            extra: {
                              'bookingId': booking.id,
                              'amount': booking.totalPrice,
                              'pitchName': widget.extraPitch is Pitch
                                  ? (widget.extraPitch as Pitch).name
                                  : 'Premium Pitch',
                              'pitchImage': widget.extraPitch is Pitch
                                  ? (widget.extraPitch as Pitch).imageUrl
                                  : null,
                              'bookingDetails':
                                  '${booking.date} at ${booking.startTime}',
                            },
                          );
                        } else if (state.status ==
                            CreateBookingStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.errorMessage ??
                                    'Failed to create booking',
                              ),
                            ),
                          );
                        }
                      },
                      child:
                          BlocBuilder<CreateBookingCubit, CreateBookingState>(
                            builder: (context, state) {
                              return AppButton(
                                label:
                                    state.status == CreateBookingStatus.loading
                                    ? 'Creating...'
                                    : 'Confirm Booking',
                                isFullWidth: true,
                                isLoading:
                                    state.status == CreateBookingStatus.loading,
                                height: ButtonSize.large,
                                onPressed: () {
                                  final selectedSlot =
                                      _slotsCubit.state.selectedSlot;
                                  if (selectedSlot == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a time slot',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context
                                      .read<CreateBookingCubit>()
                                      .createBooking(
                                        pitchId: widget.pitchId,
                                        date:
                                            _slotsCubit.state.selectedDate ??
                                            '',
                                        startTime: selectedSlot.startTime,
                                        endTime: selectedSlot.endTime,
                                      );
                                },
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget indicatorChip(String label, Color color, Color subtitleColor) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            color: subtitleColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget slotBox(
    TimeSlot slot,
    bool isSelected,
    ColorScheme cs,
    BuildContext context,
    bool isDark,
    Color unselectedCardBg,
    Color subtitleColor,
    Color textColor,
  ) {
    final isBooked = !slot.isAvailable;
    return GestureDetector(
      onTap: isBooked
          ? null
          : () => context.read<SlotsCubit>().selectSlot(slot),
      child: Container(
        decoration: BoxDecoration(
          color: isBooked
              ? (isDark ? const Color(0xFF131B2E).withValues(alpha: 0.5) : cs.surfaceContainerLow.withValues(alpha: 0.5))
              : (isSelected ? cs.primary : unselectedCardBg),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SLOT',
              style: TextStyle(
                color: isBooked
                    ? subtitleColor.withValues(alpha: 0.3)
                    : (isSelected
                          ? (isDark ? const Color(0xFF003915) : cs.onPrimary)
                          : subtitleColor),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              slot.startTime,
              style: TextStyle(
                color: isBooked
                    ? subtitleColor.withValues(alpha: 0.5)
                    : (isSelected ? (isDark ? const Color(0xFF003915) : cs.onPrimary) : textColor),
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              isBooked ? 'Booked' : '${slot.price.toInt()} EGP',
              style: TextStyle(
                color: isBooked
                    ? subtitleColor.withValues(alpha: 0.3)
                    : (isSelected ? (isDark ? const Color(0xFF003915) : cs.onPrimary) : cs.primary),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentOption({
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme cs,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: cs.primary, width: 2) : null,
          borderRadius: BorderRadius.circular(24.r),
          color: isSelected
              ? cs.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  RichText(
                    text: TextSpan(
                      text: '$price ',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 20.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'EGP',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? cs.primary : subtitleColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
