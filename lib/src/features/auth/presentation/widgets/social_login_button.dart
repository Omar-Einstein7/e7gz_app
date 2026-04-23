import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 22.w),
            SizedBox(width: 12.w),
            Text(
              label,
              style: typography.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
