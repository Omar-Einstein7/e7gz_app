import 'package:image_picker/image_picker.dart';
import 'package:e7gz/src/di/injection_container.dart';
import '../widgets/profile_header.dart';
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

  @override
  void initState() {
    super.initState();
    final user = context.read<SessionCubit>().state.user;
    _nameController = TextEditingController(text: user?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) {
            final user = state.user;
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    name: user?.name ?? '',
                    email: user?.email ?? '',
                    photoUrl: user?.photoUrl,
                    onImageTap: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null && context.mounted) {
                        try {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          await sl<AuthService>().updateProfile(
                            photoPath: pickedFile.path,
                          );

                          if (context.mounted) {
                            Navigator.pop(context); // Close loading dialog
                            context.showSuccessSnackBar(
                              'profile.photo_updated'.tr(),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            context.showErrorSnackBar('Failed to upload image');
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.xxl.h),
                  AuthInputLabel(label: 'auth.full_name'.tr(), isCompact: true),
                  AppTextField(
                    controller: _nameController,
                    hint: 'auth.full_name_hint'.tr(),
                    prefixIcon: const Icon(IconsaxPlusBold.profile),
                    validator: Validators.name,
                  ),
                  SizedBox(height: AppSpacing.xxl.h),

                  AppButton(
                    label: 'common.save_changes'.tr(),
                    isFullWidth: true,
                    height: ButtonSize.large,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          // Update name if changed
                          await sl<AuthService>().updateProfile(
                            name: _nameController.text,
                          );

                          // Handle password update if password is not empty
                          // (Note: Backend may need a specialized route for password update)

                          if (context.mounted) {
                            Navigator.pop(context); // Close loading dialog
                            context.showSuccessSnackBar(
                              'profile.success_update'.tr(),
                            );

                            context.pop();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            context.showErrorSnackBar(
                              'Failed to update profile',
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
