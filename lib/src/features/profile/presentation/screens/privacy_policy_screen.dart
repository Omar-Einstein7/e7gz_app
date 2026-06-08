import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings.privacy_policy'.tr(),
          style: typography.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'privacy.introduction_title'.tr(),
              'privacy.introduction_content'.tr(),
            ),
            _buildSection(
              context,
              'privacy.data_collection_title'.tr(),
              'privacy.data_collection_content'.tr(),
            ),
            _buildSection(
              context,
              'privacy.data_usage_title'.tr(),
              'privacy.data_usage_content'.tr(),
            ),
            _buildSection(
              context,
              'privacy.security_title'.tr(),
              'privacy.security_content'.tr(),
            ),
            SizedBox(height: 48.h),
            Center(
              child: Text(
                'privacy.last_updated'.tr(namedArgs: {'date': 'October 2023'}),
                style: typography.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final colors = context.colors;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xl.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: typography.titleMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            content,
            style: typography.bodyMedium?.copyWith(
              color: colors.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
