import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      drawer: const Drawer(), // Menu
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(IconsaxPlusLinear.menu_1, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'e7gzz',
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFF2D3449),
                child: const Icon(IconsaxPlusBold.user, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            
            // Headline
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: RichText(
                text: TextSpan(
                  text: 'The Pitch\n',
                  style: tt.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 40.sp,
                    height: 1.1,
                  ),
                  children: [
                    TextSpan(
                      text: 'is Calling.',
                      style: TextStyle(
                        color: cs.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.search),
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(IconsaxPlusLinear.search_normal_1, color: Color(0xFFBCC7DE)),
                      SizedBox(width: 12.w),
                      Text(
                        'Search stadium or location...',
                        style: TextStyle(color: const Color(0xFFBCC7DE).withValues(alpha: 0.5), fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Categories
            SizedBox(
              height: 50.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                   categoryChip('Football', Icons.sports_soccer, true, cs),
                   SizedBox(width: 12.w),
                   categoryChip('Padel', Icons.sports_tennis, false, cs),
                   SizedBox(width: 12.w),
                   categoryChip('Near Me', IconsaxPlusLinear.location, false, cs),
                ],
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Featured Section
            sectionHeader('Featured Pitches', true),
            SizedBox(height: 24.h),
            featuredPitchesList(cs, tt),
            
            SizedBox(height: 48.h),
            
            // Near Location Section
            sectionHeader('Near Your Location', false),
            SizedBox(height: 24.h),
            nearLocationList(cs, tt),
            
            SizedBox(height: 100.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: cs.primary,
        child: const Icon(Icons.add, color: Color(0xFF003915), size: 32),
      ),
      
    );
  }

  Widget categoryChip(String label, IconData icon, bool isSelected, ColorScheme cs) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isSelected ? cs.primary : const Color(0xFF171F33),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF003915) : Colors.white, size: 20),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF003915) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title, bool showViewAll) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURATED FOR YOU',
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                title,
                style: context.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (showViewAll)
            Text(
              'View All',
              style: TextStyle(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            )
          else
            const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  Widget featuredPitchesList(ColorScheme cs, TextTheme tt) {
    return SizedBox(
      height: 480.h,
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
                      image: NetworkImage('https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80'),
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
                                  style: tt.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 28.sp,
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Color(0xFFBCC7DE), size: 14),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Nasr City, Cairo',
                                      style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp),
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
                                style: tt.headlineSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'EGP',
                                style: TextStyle(color: cs.primary, fontSize: 10.sp, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'per hour',
                                style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp),
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

  Widget nearLocationList(ColorScheme cs, TextTheme tt) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
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
                    'https://images.unsplash.com/photo-1529900948632-58674ba193CB?auto=format&fit=crop&q=80',
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Katameya Fields',
                        style: tt.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '1.2 km away',
                        style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '5 Available Slots',
                          style: TextStyle(color: const Color(0xFF22C55E), fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
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
