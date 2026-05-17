import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../widgets/profile_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageBottomSheet(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;
    final currentLocale = context.locale;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings.choose_language'.tr(),
                  style: typography.titleLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                _LanguageOption(
                  title: 'English (US)',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 12.h),
                _LanguageOption(
                  title: 'العربية (Arabic)',
                  isSelected: currentLocale.languageCode == 'ar',
                  onTap: () {
                    context.setLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, 
            color: cs.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'settings.title'.tr(),
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
              'settings.app_preferences'.tr(),
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
                  title: 'settings.app_theme'.tr(),
                  subtitle: isDarkMode ? 'settings.theme_dark'.tr() : 'settings.theme_light'.tr(),
                  icon: isDarkMode ? IconsaxPlusBold.moon : IconsaxPlusBold.sun_1,
                  onTap: () => context.read<ThemeCubit>().setTheme(
                    isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.language'.tr(),
              subtitle: 'settings.lang_name'.tr(),
              icon: IconsaxPlusBold.global,
              onTap: () => _showLanguageBottomSheet(context),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'settings.notifications'.tr(),
              style: typography.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.push_notifications'.tr(),
              subtitle: 'settings.push_desc'.tr(),
              icon: IconsaxPlusBold.notification,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'settings.account_privacy'.tr(),
              style: typography.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.change_password'.tr(),
              subtitle: 'settings.change_password_desc'.tr(),
              icon: IconsaxPlusBold.lock,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.privacy_policy'.tr(),
              subtitle: 'settings.privacy_desc'.tr(),
              icon: IconsaxPlusBold.shield_tick,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.delete_account'.tr(),
              subtitle: 'settings.delete_account_desc'.tr(),
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

class _LanguageOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withOpacity(0.05) : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected ? Border.all(color: cs.primary, width: 2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? cs.primary : cs.onSurface,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                IconsaxPlusBold.tick_circle,
                color: cs.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
