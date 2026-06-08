import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class BookingCheckoutBar extends StatelessWidget {
  final String pitchId;
  final dynamic extraPitch;
  final bool isFullPayment;

  const BookingCheckoutBar({
    super.key,
    required this.pitchId,
    this.extraPitch,
    required this.isFullPayment,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    final slotsState = context.watch<SlotsCubit>().state;
    final selectedSlot = slotsState.selectedSlot;

    final double basePrice = selectedSlot?.price ?? 0.0;
    final int totalAmount = basePrice.toInt();
    final int depositAmount = (totalAmount * 0.3).toInt();
    final int amountToPayNow = isFullPayment ? totalAmount : depositAmount;

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
                    isFullPayment
                        ? 'booking_slots.total_price'.tr().toUpperCase()
                        : 'booking_slots.deposit_to_pay_now'.tr().toUpperCase(),
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    selectedSlot == null
                        ? '-- ${'pitch_details.egp'.tr()}'
                        : '$amountToPayNow ${'pitch_details.egp'.tr()}',
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
          _ConfirmButton(
            pitchId: pitchId,
            extraPitch: extraPitch,
            isFullPayment: isFullPayment,
          ),
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
      child: Icon(IconsaxPlusBold.ticket, color: cs.primary, size: 20),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final String pitchId;
  final dynamic extraPitch;
  final bool isFullPayment;

  const _ConfirmButton({
    required this.pitchId,
    this.extraPitch,
    required this.isFullPayment,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return BlocListener<CreateBookingCubit, CreateBookingState>(
      listener: (context, state) {
        if (state.status == CreateBookingStatus.success &&
            state.createdBooking != null) {
          final booking = state.createdBooking!;
          final pitch = extraPitch is Pitch ? extraPitch as Pitch : null;

          final amountToPayNow = isFullPayment
              ? booking.totalPrice
              : (booking.totalPrice * 0.3);

          context.push(
            AppRoutes.paymentCheckout,
            extra: {
              'bookingId': booking.id,
              'amount': amountToPayNow,
              'pitchName': pitch?.name ?? 'Premium Pitch',
              'pitchImage': pitch?.imageUrl,
              'bookingDetails': '${booking.date} at ${booking.startTime}',
            },
          );
        } else if (state.status == CreateBookingStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'booking_slots.failed_booking'.tr(),
              ),
              backgroundColor: cs.error,
            ),
          );
        }
      },
      child: BlocBuilder<CreateBookingCubit, CreateBookingState>(
        builder: (context, state) {
          final slotsCubit = context.read<SlotsCubit>();

          return AppButton(
            label: state.status == CreateBookingStatus.loading
                ? 'booking_slots.creating'.tr()
                : 'booking_slots.confirm_booking'.tr(),
            isFullWidth: true,
            isLoading: state.status == CreateBookingStatus.loading,
            height: ButtonSize.large,
            onPressed: () {
              final selectedSlot = slotsCubit.state.selectedSlot;
              if (selectedSlot == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('booking_slots.select_slot_warning'.tr()),
                  ),
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
