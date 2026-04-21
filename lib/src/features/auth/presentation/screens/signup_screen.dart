import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

enum AppRole { player, owner }

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  AppRole _selectedRole = AppRole.player;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
            top: -50,
            right: -50,
            child: Container(
              width: 500.w,
              height: 500.h,
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

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Header
                  headerBranding(tt, cs),
                  
                  SizedBox(height: 40.h),
                  
                  // Role Selection
                  roleSelectionHeader(tt),
                  
                  SizedBox(height: 24.h),
                  
                  Row(
                    children: [
                      Expanded(
                        child: roleCard(
                          role: AppRole.player,
                          title: 'Player',
                          subtitle: 'Book pitches, find teammates, and join matches.',
                          icon: Icons.sports_soccer,
                          isSelected: _selectedRole == AppRole.player,
                          onTap: () => setState(() => _selectedRole = AppRole.player),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: roleCard(
                          role: AppRole.owner,
                          title: 'Pitch Owner',
                          subtitle: 'List your stadium, manage bookings, and grow business.',
                          icon: Icons.stadium,
                          isSelected: _selectedRole == AppRole.owner,
                          onTap: () => setState(() => _selectedRole = AppRole.owner),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Form Section
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3449).withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              inputLabel("Full Name"),
                              AppTextField(
                                controller: _nameController,
                                hint: "Mohamed Ahmed",
                                prefixIcon: const Icon(IconsaxPlusBold.profile),
                              ),
                              SizedBox(height: 24.h),
                              
                              inputLabel("Email Address"),
                              AppTextField(
                                controller: _emailController,
                                hint: "mohamed@example.com",
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(IconsaxPlusBold.sms),
                              ),
                              SizedBox(height: 24.h),
                              
                              inputLabel("Mobile Number"),
                              AppTextField(
                                controller: _phoneController,
                                hint: "01X XXXX XXXX",
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(IconsaxPlusBold.call),
                                suffixIcon: walletReadyChip(),
                              ),
                              SizedBox(height: 24.h),
                              
                              inputLabel("Create Password"),
                              AppTextField(
                                controller: _passwordController,
                                hint: "••••••••",
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
                                label: 'Create Account',
                                isFullWidth: true,
                                height: ButtonSize.large,
                                suffixIcon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // Handle signup
                                  }
                                },
                              ),
                              
                              SizedBox(height: 24.h),
                              
                              Center(
                                child: TextButton(
                                  onPressed: () => context.go(AppRoutes.login),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account? ",
                                      style: tt.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE)),
                                      children: [
                                        TextSpan(
                                          text: "Sign in",
                                          style: TextStyle(
                                            color: cs.primary,
                                            fontWeight: FontWeight.bold,
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
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Footer
                  Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy. Experience the game, managed professionally.',
                    textAlign: TextAlign.center,
                    style: tt.bodySmall?.copyWith(
                      color: const Color(0xFFBCC7DE).withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerBranding(TextTheme tt, ColorScheme cs) {
    return Column(
      children: [
        Text(
          'e7gzz',
          style: tt.displaySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Join the Arena',
          style: tt.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Choose your path and start your sports journey in Egypt.',
          textAlign: TextAlign.center,
          style: tt.bodyMedium?.copyWith(
            color: const Color(0xFFBCC7DE),
          ),
        ),
      ],
    );
  }

  Widget roleSelectionHeader(TextTheme tt) {
    return Text(
      'SELECT YOUR ROLE',
      style: tt.labelSmall?.copyWith(
        color: const Color(0xFFBCC7DE),
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }

  Widget roleCard({
    required AppRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF171F33),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF4BE277).withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF4BE277).withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ] : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: (role == AppRole.player ? const Color(0xFF4BE277) : const Color(0xFF22C55E)).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: role == AppRole.player ? const Color(0xFF4BE277) : const Color(0xFF22C55E),
                    size: 28,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFBCC7DE),
                    height: 1.4,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4BE277) : const Color(0xFF3D4A3D),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget inputLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
      child: Text(
        text,
        style: context.theme.textTheme.labelMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget walletReadyChip() {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF222A3D),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEA4335),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Wallet Ready',
            style: context.theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFBCCBB9),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
