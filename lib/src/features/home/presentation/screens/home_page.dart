import 'package:e7gz/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:e7gz/src/features/home/presentation/cubit/home_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onViewAll(String? sport) {
    context.go(AppRoutes.search, extra: sport);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF0B1326) : theme.colorScheme.surface;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final searchBg = isDark ? const Color(0xFF131B2E) : theme.colorScheme.surfaceContainerLow;
    final searchHint = isDark ? const Color(0xFFBCC7DE).withValues(alpha: 0.5) : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);

    return Scaffold(
      backgroundColor: bgColor,
      // drawer: const Drawer(), // Menu
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: Icon(IconsaxPlusLinear.menu_1, color: textColor),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
        title: Text(
          'e7gzz',
          style: typography.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   GestureDetector(
        //     onTap: () => context.push(AppRoutes.profile),
        //     child: Padding(
        //       padding: EdgeInsets.only(right: 16.w),
        //       child: CircleAvatar(
        //         radius: 18.r,
        //         backgroundColor: isDark ? const Color(0xFF2D3449) : theme.colorScheme.surfaceContainerHighest,
        //         child: Icon(
        //           IconsaxPlusBold.user,
        //           size: 20,
        //           color: isDark ? Colors.white : theme.colorScheme.onSurfaceVariant,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading && state.data == null) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }

          final data = state.data;

          return RefreshIndicator(
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surface,
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                          color: textColor,
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
                      onTap: () => StatefulNavigationShell.of(context).goBranch(1),
                      child: Container(
                        height: 56.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: searchBg,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              IconsaxPlusLinear.search_normal_1,
                              color: isDark ? const Color(0xFFBCC7DE) : theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Search stadium or location...',
                                style: TextStyle(
                                  color: searchHint,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Categories
                  // SizedBox(
                  //   height: 50.h,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: EdgeInsets.symmetric(horizontal: 24.w),
                  //     children: data != null && data.categories.isNotEmpty
                  //         ? data.categories
                  //               .map(
                  //                 (cat) => Padding(
                  //                   padding: EdgeInsets.only(right: 12.w),
                  //                   child: HomeCategoryChip(
                  //                     label: cat.name,
                  //                     icon: Icons
                  //                         .sports_soccer, // Map icons if needed
                  //                     isSelected: cat.name == 'Football',
                  //                   ),
                  //                 ),
                  //               )
                  //               .toList()
                  //         : [
                  //             const HomeCategoryChip(
                  //               label: 'Football',
                  //               icon: Icons.sports_soccer,
                  //               isSelected: true,
                  //             ),
                  //             SizedBox(width: 12.w),
                  //             const HomeCategoryChip(
                  //               label: 'Padel',
                  //               icon: Icons.sports_tennis,
                  //             ),
                  //             SizedBox(width: 12.w),
                  //             const HomeCategoryChip(
                  //               label: 'Near Me',
                  //               icon: IconsaxPlusLinear.location,
                  //             ),
                  //           ],
                  //   ),
                  // ),

                  // SizedBox(height: 40.h),

                  // Featured Section
                  HomeSectionHeader(
                    title: 'Featured Pitches',
                    onViewAllPressed: () => _onViewAll(null),
                  ),
                  SizedBox(height: 24.h),
                  const FeaturedPitchesList(),

                  SizedBox(height: 48.h),

                  // Near Location Section
                  HomeSectionHeader(
                    title: 'Near Your Location',
                    onViewAllPressed: () => _onViewAll(null),
                  ),
                  SizedBox(height: 24.h),
                  const NearLocationList(),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => StatefulNavigationShell.of(context).goBranch(1),
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Color(0xFF003915), size: 32),
      ),
    );
  }
}
