import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -60,
            right: -60,
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
          
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Identity
                    brandHeader(tt, cs),
                    
                    SizedBox(height: 48.h),
                    
                    // Login Container
                    Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131B2E).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(32.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Text(
                            'Welcome Back',
                            style: tt.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Securely log in to manage your bookings.',
                            style: tt.bodySmall?.copyWith(
                              color: const Color(0xFFBCC7DE),
                              fontSize: 14.sp,
                            ),
                          ),
                          
                          SizedBox(height: 32.h),
                          
                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                inputLabel('EMAIL ADDRESS'),
                                AppTextField(
                                  controller: _emailController,
                                  hint: 'name@example.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(IconsaxPlusBold.sms),
                                ),
                                
                                SizedBox(height: 24.h),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    inputLabel('PASSWORD'),
                                    TextButton(
                                      onPressed: () => context.push(AppRoutes.forgotPassword),
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                      child: Text(
                                        'Forgot Password?',
                                        style: tt.labelSmall?.copyWith(
                                          color: cs.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppTextField(
                                  controller: _passwordController,
                                  hint: '••••••••',
                                  obscureText: _obscurePassword,
                                  prefixIcon: const Icon(IconsaxPlusBold.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? IconsaxPlusBold.eye_slash : IconsaxPlusBold.eye,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                
                                SizedBox(height: 32.h),
                                
                                AppButton(
                                  label: 'Login to Account',
                                  isFullWidth: true,
                                  height: ButtonSize.large,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      // Handle logic
                                      context.go(AppRoutes.home);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          // Divider
                          SizedBox(height: 32.h),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: tt.labelSmall?.copyWith(
                                    color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          
                          // Social Logins
                          Row(
                            children: [
                              Expanded(
                                child: socialButton(
                                  label: 'Google',
                                  iconPath: AppAssets.googleIcon,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: socialButton(
                                  label: 'Facebook',
                                  iconPath: AppAssets.facebookIcon,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 32.h),
                          
                          // Footer Action
                          Center(
                            child: TextButton(
                              onPressed: () => context.push(AppRoutes.signup),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'New to the pitch? ',
                                  style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
                                  children: [
                                    TextSpan(
                                      text: 'Create an account',
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 48.h),
                    
                    // Legal/Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        legalLink('PRIVACY POLICY'),
                        SizedBox(width: 24.w),
                        legalLink('TERMS OF SERVICE'),
                        SizedBox(width: 24.w),
                        legalLink('SUPPORT'),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget brandHeader(TextTheme tt, ColorScheme cs) {
    return Column(
      children: [
        Text(
          'e7gzz',
          style: tt.displayLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            fontSize: 48.sp,
            letterSpacing: -3,
          ),
        ),
        Text(
          'THE STADIUM IS CALLING',
          style: tt.labelSmall?.copyWith(
            color: const Color(0xFFBCC7DE).withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget inputLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        text,
        style: context.theme.textTheme.labelSmall?.copyWith(
          color: const Color(0xFFBCC7DE).withValues(alpha: 0.6),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget socialButton({
    required String label,
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 22.w),
            SizedBox(width: 12.w),
            Text(
              label,
              style: context.theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget legalLink(String text) {
    return Text(
      text,
      style: context.theme.textTheme.labelSmall?.copyWith(
        color: const Color(0xFFBCC7DE).withValues(alpha: 0.4),
        fontSize: 10.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }
}
