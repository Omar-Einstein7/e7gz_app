import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class EmptyPitches extends StatelessWidget {
  final VoidCallback onAdd;
  const EmptyPitches({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stadium_outlined,
              color: colors.primary,
              size: 48,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'No Pitches Yet',
            style: tt.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Add your first pitch to get started',
            style: tt.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.xl.h),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Pitch'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
