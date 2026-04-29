import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';

class NearLocationList extends StatelessWidget {
  const NearLocationList({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return SizedBox(
      height: 240.h,
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

          // For NearLocationList, we might ideally use a different list or sorted by distance.
          // For now, we'll just use the loaded pitches and display a subset to simulate "near".
          final pitches = state.pitches.reversed.toList(); // Just to show different ones than featured
          if (pitches.isEmpty) {
            return Center(
              child: Text(
                'No pitches nearby',
                style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: pitches.length > 5 ? 5 : pitches.length,
            itemBuilder: (context, index) {
              final pitch = pitches[index];
              return GestureDetector(
                onTap: () => context.push(
                  AppRoutes.pitchDetails.replaceFirst(':id', pitch.id),
                ),
                child: Container(
                  width: 280.w,
                  margin: EdgeInsets.only(right: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                        child: Image.network(
                          pitch.imageUrl.isNotEmpty ? pitch.imageUrl : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                          height: 140.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              height: 140.h,
                              width: double.infinity,
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.white24),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pitch.name,
                              style: typography.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${(index + 1) * 0.4} km away', // Mock distance for now since backend ORS integration would provide actual distances
                              style: TextStyle(
                                color: const Color(0xFFBCC7DE),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                pitch.isAvailable ? 'Available Today' : 'Unavailable',
                                style: TextStyle(
                                  color: pitch.isAvailable ? const Color(0xFF22C55E) : Colors.redAccent,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

