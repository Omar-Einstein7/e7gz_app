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

    return Scaffold(
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
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          return RefreshIndicator(
            color: colors.primary,
            backgroundColor: colors.surface,
            onRefresh: () =>
                context.read<PitchesCubit>().loadPitches(refresh: true),
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
                          color: colors.onSurface,
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
                  const HomeSearchBar(),

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
