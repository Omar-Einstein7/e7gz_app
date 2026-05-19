import 'package:e7gz/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class WalletReadyChip extends StatelessWidget {
  const WalletReadyChip({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEA4335),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Wallet Ready',
            style: context.typography.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
