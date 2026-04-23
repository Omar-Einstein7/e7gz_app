import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/brand_header.dart';
import '../widgets/social_login_button.dart';

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
    final colors = context.colors;
    final typography = context.typography;

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
                color: colors.primary.withValues(alpha: 0.1),
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
                color: colors.primaryContainer.withValues(alpha: 0.1),
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
                    const BrandHeader(),

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
                            style: typography.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Securely log in to manage your bookings.',
                            style: typography.bodySmall?.copyWith(
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
                                _inputLabel(context, 'EMAIL ADDRESS'),
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
                                    _inputLabel(context, 'PASSWORD'),
                                    TextButton(
                                      onPressed: () => context.push(AppRoutes.forgotPassword),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: typography.labelSmall?.copyWith(
                                          color: colors.primary,
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
                                  style: typography.labelSmall?.copyWith(
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
                                child: SocialLoginButton(
                                  label: 'Google',
                                  iconPath: AppAssets.googleIcon,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: SocialLoginButton(
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
                                  style: typography.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
                                  children: [
                                    TextSpan(
                                      text: 'Create an account',
                                      style: TextStyle(
                                        color: colors.primary,
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
                        _legalLink(context, 'PRIVACY POLICY'),
                        SizedBox(width: 10.w),
                        _legalLink(context, 'TERMS OF SERVICE'),
                        SizedBox(width: 10.w),
                        _legalLink(context, 'SUPPORT'),
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

  Widget _inputLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        text,
        style: context.typography.labelSmall?.copyWith(
          color: const Color(0xFFBCC7DE).withValues(alpha: 0.6),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _legalLink(BuildContext context, String text) {
    return Text(
      text,
      style: context.typography.labelSmall?.copyWith(
        color: const Color(0xFFBCC7DE).withValues(alpha: 0.4),
        fontSize: 10.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }
}

