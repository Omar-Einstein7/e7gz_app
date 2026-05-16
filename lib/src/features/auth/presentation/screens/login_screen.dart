import 'dart:ui';
import 'package:e7gz/src/features/auth/presentation/providers/auth_bloc.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import 'package:e7gz/src/utils/validators.dart';
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
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Scaffold(
      backgroundColor: cs.background,
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
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Identity
                    const BrandHeader(),

                    SizedBox(height: AppSpacing.xxl.h),

                    // Login Container
                    Container(
                      padding: EdgeInsets.all(AppSpacing.xl.w),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow.withValues(alpha: 0.8),
                        borderRadius: AppRadius.bxxl.r,
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
                              color: cs.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs.h),
                          Text(
                            'Securely log in to manage your bookings.',
                            style: typography.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontSize: 14.sp,
                            ),
                          ),

                          SizedBox(height: AppSpacing.xl.h),

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
                                  validator: Validators.email,
                                ),

                                SizedBox(height: AppSpacing.lg.h),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _inputLabel(context, 'PASSWORD'),
                                    TextButton(
                                      onPressed: () => context.push(
                                        AppRoutes.forgotPassword,
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: typography.labelSmall?.copyWith(
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
                                  validator: Validators.password,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? IconsaxPlusBold.eye_slash
                                          : IconsaxPlusBold.eye,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),

                                SizedBox(height: AppSpacing.xl.h),

                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return AppButton(
                                      label: 'Login to Account',
                                      isFullWidth: true,
                                      height: ButtonSize.large,
                                      isLoading: state.isLoading,
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          context.read<AuthBloc>().add(
                                            LoginRequested(
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          SizedBox(height: AppSpacing.xl.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: cs.outlineVariant,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: typography.labelSmall?.copyWith(
                                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: cs.outlineVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.xl.h),

                          // Social Logins
                          Row(
                            children: [
                              Expanded(
                                child: SocialLoginButton(
                                  label: 'Google',
                                  iconPath: AppAssets.googleIcon,
                                  onPressed: () => context.showSnackBar(
                                    'Google Login coming soon!',
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.md.w),
                              Expanded(
                                child: SocialLoginButton(
                                  label: 'Facebook',
                                  iconPath: AppAssets.facebookIcon,
                                  onPressed: () => context.showSnackBar(
                                    'Facebook Login coming soon!',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSpacing.xl.h),

                          // Footer Action
                          Center(
                            child: TextButton(
                              onPressed: () => context.push(AppRoutes.signup),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'New to the pitch? ',
                                  style: typography.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
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

                    SizedBox(height: AppSpacing.xxl.h),

                    // Legal/Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _legalLink(context, 'PRIVACY POLICY'),
                        SizedBox(width: AppSpacing.sm.w),
                        _legalLink(context, 'TERMS OF SERVICE'),
                        SizedBox(width: AppSpacing.sm.w),
                        _legalLink(context, 'SUPPORT'),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg.h),
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
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _legalLink(BuildContext context, String text) {
    return Text(
      text,
      style: context.textTheme.labelSmall?.copyWith(
        color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        fontSize: 10.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }
}
