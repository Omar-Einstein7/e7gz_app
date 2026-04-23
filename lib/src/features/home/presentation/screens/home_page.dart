import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

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
          style: typography.headlineSmall?.copyWith(
            color: colors.primary,
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
                  style: typography.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 40.sp,
                    height: 1.1,
                  ),
                  children: [
                    TextSpan(
                      text: 'is Calling.',
                      style: TextStyle(
                        color: colors.primary,
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
                        style: TextStyle(
                          color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
                          fontSize: 14.sp,
                        ),
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
                  const HomeCategoryChip(label: 'Football', icon: Icons.sports_soccer, isSelected: true),
                  SizedBox(width: 12.w),
                  const HomeCategoryChip(label: 'Padel', icon: Icons.sports_tennis),
                  SizedBox(width: 12.w),
                  const HomeCategoryChip(label: 'Near Me', icon: IconsaxPlusLinear.location),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Featured Section
            HomeSectionHeader(
              title: 'Featured Pitches',
              onViewAllPressed: () {},
            ),
            SizedBox(height: 24.h),
            const FeaturedPitchesList(),

            SizedBox(height: 48.h),

            // Near Location Section
            const HomeSectionHeader(
              title: 'Near Your Location',
              showViewAll: false,
            ),
            SizedBox(height: 24.h),
            const NearLocationList(),

            SizedBox(height: 100.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Color(0xFF003915), size: 32),
      ),
    );
  }
}

