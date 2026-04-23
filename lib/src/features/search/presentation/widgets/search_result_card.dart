import 'package:e7gz/src/imports/imports.dart';
class SearchResultCard extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    
    final images = [
      'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1431324155629-1a6eda1eed2d?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1529900948632-58674ba193CB?auto=format&fit=crop&q=80',
    ];

    final titles = [
      'Anfield Arena',
      'Camp Nou Cairo',
      'The Arena Futsal',
      'Zayed Stars',
      'Katameya fields'
    ];
    
    final locations = ['New Cairo', 'Maadi', 'Dokki', 'Sheikh Zayed', 'Katameya'];
    final prices = ['450', '500', '350', '600', '400'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                  child: Image.network(
                    images[index % 5],
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: 200.h,
                        width: double.infinity,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white24),
                        ),
                      );
                    },
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
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4BE277),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    ),
                    child: Text(
                      'AVAILABLE TODAY',
                      style: TextStyle(
                        color: const Color(0xFF003915),
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
                              titles[index % 5],
                              style: typography.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFFBCC7DE),
                                  size: 14,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${locations[index % 5]} • 1.2 km',
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF171F33),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFF4BE277), size: 14),
                            SizedBox(width: 4.w),
                            Text(
                              '4.8',
                              style: TextStyle(
                                color: Colors.white,
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
                              color: const Color(0xFFBCC7DE),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: prices[index % 5],
                              style: typography.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(
                                  text: ' EGP/HR',
                                  style: TextStyle(
                                    color: const Color(0xFF4BE277),
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
