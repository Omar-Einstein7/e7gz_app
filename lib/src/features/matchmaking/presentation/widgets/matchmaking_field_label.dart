import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/imports.dart';

class MatchmakingFieldLabel extends StatelessWidget {
  final String label;
  const MatchmakingFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFFBCC7DE),
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
