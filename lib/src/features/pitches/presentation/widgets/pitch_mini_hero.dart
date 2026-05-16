import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PitchMiniHero extends StatelessWidget {
  final dynamic extraPitch;

  const PitchMiniHero({super.key, this.extraPitch});

  @override
  Widget build(BuildContext context) {
    final typography = context.textTheme;
    final pitch = extraPitch is Pitch ? extraPitch as Pitch : null;

    return Container(
      height: 180.h,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.md.h),
      decoration: BoxDecoration(
        borderRadius: AppRadius.bxxl.r,
        image: DecorationImage(
          image: NetworkImage(
            pitch?.imageUrl != null && pitch!.imageUrl.isNotEmpty
                ? pitch.imageUrl
                : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.bxxl.r,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PremiumBadge(),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  pitch?.name ?? 'Pitch Details',
                  style: typography.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                _LocationInfo(city: pitch?.location.city),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w, vertical: AppSpacing.xs.h),
      decoration: BoxDecoration(
        color: pc.accentGreen.withValues(alpha: 0.8),
        borderRadius: AppRadius.bsm.r,
      ),
      child: Text(
        'PREMIUM TURF',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LocationInfo extends StatelessWidget {
  final String? city;
  const _LocationInfo({this.city});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: cs.onSurfaceVariant,
          size: 14,
        ),
        SizedBox(width: AppSpacing.xs.w),
        Expanded(
          child: Text(
            city ?? '',
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 13.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
