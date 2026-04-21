import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
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
                  color: const Color(0xFF4BE277).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4BE277).withValues(alpha: 0.3), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4BE277),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Color(0xFF003915), size: 48),
                  ),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              
              SizedBox(height: 48.h),
              
              Text(
                'Pitch Ready!',
                style: tt.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 36.sp,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              
              SizedBox(height: 16.h),
              
              Text(
                'Your booking has been confirmed.\nThe stadium is waiting for you.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  color: const Color(0xFFBCC7DE),
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 600.ms),
              
              SizedBox(height: 56.h),
              
              // Booking Details Card (Glass)
              Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    detailRow('STADIUM', 'Anfield Arena Cairo', tt),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(child: detailRow('DATE', 'Oct 23, 2023', tt)),
                        Expanded(child: detailRow('TIME', '21:00 - 22:00', tt)),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    detailRow('TOTAL PAID', '500 EGP', tt, isPrimary: true),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
              
              SizedBox(height: 64.h),
              
              AppButton(
                label: 'DOWNLOAD TICKET',
                isFullWidth: true,
                height: ButtonSize.large,
                onPressed: () {},
                suffixIcon: const Icon(Icons.download),
              ),
              
              SizedBox(height: 16.h),
              
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: const Color(0xFFBCC7DE),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailRow(String label, String value, TextTheme tt, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: tt.titleMedium?.copyWith(
            color: isPrimary ? const Color(0xFF4BE277) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
