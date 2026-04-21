import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for splash animation or logic
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // For now, go to onboarding. 
      // Later this will check auth state.
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      body: Stack(
        children: [
          // Background Decorative Elements (from code.html)
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 600.w,
              height: 600.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center Card
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(48.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'e7gzz',
                        style: tt.displayLarge?.copyWith(
                          color: const Color(0xFF4BE277),
                          fontWeight: FontWeight.w900,
                          fontSize: 64.sp,
                          letterSpacing: -2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'THE DIGITAL CURATOR',
                        style: tt.labelSmall?.copyWith(
                          color: const Color(0xFFBCC7DE),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 100.h),
                
                // Loading indicator section
                Column(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'PREPARING YOUR PITCH',
                      style: tt.labelSmall?.copyWith(
                        color: const Color(0xFFBCC7DE).withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 200.w,
                      height: 1,
                      color: const Color(0xFFBCC7DE).withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom branding
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1,
                  width: 30.w,
                  color: const Color(0xFFBCC7DE).withValues(alpha: 0.2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'CAIRO • DUBAI • RIYADH',
                    style: tt.labelSmall?.copyWith(
                      color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: 30.w,
                  color: const Color(0xFFBCC7DE).withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
