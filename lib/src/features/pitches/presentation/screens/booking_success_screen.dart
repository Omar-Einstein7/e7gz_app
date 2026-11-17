import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon Animation/Glass Container
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: colors.onPrimary,
                      size: 48,
                    ),
                  ),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

              SizedBox(height: 48.h),

              Text(
                'Pitch Ready!',
                style: tt.displaySmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 36.sp,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

              SizedBox(height: 16.h),

              Text(
                'Your booking has been confirmed.\nThe stadium is waiting for you.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 600.ms),

              SizedBox(height: 48.h),

              // Booking Details Card (Glass)
              Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: colors.outlineVariant,
                  ),
                ),
                child: Column(
                  children: [
                    detailRow('STADIUM', 'Anfield Arena Cairo', tt, colors),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(child: detailRow('DATE', 'Oct 23, 2023', tt, colors)),
                        Expanded(child: detailRow('TIME', '21:00 - 22:00', tt, colors)),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    detailRow('TOTAL PAID', '500 EGP', tt, colors, isPrimary: true),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),

              SizedBox(height: 48.h),

              AppButton(
                label: 'DOWNLOAD TICKET',
                isFullWidth: true,
                height: ButtonSize.large,
                onPressed: () {},
                suffixIcon: const Icon(Icons.download),
              ),

              SizedBox(height: 8.h),

              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(
                  'Back to Home',
                  style: tt.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailRow(
    String label,
    String value,
    TextTheme tt,
    ColorScheme colors, {
    bool isPrimary = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: tt.titleMedium?.copyWith(
            color: isPrimary ? colors.primary : colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
