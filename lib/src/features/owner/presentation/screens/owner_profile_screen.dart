import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/profile_action_item.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import 'package:image_picker/image_picker.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  Uint8List? _localPhotoBytes;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;

    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        final user = sessionState.user;
        return ListView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          children: [
            Text(
              'Profile',
              style: tt.headlineMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppRadius.blg.r,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null && context.mounted) {
                        final bytes = await image.readAsBytes();
                        setState(() => _localPhotoBytes = bytes);
                        if (!context.mounted) return;
                        context.read<AuthCubit>().updateProfile(
                          photoPath: image.path,
                        );
                      }
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colors.primary,
                                    colors.primary.withValues(alpha: 0.7),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: authState.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: colors.onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : _localPhotoBytes != null
                                    ? Image.memory(
                                        _localPhotoBytes!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  IconsaxPlusBold.user,
                                                  color: colors.onPrimary,
                                                  size: 36,
                                                ),
                                      )
                                    : (user?.photoUrl != null &&
                                          user!.photoUrl!.isNotEmpty)
                                    ? AppCachedImage(
                                        imageUrl: user.photoUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: Center(
                                          child: CircularProgressIndicator(
                                            color: colors.onPrimary,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        errorWidget: ColoredBox(
                                          color: colors.surfaceContainerHighest,
                                          child: Icon(
                                            IconsaxPlusBold.user,
                                            color: colors.onPrimary,
                                            size: 36,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        IconsaxPlusBold.user,
                                        color: colors.onPrimary,
                                        size: 36,
                                      ),
                              ),
                            ),
                            if (!authState.isLoading)
                              Container(
                                padding: EdgeInsets.all(AppSpacing.xxs.w),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: colors.onPrimary,
                                  size: 14,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Text(
                    user?.name ?? 'Pitch Owner',
                    style: tt.titleLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md.w,
                      vertical: AppSpacing.xs.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: AppRadius.bxxl.r,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      user?.role.toUpperCase() ?? 'OWNER',
                      style: tt.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileActionItem(
              icon: IconsaxPlusLinear.add_circle,
              label: 'Add New Pitch',
              onTap: () => context.push(AppRoutes.addPitch),
            ),
            ProfileActionItem(
              icon: IconsaxPlusLinear.notification,
              label: 'Notifications',
              onTap: () => context.push(AppRoutes.notifications),
            ),

            // Theme Toggle
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark =
                    mode == ThemeMode.dark ||
                    (mode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark);
                return ProfileActionItem(
                  icon: isDark
                      ? IconsaxPlusLinear.sun_1
                      : IconsaxPlusLinear.moon,
                  label: isDark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  onTap: () => context.read<ThemeCubit>().setTheme(
                    isDark ? ThemeMode.light : ThemeMode.dark,
                  ),
                );
              },
            ),

            ProfileActionItem(
              icon: IconsaxPlusLinear.logout,
              label: 'Log Out',
              isDestructive: true,
              onTap: () => context.read<SessionCubit>().logout(),
            ),
            SizedBox(height: 100.h),
          ],
        );
      },
    );
  }
}
