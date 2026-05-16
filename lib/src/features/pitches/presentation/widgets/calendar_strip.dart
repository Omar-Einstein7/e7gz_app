import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';

class CalendarStrip extends StatelessWidget {
  final List<DateTime> weekDates;
  final int selectedDateIndex;
  final Function(int, DateTime) onDateSelected;

  const CalendarStrip({
    super.key,
    required this.weekDates,
    required this.selectedDateIndex,
    required this.onDateSelected,
  });

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
                'Select Date',
                style: typography.headlineSmall?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(weekDates[selectedDateIndex]),
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final date = weekDates[index];
              final isSelected = index == selectedDateIndex;
              return _DateItem(
                date: date,
                isSelected: isSelected,
                onTap: () => onDateSelected(index, date),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 76.w,
        margin: EdgeInsets.only(right: AppSpacing.sm.w),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surfaceContainerHigh,
          borderRadius: AppRadius.blg.r,
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
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected ? cs.onPrimary : cs.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
