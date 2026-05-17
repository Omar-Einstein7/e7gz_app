import 'dart:ui';
import 'package:e7gz/src/features/auth/presentation/providers/auth_bloc.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

import 'package:e7gz/src/utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  
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
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Scaffold(
      backgroundColor: cs.background,
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
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.isFailure) {
                  context.showErrorSnackBar(state.errorMessage ?? 'Signup failed');
                }
                if (state.isSuccess) {
                  context.showSuccessSnackBar('Account created successfully!');
                  context.go(AppRoutes.login);
                }
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg.w),
              child: Column(
                children: [
                  // Header
                  headerBranding(typography, cs),
                  
                  SizedBox(height: AppSpacing.xxl.h),
                  
                  // Role Selection
                  roleSelectionHeader(typography, cs),
                  
                  SizedBox(height: AppSpacing.lg.h),
                  
                  Row(
                    children: [
                      Expanded(
                        child: roleCard(
                          role: 'player',
                          title: 'Player',
                          subtitle: 'Book pitches, find teammates, and join matches.',
                          icon: Icons.sports_soccer,
                          isSelected: _selectedRole == 'player',
                          onTap: () => setState(() => _selectedRole = 'player'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: roleCard(
                          role: 'owner',
                          title: 'Pitch Owner',
                          subtitle: 'List your stadium, manage bookings, and grow business.',
                          icon: Icons.stadium,
                          isSelected: _selectedRole == 'owner',
                          onTap: () => setState(() => _selectedRole = 'owner'),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSpacing.xxl.h),
                  
                  // Form Section
                  Container(
                    padding: EdgeInsets.all(AppSpacing.xl.w),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow.withValues(alpha: 0.4),
                      borderRadius: AppRadius.bxxl.r,
                      border: Border.all(
                        color: cs.outlineVariant,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.bxxl.r,
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
                                validator: Validators.name,
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              
                              inputLabel("Email Address"),
                              AppTextField(
                                controller: _emailController,
                                hint: "mohamed@example.com",
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(IconsaxPlusBold.sms),
                                validator: Validators.email,
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              
                              inputLabel("Mobile Number"),
                              AppTextField(
                                controller: _phoneController,
                                hint: "01X XXXX XXXX",
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(IconsaxPlusBold.call),
                                suffixIcon: walletReadyChip(),
                                validator: Validators.phone,
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              
                              inputLabel("Create Password"),
                              AppTextField(
                                controller: _passwordController,
                                hint: "••••••••",
                                obscureText: _obscurePassword,
                                prefixIcon: const Icon(IconsaxPlusBold.lock),
                                validator: Validators.password,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? IconsaxPlusBold.eye_slash : IconsaxPlusBold.eye,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              
                              SizedBox(height: AppSpacing.xl.h),
                              
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return AppButton(
                                    label: 'Create Account',
                                    isFullWidth: true,
                                    height: ButtonSize.large,
                                    isLoading: state.isLoading,
                                    suffixIcon: const Icon(Icons.arrow_forward),
                                    onPressed: _selectedRole == null ? null : () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        context.read<AuthBloc>().add(
                                        SignUpRequested(
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                          role: _selectedRole ?? 'player',
                                          phone: _phoneController.text,
                                        ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              
                              SizedBox(height: AppSpacing.lg.h),
                              
                              Center(
                                child: TextButton(
                                  onPressed: () => context.go(AppRoutes.login),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account? ",
                                      style: typography.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
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
                  
                  SizedBox(height: AppSpacing.xl.h),
                  
                  // Footer
                  Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy. Experience the game, managed professionally.',
                    textAlign: TextAlign.center,
                    style: typography.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.xl.h),
                ],
              ),
            ),
          )
      )],
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
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'Join the Arena',
          style: tt.headlineSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'Choose your path and start your sports journey in Egypt.',
          textAlign: TextAlign.center,
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget roleSelectionHeader(TextTheme tt, ColorScheme cs) {
    return Text(
      'SELECT YOUR ROLE',
      style: tt.labelSmall?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }

  Widget roleCard({
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: AppRadius.blg.r,
          border: Border.all(
            color: isSelected ? cs.primary.withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.1),
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
                    color: cs.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: cs.primary,
                    size: 28,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  title,
                  style: typography.titleLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  subtitle,
                  style: typography.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
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
                    color: isSelected ? cs.primary : cs.outline,
                    width: 2,
                  ),
                ),
                child: isSelected ? Center(
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: cs.primary,
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
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget walletReadyChip() {
    final cs = context.colorScheme;
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
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
            style: context.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
