import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/shared/data/mock_data.dart';

class NearLocationList extends StatelessWidget {
  const NearLocationList({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final pitches = MockData.pitches;

    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: pitches.length,
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
                      pitch.imageUrl,
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
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${(index + 1) * 0.4} km away',
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
                            'Available Today',
                            style: TextStyle(
                              color: const Color(0xFF22C55E),
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
      ),
    );
  }
}

