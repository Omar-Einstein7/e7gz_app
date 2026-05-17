import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<PitchesCubit>();
      if (cubit.state.pitches.isEmpty) {
        cubit.loadPitches(refresh: true);
      }
    });
  }

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
      
        title: Text(
          'e7gzz',
          style: typography.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<PitchesCubit, PitchesState>(
        builder: (context, state) {
          if (state.status == PitchesStatus.loading && state.pitches.isEmpty) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }

          return RefreshIndicator(
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surface,
            onRefresh: () => context.read<PitchesCubit>().loadPitches(refresh: true),
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
                        text: 'home.headline_start'.tr(),
                        style: typography.displaySmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 40.sp,
                          height: 1.1,
                        ),
                        children: [
                          TextSpan(
                            text: 'home.headline_end'.tr(),
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
                                'home.search_placeholder'.tr(),
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

               

                  // Featured Section
                  HomeSectionHeader(
                    title: 'home.featured_pitches'.tr(),
                    onViewAllPressed: () => _onViewAll(null),
                  ),
                  SizedBox(height: 24.h),
                  const FeaturedPitchesList(),

                  SizedBox(height: 48.h),

                  // Near Location Section
                  HomeSectionHeader(
                    title: 'home.near_location'.tr(),
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
    );
  }
}
