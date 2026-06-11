import 'dart:async';
import 'dart:ui';
import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/auth/presentation/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  final ValueNotifier<int> _resendCountdown = ValueNotifier<int>(0);
  Timer? _countdownTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
    _countdownTimer?.cancel();
    _resendCountdown.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _resendCountdown.value = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown.value > 0) {
        _resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpString() {
    return _otpControllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(IconsaxPlusLinear.arrow_left, color: colors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 400.w,
              height: 400.h,
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
          SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                // Transitioned to OTP step → start the resend countdown
                if (state.isSuccess && state.forgotStep == ForgotStep.otp) {
                  if (_resendCountdown.value == 0 ||
                      _countdownTimer == null ||
                      !_countdownTimer!.isActive) {
                    _startCountdown();
                  }
                }
                // Password reset succeeded → toast + go to login
                if (state.isSuccess &&
                    state.forgotStep == ForgotStep.email &&
                    state.resetToken == null) {
                  showGlobalToast(
                    message: 'auth.password_reset_success'.tr(),
                    status: 'success',
                  );
                  context.go(AppRoutes.login);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      const HeaderBranding(),
                      SizedBox(height: 48.h),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconsaxPlusBold.refresh_circle,
                          color: colors.primary,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        'auth.forgot_password_title'.tr(),
                        style: typography.headlineMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'auth.forgot_desc'.tr(),
                        textAlign: TextAlign.center,
                        style: typography.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Dynamic view based on step
                      _buildStepContent(context, state),

                      SizedBox(height: 48.h),
                      TextButton.icon(
                        onPressed: () => context.go(AppRoutes.login),
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: Text(
                          'auth.back_to_login'.tr(),
                          style: typography.labelLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, AuthState state) {
    switch (state.forgotStep) {
      case ForgotStep.email:
        return _buildEmailStep(context, state);
      case ForgotStep.otp:
        return _buildOtpStep(context, state);
      case ForgotStep.newPassword:
        return _buildNewPasswordStep(context, state);
    }
  }

  Widget _buildEmailStep(BuildContext context, AuthState state) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            'auth.enter_email_to_reset'.tr(),
            textAlign: TextAlign.center,
            style: typography.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24.h),
          const AuthInputLabel(label: 'auth.email', isCompact: true),
          AppTextField(
            controller: _emailController,
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(IconsaxPlusBold.sms),
          ),
          SizedBox(height: 32.h),
          AppButton(
            label: 'auth.send_code'.tr(),
            isFullWidth: true,
            height: ButtonSize.large,
            isLoading: state.isLoading,
            onPressed: () {
              final email = _emailController.text.trim();
              if (email.isNotEmpty) {
                context.read<AuthCubit>().forgotPassword(email: email);
              } else {
                showGlobalToast(
                  message: 'auth.email_required'.tr(),
                  status: 'error',
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep(BuildContext context, AuthState state) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            'auth.enter_verification_code'.tr(),
            style: typography.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'auth.otp_sent_to'.tr(
              namedArgs: {'email': _emailController.text.trim()},
            ),
            textAlign: TextAlign.center,
            style: typography.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 32.h),
          Row(children: List.generate(6, (index) => _otpBox(index, context))),
          SizedBox(height: 40.h),
          AppButton(
            label: 'auth.verify_continue'.tr(),
            isFullWidth: true,
            height: ButtonSize.large,
            isLoading: state.isLoading,
            suffixIcon: const Icon(Icons.arrow_forward),
            onPressed: () {
              final otp = _getOtpString();
              if (otp.length == 6) {
                context.read<AuthCubit>().verifyOtp(
                  email: _emailController.text.trim(),
                  otp: otp,
                );
              } else {
                showGlobalToast(
                  message: 'Please enter the 6-digit code',
                  status: 'error',
                );
              }
            },
          ),
          SizedBox(height: 24.h),
          ValueListenableBuilder<int>(
            valueListenable: _resendCountdown,
            builder: (context, seconds, child) {
              return TextButton(
                onPressed: seconds == 0
                    ? () {
                        context.read<AuthCubit>().forgotPassword(
                          email: _emailController.text.trim(),
                        );
                        _startCountdown();
                      }
                    : null,
                child: Text(
                  seconds > 0
                      ? 'auth.resend_code'.tr(
                          namedArgs: {
                            'time': '00:${seconds.toString().padLeft(2, '0')}',
                          },
                        )
                      : 'auth.resend_available'.tr(),
                  style: typography.labelSmall?.copyWith(
                    color: seconds > 0
                        ? colors.onSurfaceVariant
                        : colors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep(BuildContext context, AuthState state) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'auth.set_new_password'.tr(),
            style: typography.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'auth.set_new_password_desc'.tr(),
            style: typography.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 32.h),
          const AuthInputLabel(
            label: 'auth.new_password_label',
            isCompact: true,
          ),
          AppTextField(
            controller: _passwordController,
            hint: '••••••••',
            obscureText: true,
            prefixIcon: const Icon(IconsaxPlusBold.lock),
          ),
          SizedBox(height: 24.h),
          const AuthInputLabel(
            label: 'auth.confirm_new_password_label',
            isCompact: true,
          ),
          AppTextField(
            controller: _confirmPasswordController,
            hint: '••••••••',
            obscureText: true,
            prefixIcon: const Icon(IconsaxPlusBold.lock),
          ),
          SizedBox(height: 40.h),
          AppButton(
            label: 'auth.reset_password_button'.tr(),
            isFullWidth: true,
            height: ButtonSize.large,
            isLoading: state.isLoading,
            onPressed: () {
              final newPass = _passwordController.text;
              final confirmPass = _confirmPasswordController.text;
              if (newPass.length < 6) {
                showGlobalToast(
                  message: 'auth.password_too_short'.tr(),
                  status: 'error',
                );
                return;
              }
              if (newPass != confirmPass) {
                showGlobalToast(
                  message: 'auth.passwords_do_not_match'.tr(),
                  status: 'error',
                );
                return;
              }

              context.read<AuthCubit>().resetPassword(
                email: _emailController.text.trim(),
                password: newPass,
              );
              // On success, cubit redirects via UI/toast and developer navigates from bloc listener
              // Wait, in my cubit I don't use GoRouter, I show toast. Let's do it on listener or manually here.
              // Wait, the bloc listener for success happens globally?
              // The cubit handles routing? No, the login_screen handles routing.
              // Let's add a BlocListener to navigate after state.resetToken becomes null on success.
            },
          ),
        ],
      ),
    );
  }

  Widget _otpBox(int index, BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (v) => _onOtpChanged(v, index),
            style: context.typography.headlineSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
      ),
    );
  }
}
