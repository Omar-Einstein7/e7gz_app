import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

enum ResetMethod { email, sms }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ResetMethod _selectedMethod = ResetMethod.email;
  bool _codeSent = false;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
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
            child: SingleChildScrollView(
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
                    "auth.forgot_desc".tr(),
                    textAlign: TextAlign.center,
                    style: typography.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  _MethodCard(
                    method: ResetMethod.email,
                    title: 'auth.via_email'.tr(),
                    value: 'a***n@domain.com',
                    icon: IconsaxPlusBold.sms,
                    isSelected: _selectedMethod == ResetMethod.email,
                    onTap: () =>
                        setState(() => _selectedMethod = ResetMethod.email),
                  ),
                  SizedBox(height: 16.h),
                  _MethodCard(
                    method: ResetMethod.sms,
                    title: 'auth.via_sms'.tr(),
                    value: '010 **** 5567',
                    icon: IconsaxPlusBold.messages_1,
                    isSelected: _selectedMethod == ResetMethod.sms,
                    onTap: () =>
                        setState(() => _selectedMethod = ResetMethod.sms),
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.all(24.w),
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
                          'auth.sent_verification_code'.tr(
                            namedArgs: {
                              'method': _selectedMethod == ResetMethod.email
                                  ? 'auth.email'.tr()
                                  : 'auth.mobile_number'.tr(),
                            },
                          ),
                          textAlign: TextAlign.center,
                          style: typography.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => _otpBox(index, context),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        AppButton(
                          label: 'auth.verify_continue'.tr(),
                          isFullWidth: true,
                          height: ButtonSize.large,
                          suffixIcon: const Icon(Icons.arrow_forward),
                          onPressed: () => _showNewPasswordSheet(context),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'auth.resend_code'.tr(namedArgs: {'time': '00:59'}),
                          style: typography.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpBox(int index, BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 45.w,
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
    );
  }

  void _showNewPasswordSheet(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24.w,
          32.h,
          24.w,
          MediaQuery.of(context).viewInsets.bottom + 48.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'auth.set_new_password'.tr(),
              style: typography.headlineSmall?.copyWith(
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
            const AppTextField(
              hint: '••••••••',
              obscureText: true,
              prefixIcon: Icon(IconsaxPlusBold.lock),
            ),
            SizedBox(height: 24.h),
            const AuthInputLabel(
              label: 'auth.confirm_new_password_label',
              isCompact: true,
            ),
            const AppTextField(
              hint: '••••••••',
              obscureText: true,
              prefixIcon: Icon(IconsaxPlusBold.lock),
            ),
            SizedBox(height: 40.h),
            AppButton(
              label: 'auth.reset_password_button'.tr(),
              isFullWidth: true,
              height: ButtonSize.large,
              onPressed: () {
                Navigator.pop(context);
                context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final ResetMethod method;
  final String title;
  final String value;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.method,
    required this.title,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.primary, size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.titleMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: typography.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(IconsaxPlusBold.tick_circle, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
