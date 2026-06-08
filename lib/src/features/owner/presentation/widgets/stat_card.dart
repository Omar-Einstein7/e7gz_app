import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool accent;
  const StatCard(
    this.label,
    this.value,
    this.unit, {
    super.key,
    this.accent = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.blg.r,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            unit.isNotEmpty ? '$value $unit' : value,
            style: tt.headlineSmall?.copyWith(
              color: accent ? colors.primary : colors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
