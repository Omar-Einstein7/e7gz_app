import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

class SearchResultCard extends StatelessWidget {
  final Pitch pitch;
  final VoidCallback onTap;

  const SearchResultCard({super.key, required this.pitch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.lg.h),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.bxxl.r,
          boxShadow: AppShadows.card,

        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                  child: Hero(
                    tag: 'pitch_image_${pitch.id}',
                    child: AppCachedImage(
                      imageUrl: pitch.imageUrl,
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
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
                  left: AppSpacing.lg.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md.w,
                      vertical: AppSpacing.sm.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.md.r),
                      ),
                    ),
                    child: Text(
                      'AVAILABLE TODAY',
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
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
                                color: cs.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: cs.onSurfaceVariant,
                                  size: 14,
                                ),
                                SizedBox(width: AppSpacing.xs.w),
                                Expanded(
                                  child: Text(
                                    '${pitch.location.city} • 1.2 km',
                                    style: TextStyle(
                                      color: cs.onSurfaceVariant,
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
                          horizontal: AppSpacing.sm.w,
                          vertical: AppSpacing.xs.h,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceVariant,
                          borderRadius: AppRadius.bsm.r,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: cs.primary,
                              size: 14,
                            ),
                            SizedBox(width: AppSpacing.xs.w),
                            Text(
                              pitch.rating.toString(),
                              style: TextStyle(
                                color: cs.onSurface,
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
                              color: cs.onSurfaceVariant,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: pitch.pricePerHour.toInt().toString(),
                              style: typography.headlineSmall?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(
                                  text: ' EGP/HR',
                                  style: TextStyle(
                                    color: cs.primary,
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
