import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            children: [
              Icon(
                IconsaxPlusBold.card,
                color: cs.primary,
                size: 24,
              ),
              SizedBox(width: AppSpacing.md.w),
              Text(
                'Payment Plan',
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
                title: 'Full Payment',
                subtitle: 'Pay the total amount now to secure your pitch immediately. No hassle at the venue.',
                price: '500',
                isSelected: isFullPayment,
                onTap: () => onPlanChanged(true),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Divider(color: cs.outlineVariant),
              SizedBox(height: AppSpacing.lg.h),
              _PaymentOption(
                title: 'Deposit',
                subtitle: 'Pay only 150 EGP now. The remaining 350 EGP will be paid at the stadium entrance.',
                price: '150',
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
                          text: 'EGP',
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
