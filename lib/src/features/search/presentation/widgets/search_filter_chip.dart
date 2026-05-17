import 'package:e7gz/src/imports/imports.dart';

class SearchFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback? onTap;

  const SearchFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surfaceContainerHigh,
          borderRadius: AppRadius.bfull.r,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                size: 14,
              ),
              SizedBox(width: AppSpacing.xs.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
