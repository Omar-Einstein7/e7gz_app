import 'dart:ui';
import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e7gz/src/utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

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
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
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
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.isFailure) {
                  context.showErrorSnackBar(
                    state.errorMessage ?? 'Signup failed',
                  );
                }
                if (state.isSuccess) {
                  context.showSuccessSnackBar('Account created successfully!');
                  context.go(AppRoutes.login);
                }
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Header
                      _HeaderBranding(typography: typography, colors: colors),

                      SizedBox(height: AppSpacing.xxl.h),

                      // Role Selection
                      _RoleSelectionHeader(typography: typography, colors: colors),

                      SizedBox(height: AppSpacing.lg.h),

                      // Role Cards — reactive via BlocBuilder
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (prev, curr) =>
                            prev.selectedRole != curr.selectedRole,
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: _RoleCard(
                                  role: 'player',
                                  title: 'auth.player'.tr(),
                                  subtitle: 'auth.player_desc'.tr(),
                                  icon: Icons.sports_soccer,
                                  isSelected: state.selectedRole == 'player',
                                  onTap: () => context
                                      .read<AuthCubit>()
                                      .selectRole('player'),
                                ),
                              ),
                              SizedBox(width: AppSpacing.md.w),
                              Expanded(
                                child: _RoleCard(
                                  role: 'owner',
                                  title: 'auth.owner'.tr(),
                                  subtitle: 'auth.owner_desc'.tr(),
                                  icon: Icons.stadium,
                                  isSelected: state.selectedRole == 'owner',
                                  onTap: () => context
                                      .read<AuthCubit>()
                                      .selectRole('owner'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: AppSpacing.xxl.h),

                      // Form Section
                      Container(
                        padding: EdgeInsets.all(AppSpacing.xl.w),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow.withValues(alpha: 0.4),
                          borderRadius: AppRadius.bxxl.r,
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: ClipRRect(
                          borderRadius: AppRadius.bxxl.r,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _inputLabel(context, "auth.full_name".tr()),
                                AppTextField(
                                  controller: _nameController,
                                  hint: "Mohamed Ahmed",
                                  prefixIcon: const Icon(
                                    IconsaxPlusBold.profile,
                                  ),
                                  validator: Validators.name,
                                ),
                                SizedBox(height: AppSpacing.lg.h),

                                _inputLabel(context, "auth.email".tr()),
                                AppTextField(
                                  controller: _emailController,
                                  hint: "mohamed@example.com",
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(IconsaxPlusBold.sms),
                                  validator: Validators.email,
                                ),
                                SizedBox(height: AppSpacing.lg.h),

                                _inputLabel(context, "auth.mobile_number".tr()),
                                AppTextField(
                                  controller: _phoneController,
                                  hint: "01X XXXX XXXX",
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: const Icon(IconsaxPlusBold.call),
                                  suffixIcon: _walletReadyChip(context),
                                  validator: Validators.phone,
                                ),
                                SizedBox(height: AppSpacing.lg.h),

                                _inputLabel(
                                  context,
                                  "auth.create_password".tr(),
                                ),

                                // Password field — reactive to obscurePassword
                                BlocBuilder<AuthCubit, AuthState>(
                                  buildWhen: (prev, curr) =>
                                      prev.obscurePassword !=
                                      curr.obscurePassword,
                                  builder: (context, state) {
                                    return AppTextField(
                                      controller: _passwordController,
                                      hint: "••••••••",
                                      obscureText: state.obscurePassword,
                                      prefixIcon: const Icon(
                                        IconsaxPlusBold.lock,
                                      ),
                                      validator: Validators.password,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          state.obscurePassword
                                              ? IconsaxPlusBold.eye_slash
                                              : IconsaxPlusBold.eye,
                                          size: 20,
                                        ),
                                        onPressed: () => context
                                            .read<AuthCubit>()
                                            .togglePasswordVisibility(),
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(height: AppSpacing.xl.h),

                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    return AppButton(
                                      label: 'auth.create_account_button'.tr(),
                                      isFullWidth: true,
                                      height: ButtonSize.large,
                                      isLoading: state.isLoading,
                                      suffixIcon: const Icon(
                                        Icons.arrow_forward,
                                      ),
                                      onPressed: state.selectedRole == null
                                          ? null
                                          : () {
                                              if (_formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                context
                                                    .read<AuthCubit>()
                                                    .signUp(
                                                      name: _nameController.text
                                                          .trim(),
                                                      email: _emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          _passwordController
                                                              .text,
                                                      phone:
                                                          _phoneController.text,
                                                    );
                                              }
                                            },
                                    );
                                  },
                                ),

                                SizedBox(height: AppSpacing.lg.h),

                                Center(
                                  child: TextButton(
                                    onPressed: () =>
                                        context.go(AppRoutes.login),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "auth.already_have_account".tr(),
                                        style: typography.bodyMedium?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "auth.sign_in".tr(),
                                            style: TextStyle(
                                              color: colors.primary,
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

                      SizedBox(height: AppSpacing.xl.h),

                      // Footer
                      Text(
                        'auth.agree_terms'.tr(),
                        textAlign: TextAlign.center,
                        style: typography.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xl.h),
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
      padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
      child: Text(
        text,
        style: context.typography.labelMedium?.copyWith(
          color: context.colors.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _walletReadyChip(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
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
            style: context.typography.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private extracted widgets ─────────────────────────────────────────────

class _HeaderBranding extends StatelessWidget {
  const _HeaderBranding({required this.typography, required this.colors});
  final TextTheme typography;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'e7gzz',
          style: typography.displaySmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'auth.join_arena'.tr(),
          style: typography.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'auth.join_arena_subtitle'.tr(),
          textAlign: TextAlign.center,
          style: typography.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _RoleSelectionHeader extends StatelessWidget {
  const _RoleSelectionHeader({required this.typography, required this.colors});
  final TextTheme typography;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      'auth.select_role'.tr().toUpperCase(),
      style: typography.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String role;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: AppRadius.blg.r,
          border: Border.all(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
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
                    color: colors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: colors.primary, size: 28),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  title,
                  style: typography.titleLarge?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  subtitle,
                  style: typography.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
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
                    color: isSelected ? colors.primary : colors.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

