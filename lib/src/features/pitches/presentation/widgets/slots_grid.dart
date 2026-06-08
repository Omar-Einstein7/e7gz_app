import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class SlotsGrid extends StatelessWidget {
  const SlotsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Slots',
                style: typography.headlineSmall?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const _SlotsLegend(),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        BlocBuilder<SlotsCubit, SlotsState>(
          builder: (context, state) {
            if (state.status == SlotsStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: cs.primary),
              );
            }
            if (state.status == SlotsStatus.failure) {
              return _ErrorState(errorMessage: state.errorMessage);
            }
            if (state.slots.isEmpty) {
              return const _EmptyState();
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md.w,
                mainAxisSpacing: AppSpacing.md.h,
                childAspectRatio: 2.2,
              ),
              itemCount: state.slots.length,
              itemBuilder: (context, index) {
                final slot = state.slots[index];
                final isSelected = state.selectedSlot == slot;
                return _SlotBox(
                  slot: slot,
                  isSelected: isSelected,
                  onTap: () => context.read<SlotsCubit>().selectSlot(slot),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _SlotsLegend extends StatelessWidget {
  const _SlotsLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IndicatorChip(label: 'AVAILABLE', color: context.colorScheme.primary),
        SizedBox(width: AppSpacing.md.w),
        _IndicatorChip(
          label: 'BOOKED',
          color: context.colorScheme.surfaceVariant,
        ),
      ],
    );
  }
}

class _IndicatorChip extends StatelessWidget {
  final String label;
  final Color color;

  const _IndicatorChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppSpacing.xs.w),
        Text(
          label,
          style: TextStyle(
            color: context.colorScheme.onSurfaceVariant,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SlotBox extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _SlotBox({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final isBooked = !slot.isAvailable;

    final bgColor = isBooked
        ? cs.surfaceVariant.withOpacity(0.3)
        : (isSelected ? cs.primary : cs.surfaceContainerHigh);

    final onColor = isBooked
        ? cs.onSurfaceVariant.withOpacity(0.4)
        : (isSelected ? cs.onPrimary : cs.onSurfaceVariant);

    final timeColor = isBooked
        ? cs.onSurfaceVariant.withOpacity(0.5)
        : (isSelected ? cs.onPrimary : cs.onSurface);

    final Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.blg.r,
        border: isBooked
            ? Border.all(color: cs.outlineVariant.withOpacity(0.2), width: 1)
            : null,
        boxShadow: isSelected
            ? [BoxShadow(color: cs.primary.withOpacity(0.2), blurRadius: 10)]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isBooked) ...[
                Icon(IconsaxPlusBold.lock, color: onColor, size: 10.sp),
                SizedBox(width: 4.w),
              ],
              Text(
                'SLOT',
                style: TextStyle(
                  color: onColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            slot.startTime,
            style: TextStyle(
              color: timeColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              decoration: isBooked ? TextDecoration.lineThrough : null,
            ),
          ),
          Text(
            isBooked ? 'BOOKED' : '${slot.price.toInt()} EGP',
            style: TextStyle(
              color: isBooked
                  ? cs.error.withOpacity(0.6)
                  : (isSelected ? cs.onPrimary : cs.primary),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    if (isBooked) {
      return AbsorbPointer(child: Opacity(opacity: 0.5, child: content));
    }

    return GestureDetector(onTap: onTap, child: content);
  }
}

class _ErrorState extends StatelessWidget {
  final String? errorMessage;
  const _ErrorState({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage ?? 'Error loading slots',
        style: TextStyle(color: context.colorScheme.error, fontSize: 14.sp),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No slots available on this date',
        style: TextStyle(
          color: context.colorScheme.onSurfaceVariant,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
