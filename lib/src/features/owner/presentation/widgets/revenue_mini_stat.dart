import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class RevenueMiniStat extends StatelessWidget {
  final String label;
  final String value;
  const RevenueMiniStat(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontSize: 10.sp,
          ),
        ),
        SizedBox(height: AppSpacing.xxs.h),
        Text(
          value,
          style: tt.titleSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
