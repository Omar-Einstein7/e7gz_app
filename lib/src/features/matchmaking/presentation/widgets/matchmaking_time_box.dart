import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class MatchmakingTimeBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  const MatchmakingTimeBox({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          const Icon(IconsaxPlusLinear.clock, color: Colors.white24, size: 20),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.white24),
          ),
        ],
      ),
    );
  }
}
