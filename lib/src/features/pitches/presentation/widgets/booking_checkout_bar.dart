import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';

class BookingCheckoutBar extends StatelessWidget {
  final String pitchId;
  final dynamic extraPitch;

  const BookingCheckoutBar({
    super.key,
    required this.pitchId,
    this.extraPitch,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TicketIcon(),
              SizedBox(width: AppSpacing.md.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PRICE',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '500 EGP',
                    style: typography.titleLarge?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          _ConfirmButton(pitchId: pitchId, extraPitch: extraPitch),
        ],
      ),
    );
  }
}

class _TicketIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: cs.surfaceContainerHigh,
      child: Icon(
        IconsaxPlusBold.ticket,
        color: cs.primary,
        size: 20,
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final String pitchId;
  final dynamic extraPitch;

  const _ConfirmButton({required this.pitchId, this.extraPitch});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return BlocListener<CreateBookingCubit, CreateBookingState>(
      listener: (context, state) {
        if (state.status == CreateBookingStatus.success && state.createdBooking != null) {
          final booking = state.createdBooking!;
          final pitch = extraPitch is Pitch ? extraPitch as Pitch : null;
          
          context.push(
            AppRoutes.paymentCheckout,
            extra: {
              'bookingId': booking.id,
              'amount': booking.totalPrice,
              'pitchName': pitch?.name ?? 'Premium Pitch',
              'pitchImage': pitch?.imageUrl,
              'bookingDetails': '${booking.date} at ${booking.startTime}',
            },
          );
        } else if (state.status == CreateBookingStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to create booking'),
              backgroundColor: cs.error,
            ),
          );
        }
      },
      child: BlocBuilder<CreateBookingCubit, CreateBookingState>(
        builder: (context, state) {
          final slotsCubit = context.read<SlotsCubit>();
          
          return AppButton(
            label: state.status == CreateBookingStatus.loading ? 'Creating...' : 'Confirm Booking',
            isFullWidth: true,
            isLoading: state.status == CreateBookingStatus.loading,
            height: ButtonSize.large,
            onPressed: () {
              final selectedSlot = slotsCubit.state.selectedSlot;
              if (selectedSlot == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a time slot')),
                );
                return;
              }

              context.read<CreateBookingCubit>().createBooking(
                pitchId: pitchId,
                date: slotsCubit.state.selectedDate ?? '',
                startTime: selectedSlot.startTime,
                endTime: selectedSlot.endTime,
              );
            },
          );
        },
      ),
    );
  }
}
