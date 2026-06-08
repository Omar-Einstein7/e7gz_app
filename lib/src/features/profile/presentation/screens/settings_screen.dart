import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import 'package:e7gz/src/di/injection_container.dart';
import 'package:e7gz/src/imports/imports.dart';
import '../widgets/profile_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = sl<SharedPreferences>();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool('push_notifications', value);
    setState(() {
      _pushNotifications = value;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'notifications.enabled'.tr()
                : 'notifications.disabled'.tr(),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final currentLocale = context.locale;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceContainerHigh,
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
                    color: colors.onSurface,
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

  void _showChangePasswordDialog() {
    final colors = context.colors;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceContainerHigh,
        title: Text('settings.change_password'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: 'auth.current_password'.tr(),
              hint: '••••••••',
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.md.h),
            AppTextField(
              label: 'auth.new_password'.tr(),
              hint: '••••••••',
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.md.h),
            AppTextField(
              label: 'auth.confirm_password'.tr(),
              hint: '••••••••',
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('shared.cancel'.tr()),
          ),
          AppButton(
            label: 'shared.save'.tr(),
            width: ButtonSize.small,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('settings.password_updated'.tr())),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
            color: colors.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'settings.title'.tr(),
          style: typography.headlineSmall?.copyWith(
            color: colors.onSurface,
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
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDarkMode = context.isDarkMode;
                return ProfileTile(
                  title: 'settings.app_theme'.tr(),
                  subtitle: isDarkMode
                      ? 'settings.theme_dark'.tr()
                      : 'settings.theme_light'.tr(),
                  icon: isDarkMode
                      ? IconsaxPlusBold.moon
                      : IconsaxPlusBold.sun_1,
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
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.push_notifications'.tr(),
              subtitle: 'settings.push_desc'.tr(),
              icon: IconsaxPlusBold.notification,
              trailing: Switch.adaptive(
                value: _pushNotifications,
                activeColor: colors.primary,
                onChanged: _toggleNotifications,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'settings.account_privacy'.tr(),
              style: typography.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.change_password'.tr(),
              subtitle: 'settings.change_password_desc'.tr(),
              icon: IconsaxPlusBold.lock,
              onTap: _showChangePasswordDialog,
            ),
            SizedBox(height: AppSpacing.md.h),
            ProfileTile(
              title: 'settings.privacy_policy'.tr(),
              subtitle: 'settings.privacy_desc'.tr(),
              icon: IconsaxPlusBold.shield_tick,
              onTap: () => context.push(AppRoutes.privacyPolicy),
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
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.05)
              : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? Border.all(color: colors.primary, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.onSurface,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                IconsaxPlusBold.tick_circle,
                color: colors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
