import 'dart:ui';
import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e7gz/src/utils/validators.dart';
import '../widgets/widgets.dart';

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
                      const HeaderBranding(),
                      SizedBox(height: AppSpacing.xxl.h),
                      const _RoleSelectionHeader(),
                      SizedBox(height: AppSpacing.lg.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (prev, curr) =>
                            prev.selectedRole != curr.selectedRole,
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: RoleCard(
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
                                child: RoleCard(
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
                      Container(
                        padding: EdgeInsets.all(AppSpacing.xl.w),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow.withValues(
                            alpha: 0.4,
                          ),
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
                                AuthInputLabel(label: "auth.full_name".tr()),
                                AppTextField(
                                  controller: _nameController,
                                  hint: "Mohamed Ahmed",
                                  prefixIcon: const Icon(
                                    IconsaxPlusBold.profile,
                                  ),
                                  validator: Validators.name,
                                ),
                                SizedBox(height: AppSpacing.lg.h),
                                AuthInputLabel(label: "auth.email".tr()),
                                AppTextField(
                                  controller: _emailController,
                                  hint: "mohamed@example.com",
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(IconsaxPlusBold.sms),
                                  validator: Validators.email,
                                ),
                                SizedBox(height: AppSpacing.lg.h),
                                AuthInputLabel(
                                  label: "auth.mobile_number".tr(),
                                ),
                                AppTextField(
                                  controller: _phoneController,
                                  hint: "01X XXXX XXXX",
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: const Icon(IconsaxPlusBold.call),
                                  suffixIcon: const WalletReadyChip(),
                                  validator: Validators.phone,
                                ),
                                SizedBox(height: AppSpacing.lg.h),
                                AuthInputLabel(
                                  label: "auth.create_password".tr(),
                                ),
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
}

class _RoleSelectionHeader extends StatelessWidget {
  const _RoleSelectionHeader();
  @override
  Widget build(BuildContext context) {
    return Text(
      'auth.select_role'.tr().toUpperCase(),
      style: context.typography.labelSmall?.copyWith(
        color: context.colors.onSurfaceVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}
