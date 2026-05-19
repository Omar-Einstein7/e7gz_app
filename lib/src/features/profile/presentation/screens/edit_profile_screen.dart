import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e7gz/src/utils/validators.dart';
import 'package:e7gz/src/features/auth/presentation/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final user = context.read<SessionCubit>().state.user;
    _nameController = TextEditingController(text: user?.name);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'profile.edit_profile'.tr(),
          style: typography.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthInputLabel(label: 'auth.full_name', isCompact: true),
              AppTextField(
                controller: _nameController,
                hint: 'auth.full_name_hint'.tr(),
                prefixIcon: const Icon(IconsaxPlusBold.profile),
                validator: Validators.name,
              ),
              SizedBox(height: AppSpacing.xl.h),
              const Divider(),
              SizedBox(height: AppSpacing.xl.h),
              Text(
                'profile.change_password'.tr(),
                style: typography.titleMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              const AuthInputLabel(label: 'auth.new_password', isCompact: true),
              AppTextField(
                controller: _passwordController,
                hint: '••••••••',
                obscureText: true,
                prefixIcon: const Icon(IconsaxPlusBold.lock),
              ),
              SizedBox(height: AppSpacing.lg.h),
              const AuthInputLabel(
                label: 'auth.confirm_password',
                isCompact: true,
              ),
              AppTextField(
                controller: _confirmPasswordController,
                hint: '••••••••',
                obscureText: true,
                prefixIcon: const Icon(IconsaxPlusBold.lock),
                validator: (v) {
                  if (_passwordController.text.isNotEmpty &&
                      v != _passwordController.text) {
                    return 'auth.passwords_do_not_match'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.xxl.h),
              AppButton(
                label: 'common.save_changes'.tr(),
                isFullWidth: true,
                height: ButtonSize.large,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Logic to update name and password
                    context.showSuccessSnackBar('Profile updated successfully');
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
