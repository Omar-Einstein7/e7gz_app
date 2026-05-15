import 'package:e7gz/src/imports/core_imports.dart';
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
          if (state.status == PitchesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PitchesStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitches',
                style: TextStyle(color: Colors.redAccent, fontSize: 14.sp),
              ),
            );
          }

          final pitches = state.pitches;
          if (pitches.isEmpty) {
            return Center(
              child: Text(
                'No pitches available',
                style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: pitches.length > 5 ? 5 : pitches.length, // Show up to 5 featured
            itemBuilder: (context, index) {
              final pitch = pitches[index];
              return GestureDetector(
                onTap: () => context.push(
                  AppRoutes.pitchDetails.replaceFirst(':id', pitch.id),
                ),
                child: Container(
                  width: 320.w,
                  margin: EdgeInsets.only(right: 20.w),
                  child: Stack(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                        child: AppCachedImage(
                          imageUrl: pitch.imageUrl.isNotEmpty 
                              ? pitch.imageUrl 
                              : 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      // Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
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
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4BE277).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Text(
                                'ELITE VENUE',
                                style: TextStyle(
                                  color: const Color(0xFF4BE277),
                                  fontSize: 10.sp,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pitch.name,
                                        style: typography.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28.sp,
                                          height: 1,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Color(0xFFBCC7DE),
                                            size: 14,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              pitch.location.city, // Display city instead of full location string
                                              style: TextStyle(
                                                color: const Color(0xFFBCC7DE),
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
                                      style: TextStyle(
                                        color: colors.primary,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'per hour',
                                      style: TextStyle(
                                        color: const Color(0xFFBCC7DE),
                                        fontSize: 10.sp,
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

