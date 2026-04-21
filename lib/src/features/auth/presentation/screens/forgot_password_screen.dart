import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

enum ResetMethod { email, sms }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ResetMethod _selectedMethod = ResetMethod.email;
  bool _codeSent = false;
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
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
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFFBCC7DE)),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                children: [
                   SizedBox(height: 20.h),
                   // Brand
                   Text(
                    'e7gzz',
                    style: tt.displaySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // Icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF171F33),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        IconsaxPlusBold.refresh_circle,
                        color: cs.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Text
                  Text(
                    'Forgot Password?',
                    style: tt.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 32.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No worries! Choose how you'd like to reset your stadium access.",
                    textAlign: TextAlign.center,
                    style: tt.bodyMedium?.copyWith(
                      color: const Color(0xFFBCC7DE),
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Method Cards
                  methodCard(
                    method: ResetMethod.email,
                    title: 'Via Email',
                    value: 'a***n@domain.com',
                    icon: IconsaxPlusBold.sms,
                    isSelected: _selectedMethod == ResetMethod.email,
                    onTap: () => setState(() => _selectedMethod = ResetMethod.email),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  methodCard(
                    method: ResetMethod.sms,
                    title: 'Via SMS',
                    value: '010 **** 5567',
                    icon: IconsaxPlusBold.messages_1,
                    isSelected: _selectedMethod == ResetMethod.sms,
                    onTap: () => setState(() => _selectedMethod = ResetMethod.sms),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Verification Section
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131B2E),
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Enter Verification Code',
                          style: tt.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "We've sent a 6-digit code to your ${_selectedMethod == ResetMethod.email ? 'email' : 'phone'}.",
                          textAlign: TextAlign.center,
                          style: tt.bodySmall?.copyWith(
                            color: const Color(0xFFBCC7DE).withValues(alpha: 0.7),
                          ),
                        ),
                        
                        SizedBox(height: 32.h),
                        
                        // OTP Inputs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) => otpBox(index)),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        AppButton(
                          label: 'Verify & Continue',
                          isFullWidth: true,
                          height: ButtonSize.large,
                          suffixIcon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Proceed to new password
                            _showNewPasswordSheet();
                          },
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        Text(
                          'Resend Code in 00:59',
                          style: tt.labelSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // Back to Login
                  TextButton.icon(
                    onPressed: () => context.go(AppRoutes.login),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: Text(
                      'Back to Login',
                      style: tt.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  Text(
                    'PITCH READY SECURITY',
                    style: tt.labelSmall?.copyWith(
                      color: const Color(0xFFBCC7DE).withValues(alpha: 0.2),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
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

  Widget methodCard({
    required ResetMethod method,
    required String title,
    required String value,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF171F33),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF4BE277).withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF4BE277).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF4BE277), size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFBCC7DE),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4BE277) : const Color(0xFF31394D),
                  width: 2,
                ),
              ),
              child: isSelected ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4BE277),
                    shape: BoxShape.circle,
                  ),
                ),
              ) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget otpBox(int index) {
    return Container(
      width: 45.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF31394D),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (v) => _onOtpChanged(v, index),
        style: context.theme.textTheme.headlineSmall?.copyWith(
          color: Colors.white,
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

  void _showNewPasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF131B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, MediaQuery.of(context).viewInsets.bottom + 48.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set New Password',
              style: context.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your new password must be different from previous passwords.',
              style: context.theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
            ),
            SizedBox(height: 32.h),
            
            const Text(
              'NEW PASSWORD',
              style: TextStyle(color: Color(0xFFBCC7DE), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            SizedBox(height: 8.h),
            const AppTextField(
              hint: '••••••••',
              obscureText: true,
              prefixIcon: Icon(IconsaxPlusBold.lock),
            ),
            
            SizedBox(height: 24.h),
            
            const Text(
              'CONFIRM NEW PASSWORD',
              style: TextStyle(color: Color(0xFFBCC7DE), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            SizedBox(height: 8.h),
            const AppTextField(
              hint: '••••••••',
              obscureText: true,
              prefixIcon: Icon(IconsaxPlusBold.lock),
            ),
            
            SizedBox(height: 40.h),
            
            AppButton(
              label: 'Reset Password',
              isFullWidth: true,
              height: ButtonSize.large,
              onPressed: () {
                Navigator.pop(context); // Close sheet
                context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
