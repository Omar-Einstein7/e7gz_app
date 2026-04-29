import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/bookings/domain/usecases/booking_usecases.dart';
import 'package:e7gz/src/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:e7gz/src/features/bookings/data/datasources/booking_remote_datasource.dart';

class BookingSlotsScreen extends StatefulWidget {
  final String pitchId;
  final dynamic extraPitch;

  const BookingSlotsScreen({
    super.key,
    required this.pitchId,
    this.extraPitch,
  });

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
    _weekDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    _slotsCubit = SlotsCubit(
      getAvailableSlots: GetAvailableSlotsUseCase(BookingRepositoryImpl(BookingRemoteDataSource())),
      pitchId: widget.pitchId,
    );
    _loadSlotsForDate(_weekDates[_selectedDateIndex]);
  }

  void _loadSlotsForDate(DateTime date) {
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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

    return BlocProvider.value(
      value: _slotsCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1326),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                backgroundColor: const Color(0xFF2D3449),
                child: const Icon(IconsaxPlusBold.user, size: 20, color: Colors.white),
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
                      widget.extraPitch is Pitch && (widget.extraPitch as Pitch).imageUrl.isNotEmpty
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
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
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
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'PREMIUM TURF',
                              style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.extraPitch is Pitch ? (widget.extraPitch as Pitch).name : 'Pitch Details',
                            style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFBCC7DE), size: 14),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  widget.extraPitch is Pitch ? (widget.extraPitch as Pitch).location.city : '',
                                  style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 13.sp),
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
                      style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_weekDates[_selectedDateIndex]),
                      style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
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
                          color: isSelected ? cs.primary : const Color(0xFF171F33),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: isSelected ? [
                            BoxShadow(color: cs.primary.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2)
                          ] : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date).toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF003915) : const Color(0xFFBCC7DE),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF003915) : Colors.white,
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
                      style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                         indicatorChip('AVAILABLE', cs.primary),
                         SizedBox(width: 12.w),
                         indicatorChip('BOOKED', const Color(0xFF3E495D)),
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == SlotsStatus.failure) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'Error loading slots',
                        style: TextStyle(color: Colors.redAccent, fontSize: 14.sp),
                      ),
                    );
                  }
                  if (state.slots.isEmpty) {
                    return Center(
                      child: Text(
                        'No slots available on this date',
                        style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp),
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
                      return slotBox(slot, isSelected, cs, context);
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
                   const Icon(IconsaxPlusBold.card, color: Color(0xFF4BE277), size: 24),
                   SizedBox(width: 12.w),
                   Text(
                    'Payment Plan',
                    style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
            
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Column(
                children: [
                  paymentOption(
                    title: 'Full Payment',
                    subtitle: 'Pay the total amount now to secure your pitch immediately. No hassle at the venue.',
                    price: '500',
                    isSelected: _isFullPayment,
                    onTap: () => setState(() => _isFullPayment = true),
                    cs: cs,
                  ),
                  SizedBox(height: 24.h),
                  Divider(color: Colors.white.withValues(alpha: 0.05)),
                  SizedBox(height: 24.h),
                  paymentOption(
                    title: 'Deposit',
                    subtitle: 'Pay only 150 EGP now. The remaining 350 EGP will be paid at the stadium entrance.',
                    price: '150',
                    isSelected: !_isFullPayment,
                    onTap: () => setState(() => _isFullPayment = false),
                    cs: cs,
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
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(48.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: const Color(0xFF171F33),
                        child: const Icon(IconsaxPlusBold.ticket, color: Color(0xFF4BE277), size: 20),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL PRICE',
                            style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '500 EGP',
                            style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  BlocListener<CreateBookingCubit, CreateBookingState>(
                    listener: (context, state) {
                      if (state.status == CreateBookingStatus.success && state.createdBooking != null) {
                        final booking = state.createdBooking!;
                        context.push(
                          AppRoutes.paymentCheckout,
                          extra: {
                            'bookingId': booking.id,
                            'amount': booking.totalPrice,
                            'pitchName': widget.extraPitch is Pitch ? (widget.extraPitch as Pitch).name : 'Premium Pitch',
                            'pitchImage': widget.extraPitch is Pitch ? (widget.extraPitch as Pitch).imageUrl : null,
                            'bookingDetails': '${booking.date} at ${booking.startTime}',
                          },
                        );
                      } else if (state.status == CreateBookingStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage ?? 'Failed to create booking')),
                        );
                      }
                    },
                    child: BlocBuilder<CreateBookingCubit, CreateBookingState>(
                      builder: (context, state) {
                        return AppButton(
                          label: state.status == CreateBookingStatus.loading ? 'Creating...' : 'Confirm Booking',
                          isFullWidth: true,
                          isLoading: state.status == CreateBookingStatus.loading,
                          height: ButtonSize.large,
                          onPressed: () {
                            final selectedSlot = _slotsCubit.state.selectedSlot;
                            if (selectedSlot == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a time slot')),
                              );
                              return;
                            }

                            context.read<CreateBookingCubit>().createBooking(
                                  pitchId: widget.pitchId,
                                  date: _slotsCubit.state.selectedDate ?? '',
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
      bottomNavigationBar: customBottomNav(cs),
    ))
    ;
  }

  Widget indicatorChip(String label, Color color) {
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
          style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget slotBox(TimeSlot slot, bool isSelected, ColorScheme cs, BuildContext context) {
    final isBooked = !slot.isAvailable;
    return GestureDetector(
      onTap: isBooked ? null : () => context.read<SlotsCubit>().selectSlot(slot),
      child: Container(
        decoration: BoxDecoration(
          color: isBooked 
              ? const Color(0xFF131B2E).withValues(alpha: 0.5) 
              : (isSelected ? cs.primary : const Color(0xFF171F33)),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isSelected ? [
            BoxShadow(color: cs.primary.withValues(alpha: 0.2), blurRadius: 10)
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SLOT',
              style: TextStyle(
                color: isBooked 
                    ? const Color(0xFFBCC7DE).withValues(alpha: 0.3)
                    : (isSelected ? const Color(0xFF003915) : const Color(0xFFBCC7DE)),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              slot.startTime,
              style: TextStyle(
                color: isBooked 
                    ? const Color(0xFFBCC7DE).withValues(alpha: 0.5)
                    : (isSelected ? const Color(0xFF003915) : Colors.white),
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              isBooked ? 'Booked' : '${slot.price.toInt()} EGP',
              style: TextStyle(
                color: isBooked 
                    ? const Color(0xFFBCC7DE).withValues(alpha: 0.3)
                    : (isSelected ? const Color(0xFF003915) : cs.primary),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: cs.primary, width: 2) : null,
          borderRadius: BorderRadius.circular(24.r),
          color: isSelected ? cs.primary.withValues(alpha: 0.05) : Colors.transparent,
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
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp, height: 1.4),
                  ),
                  SizedBox(height: 12.h),
                  RichText(
                    text: TextSpan(
                      text: '$price ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20.sp),
                      children: [
                        TextSpan(text: 'EGP', style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp)),
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
                border: Border.all(color: isSelected ? cs.primary : const Color(0xFFBCC7DE), width: 2),
              ),
              child: isSelected ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                ),
              ) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget customBottomNav(ColorScheme cs) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1326),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navItem(0, 'HOME', IconsaxPlusBold.home, false, cs),
          navItem(1, 'SEARCH', IconsaxPlusLinear.search_normal_1, false, cs),
          navItem(2, 'BOOKING', IconsaxPlusBold.calendar_1, true, cs),
          navItem(3, 'MATCHES', IconsaxPlusLinear.user_octagon, false, cs),
          navItem(4, 'PROFILE', IconsaxPlusLinear.user, false, cs),
        ],
      ),
    );
  }

  Widget navItem(int index, String label, IconData icon, bool isSelected, ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSelected)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF003915), size: 24),
          )
        else
          Icon(icon, color: const Color(0xFFBCC7DE), size: 24),
      ],
    );
  }
}
