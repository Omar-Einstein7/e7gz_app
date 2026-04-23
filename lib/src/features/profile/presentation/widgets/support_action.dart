import 'package:e7gz/src/imports/imports.dart';
class SupportAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const SupportAction({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
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
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
