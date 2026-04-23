
import 'package:e7gz/src/imports/imports.dart';

class HomeCategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const HomeCategoryChip({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF003915) : Colors.white,
            size: 20,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF003915) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
