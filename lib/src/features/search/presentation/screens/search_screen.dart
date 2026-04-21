import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _selectedSport = 'Football';

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'e7gzz',
          style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.map, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                // Glass Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search stadium or location...',
                      hintStyle: TextStyle(color: const Color(0xFFBCC7DE).withValues(alpha: 0.5)),
                      icon: const Icon(IconsaxPlusLinear.search_normal_1, color: Color(0xFF4BE277)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Quick Filters
                SizedBox(
                  height: 44.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      filterChip('Football', _selectedSport == 'Football'),
                      SizedBox(width: 12.w),
                      filterChip('Padel', _selectedSport == 'Padel'),
                      SizedBox(width: 12.w),
                      filterChip('Basketball', false),
                      SizedBox(width: 12.w),
                      filterChip('Price', false, icon: IconsaxPlusLinear.arrow_down_1),
                      SizedBox(width: 12.w),
                      filterChip('Rating', false, icon: IconsaxPlusLinear.star),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: 5,
              itemBuilder: (context, index) {
                return searchResultCard(
                  index: index,
                  cs: cs,
                  tt: tt,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String label, bool isSelected, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4BE277) : const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: isSelected ? const Color(0xFF003915) : Colors.white, size: 14),
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF003915) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchResultCard({required int index, required ColorScheme cs, required TextTheme tt}) {
    final images = [
      'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1431324155629-1a6eda1eed2d?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1529900948632-58674ba193CB?auto=format&fit=crop&q=80',
    ];

    return GestureDetector(
      onTap: () => context.push(AppRoutes.pitchDetails),
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
                    fit: BoxFit.cover
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
                    child: const Icon(IconsaxPlusLinear.heart, color: Colors.white, size: 20),
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
                              ['Anfield Arena', 'Camp Nou Cairo', 'The Arena Futsal', 'Zayed Stars', 'Katameya fields'][index % 5],
                              style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFFBCC7DE), size: 14),
                                SizedBox(width: 4.w),
                                Text(
                                  ['New Cairo', 'Maadi', 'Dokki', 'Sheikh Zayed', 'Katameya'][index % 5] + ' • 1.2 km',
                                  style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp),
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
                            Text('4.8', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)),
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
                              text: ['450', '500', '350', '600', '400'][index % 5],
                              style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                              children: [
                                TextSpan(
                                  text: ' EGP/HR',
                                  style: TextStyle(color: const Color(0xFF4BE277), fontSize: 12.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppButton(
                        label: 'View Slots',
                        onPressed: () => context.push(AppRoutes.pitchDetails),
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
