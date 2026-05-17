import 'dart:ui';

import 'package:e7gz/src/imports/imports.dart';

class AmenityItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const AmenityItem({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 68.w,
          height: 68.w,
          decoration: BoxDecoration(
            color: const Color(0xFF171F33).withValues(alpha: 0.6),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4BE277).withValues(alpha: 0.05),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Center(
                child: Icon(icon, color: const Color(0xFF4BE277), size: 26.sp),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFBCC7DE),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
