import 'dart:ui';
import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import 'package:e7gz/src/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
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
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.isFailure) {
                    context.showErrorSnackBar(
                      state.errorMessage ?? 'Authentication failed',
                    );
                  }
                  if (state.isSuccess) {
                    context.showSuccessSnackBar('Login successful!');
                    final session = context.read<SessionCubit>().state;
                    final user = session.user;
                    if (user != null) {
                      if (user.isAdmin) {
                        context.go(AppRoutes.admin);
                      } else if (user.isOwner) {
                        context.go(AppRoutes.ownerDashboard);
                      } else {
                        context.go(AppRoutes.home);
                      }
                    } else {
                      // If user not available in session yet, fallback to home
                      context.go(AppRoutes.home);
                    }
                  }
                },
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
                          color: colors.surfaceContainerLow.withValues(alpha: 0.8),
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
                              'auth.log_in'.tr(),
                              style: typography.headlineSmall?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs.h),
                            Text(
                              'auth.log_in_subtitle'.tr(),
                              style: typography.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
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
                                  _inputLabel(
                                    context,
                                    'auth.email'.tr().toUpperCase(),
                                  ),
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
                                      _inputLabel(
                                        context,
                                        'auth.password'.tr().toUpperCase(),
                                      ),
                                      TextButton(
                                        onPressed: () => context.push(
                                          AppRoutes.forgotPassword,
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                        ),
                                        child: Text(
                                          'auth.forgot_password'.tr(),
                                          style: typography.labelSmall
                                              ?.copyWith(
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
                                    prefixIcon: const Icon(
                                      IconsaxPlusBold.lock,
                                    ),
                                    validator: Validators.password,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? IconsaxPlusBold.eye_slash
                                            : IconsaxPlusBold.eye,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: AppSpacing.xl.h),

                                  BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      return AppButton(
                                        label: 'auth.login_button'.tr(),
                                        isFullWidth: true,
                                        height: ButtonSize.large,
                                        isLoading: state.isLoading,
                                        onPressed: () {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            context.read<AuthCubit>().login(
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                                  _passwordController.text,
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
                                  child: Divider(color: colors.outlineVariant),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md.w,
                                  ),
                                  child: Text(
                                    'auth.or_continue_with'.tr().toUpperCase(),
                                    style: typography.labelSmall?.copyWith(
                                      color: colors.onSurfaceVariant.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: colors.outlineVariant),
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
                                    text: 'auth.dont_have_account'.tr(),
                                    style: typography.bodySmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'auth.sign_up'.tr(),
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
          color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
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
        color: context.colors.onSurfaceVariant.withValues(alpha: 0.4),
        fontSize: 10.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }
}

