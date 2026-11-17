import 'package:e7gz/src/features/home/presentation/widgets/widgets.dart';

import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';

class FeaturedPitchesList extends StatelessWidget {
  const FeaturedPitchesList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return SizedBox(
      height: 300.h,
      child: BlocBuilder<PitchesCubit, PitchesState>(
        builder: (context, state) {
          if (state.status == PitchesStatus.loading && state.pitches.isEmpty) {
            return HomeSkeleton.featured();
          }

          if (state.status == PitchesStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitches',
                style: context.typography.bodyMedium?.copyWith(
                  color: context.colors.error,
                ),
              ),
            );
          }

          final pitches = state.pitches;
          if (pitches.isEmpty) {
            return Center(
              child: Text(
                'No pitches available',
                style: context.typography.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: pitches.length > 5
                ? 5
                : pitches.length, // Show up to 5 featured
            itemBuilder: (context, index) {
              final pitch = pitches[index];
              return GestureDetector(
                onTap: () => context.push(
                  AppRoutes.pitchDetails.replaceFirst(':id', pitch.id),
                  extra: {'pitch': pitch, 'heroTag': 'featured_${pitch.id}'},
                ),
                child: Container(
                  width: 320.w,
                  margin: EdgeInsets.only(right: 20.w),
                  child: Stack(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                        child: Hero(
                          tag: 'featured_${pitch.id}',
                          child: AppCachedImage(
                            imageUrl: pitch.imageUrl.isNotEmpty
                                ? pitch.imageUrl
                                : 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),

                      // Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              colors.shadow.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                      // Tags & Info
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.pitchTheme.accentGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Text(
                                'ELITE VENUE',
                                style: typography.labelSmall?.copyWith(
                                  color: context.pitchTheme.accentGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pitch.name,
                                        style: typography.headlineSmall
                                            ?.copyWith(
                                              color: colors.onSurface,
                                              fontWeight: FontWeight.w900,
                                              height: 1.1,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: colors.onSurfaceVariant,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              pitch
                                                  .location
                                                  .city,
                                              style: typography.bodySmall?.copyWith(
                                                color: colors.onSurfaceVariant,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      pitch.pricePerHour.toInt().toString(),
                                      style: typography.headlineSmall?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'EGP',
                                      style: typography.labelSmall?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'per hour',
                                      style: typography.labelSmall?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
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
            },
          );
        },
      ),
    );
  }
}
