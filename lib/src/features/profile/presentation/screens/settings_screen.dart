import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import '../widgets/profile_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: typography.headlineSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Preferences',
              style: typography.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDarkMode = context.isDarkMode;
                return ProfileTile(
                  title: 'App Theme',
                  subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
                  icon: isDarkMode ? IconsaxPlusBold.moon : IconsaxPlusBold.sun_1,
                  onTap: () => context.read<ThemeCubit>().setTheme(
                    isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'Language',
              subtitle: 'English (US)',
              icon: IconsaxPlusBold.global,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'Notifications',
              style: typography.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'Push Notifications',
              subtitle: 'Manage alerts and reminders',
              icon: IconsaxPlusBold.notification,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'Account & Privacy',
              style: typography.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'Change Password',
              subtitle: 'Update your security credentials',
              icon: IconsaxPlusBold.lock,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'Privacy Policy',
              subtitle: 'Read our terms and conditions',
              icon: IconsaxPlusBold.shield_tick,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'Delete Account',
              subtitle: 'Permanently remove your data',
              icon: IconsaxPlusBold.trash,
              isLogout: true,
              onTap: () {},
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
