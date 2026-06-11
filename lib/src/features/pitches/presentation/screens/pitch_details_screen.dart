import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/di/injection_container.dart';
import '../widgets/widgets.dart';

class PitchDetailsScreen extends StatelessWidget {
  final String pitchId;
  final Pitch? pitch;
  final String? heroTag;
  const PitchDetailsScreen({
    super.key,
    required this.pitchId,
    this.pitch,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<PitchDetailCubit>()..loadPitch(pitchId, initialPitch: pitch),
      child: _PitchDetailsView(heroTag: heroTag),
    );
  }
}

class _PitchDetailsView extends StatelessWidget {
  final String? heroTag;
  const _PitchDetailsView({this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if ((state.status == PitchDetailStatus.loading ||
                  state.status == PitchDetailStatus.initial) &&
              state.pitch == null) {
            return Center(
              child: CircularProgressIndicator(color: context.colors.primary),
            );
          }

          if (state.status == PitchDetailStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitch details',
                style: TextStyle(color: context.colors.error, fontSize: 16.sp),
              ),
            );
          }

          final pitch = state.pitch;
          if (pitch == null) {
            return Center(
              child: Text(
                'Pitch not found',
                style: TextStyle(
                  color: context.colors.onSurface,
                  fontSize: 16.sp,
                ),
              ),
            );
          }

          final size = MediaQuery.sizeOf(context);
          final bool isWide = size.width > 900;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: PitchHeaderDelegate(
                  pitch: pitch,
                  heroTag: heroTag,
                  expandedHeight: isWide ? 500 : 0.8.sh,
                  collapsedHeight: isWide ? 300 : 0.5.sh,
                  topPadding: MediaQuery.paddingOf(context).top,
                ),
              ),

              SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: context.colors.surface),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg.w,
                      right: AppSpacing.lg.w,
                      bottom: AppSpacing.xl.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PitchBookingBar(pitch: pitch),
                        SizedBox(height: AppSpacing.xl.h),
                        Divider(
                          color: context.colors.outlineVariant,
                          height: 1,
                        ),
                        SizedBox(height: AppSpacing.xl.h),
                        PitchAmenitiesSection(amenities: pitch.amenities)
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 200.ms)
                            .moveY(begin: 20, end: 0),
                        SizedBox(height: AppSpacing.xxl.h),
                        PitchShiftsSection(pitch: pitch)
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .moveY(begin: 20, end: 0),
                        SizedBox(height: AppSpacing.xxl.h),
                        PitchReviewsSection(pitch: pitch)
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 500.ms)
                            .moveY(begin: 20, end: 0),
                        SizedBox(height: AppSpacing.xxl.h),
                        PitchLocationSection(pitch: pitch)
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 600.ms)
                            .moveY(begin: 20, end: 0),
                        SizedBox(height: AppSpacing.xxl.h),
                        PitchAboutSection(description: pitch.description)
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 800.ms)
                            .moveY(begin: 20, end: 0),
                        SizedBox(height: 140.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
