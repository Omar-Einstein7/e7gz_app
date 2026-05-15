import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

class SearchResultCard extends StatelessWidget {
  final Pitch pitch;
  final VoidCallback onTap;

  const SearchResultCard({super.key, required this.pitch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF131B2E) : theme.colorScheme.surfaceContainerLow;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final subtitleColor = isDark ? const Color(0xFFBCC7DE) : theme.colorScheme.onSurfaceVariant;
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.2) : theme.colorScheme.shadow.withValues(alpha: 0.05);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40.r),
                  ),
                  child: AppCachedImage(
                    imageUrl: pitch.imageUrl,
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1326).withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      IconsaxPlusLinear.heart,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF4BE277) : theme.colorScheme.primary,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'AVAILABLE TODAY',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF003915) : theme.colorScheme.onPrimary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pitch.name,
                              style: typography.titleLarge?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: subtitleColor,
                                  size: 14,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    '${pitch.location.city} • 1.2 km',
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 12.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF171F33) : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: isDark ? const Color(0xFF4BE277) : theme.colorScheme.primary,
                              size: 14,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              pitch.rating.toString(),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STARTING FROM',
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: pitch.pricePerHour.toInt().toString(),
                              style: typography.headlineSmall?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(
                                  text: ' EGP/HR',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF4BE277) : theme.colorScheme.primary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppButton(
                        label: 'View Slots',
                        onPressed: onTap,
                        height: ButtonSize.small,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
