
import 'package:e7gz/src/imports/imports.dart';

class BrandHeader extends StatelessWidget {
  final double? fontSize;
  
  const BrandHeader({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      children: [
        Text(
          'e7gzz',
          style: typography.displayLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
            fontSize: fontSize ?? 48.sp,
            letterSpacing: -3,
          ),
        ),
        Text(
          'THE STADIUM IS CALLING',
          style: typography.labelSmall?.copyWith(
            color: const Color(0xFFBCC7DE).withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}
