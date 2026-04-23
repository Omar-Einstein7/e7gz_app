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
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4BE277) : const Color(0xFF171F33),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? const Color(0xFF003915) : Colors.white,
                size: 14,
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF003915) : Colors.white,
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
