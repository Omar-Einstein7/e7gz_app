import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/imports.dart';

class FeaturedPitchesList extends StatelessWidget {
  const FeaturedPitchesList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return SizedBox(
      height: 450.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: 320.w,
            margin: EdgeInsets.only(right: 20.w),
            child: Stack(
              children: [
                // Image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
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
                                  'Al Ahly Stadium - Field A',
                                  style: typography.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 28.sp,
                                    height: 1,
                                  ),
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
                                    Text(
                                      'Nasr City, Cairo',
                                      style: TextStyle(
                                        color: const Color(0xFFBCC7DE),
                                        fontSize: 12.sp,
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
                                '600',
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
          );
        },
      ),
    );
  }
}
