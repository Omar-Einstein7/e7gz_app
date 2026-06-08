import 'package:e7gz/src/imports/core_imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';

class PaymentPlanSelector extends StatelessWidget {
  final bool isFullPayment;
  final Function(bool) onPlanChanged;

  const PaymentPlanSelector({
    super.key,
    required this.isFullPayment,
    required this.onPlanChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    final slotsState = context.watch<SlotsCubit>().state;
    final selectedSlot = slotsState.selectedSlot;

    final double basePrice = selectedSlot?.price ?? 350.0;
    final int totalAmount = basePrice.toInt();
    final int depositAmount = (totalAmount * 0.3).toInt(); // 30% deposit
    final int remainingAmount = totalAmount - depositAmount;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            children: [
              Icon(IconsaxPlusBold.card, color: cs.primary, size: 24),
              SizedBox(width: AppSpacing.md.w),
              Text(
                'booking_slots.payment_plan'.tr(),
                style: typography.titleLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          padding: EdgeInsets.all(AppSpacing.lg.w),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: AppRadius.bxxl.r,
          ),
          child: Column(
            children: [
              _PaymentOption(
                title: 'booking_slots.full_payment'.tr(),
                subtitle: 'booking_slots.full_desc_param'.tr(
                  namedArgs: {'total': totalAmount.toString()},
                ),
                price: totalAmount.toString(),
                isSelected: isFullPayment,
                onTap: () => onPlanChanged(true),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Divider(color: cs.outlineVariant),
              SizedBox(height: AppSpacing.lg.h),
              _PaymentOption(
                title: 'booking_slots.deposit_payment'.tr(),
                subtitle: 'booking_slots.deposit_desc_param'.tr(
                  namedArgs: {
                    'deposit': depositAmount.toString(),
                    'remaining': remainingAmount.toString(),
                  },
                ),
                price: depositAmount.toString(),
                isSelected: !isFullPayment,
                onTap: () => onPlanChanged(false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: cs.primary, width: 2) : null,
          borderRadius: AppRadius.blg.r,
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
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  RichText(
                    text: TextSpan(
                      text: '$price ',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 20.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'pitch_details.egp'.tr(),
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _SelectionCircle(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  final bool isSelected;
  const _SelectionCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? cs.primary : cs.onSurfaceVariant,
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
    );
  }
}
