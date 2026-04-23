import 'package:e7gz/src/imports/imports.dart';
class AmenityItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const AmenityItem({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: const BoxDecoration(
            color: Color(0xFF171F33),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF4BE277), size: 24),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFBCC7DE),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
