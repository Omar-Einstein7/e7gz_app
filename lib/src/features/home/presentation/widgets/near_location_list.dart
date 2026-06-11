import 'dart:ui';
import 'package:e7gz/src/features/home/presentation/widgets/widgets.dart';
import 'package:e7gz/src/imports/imports.dart';

import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/di/injection_container.dart';

class NearLocationList extends StatefulWidget {
  const NearLocationList({super.key});

  @override
  State<NearLocationList> createState() => _NearLocationListState();
}

class _NearLocationListState extends State<NearLocationList> {
  Position? _userPosition;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final locationService = sl<LocationService>();
      final result = await locationService.getCurrentPosition();
      result.fold(
        (failure) {
          if (mounted) setState(() => _isLoadingLocation = false);
        },
        (position) {
          if (mounted) {
            setState(() {
              _userPosition = position;
              _isLoadingLocation = false;
            });
          }
        },
      );
    } catch (e) {
      AppLogger.warning('Failed to request location coordinates: $e');
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285.h,
      child: BlocBuilder<PitchesCubit, PitchesState>(
        builder: (context, state) {
          if (state.status == PitchesStatus.loading && state.pitches.isEmpty) {
            return HomeSkeleton.nearLocation();
          }

          if (state.status == PitchesStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitches',
                style: TextStyle(color: context.colors.error, fontSize: 14.sp),
              ),
            );
          }

          final pitches = state.pitches.reversed.toList();
          if (pitches.isEmpty) {
            return Center(
              child: Text(
                'No pitches nearby',
                style: TextStyle(
                  fontFamily: 'Chewy',
                  color: const Color(0xFFBCC7DE),
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: pitches.length > 5 ? 5 : pitches.length,
            itemBuilder: (context, index) {
              final pitch = pitches[index];
              return _NearPitchCard(
                    pitch: pitch,
                    userPosition: _userPosition,
                    isLoadingLocation: _isLoadingLocation,
                  )
                  .animate(delay: (index * 100).ms)
                  .fadeIn(duration: 500.ms)
                  .moveX(begin: 30, end: 0, curve: Curves.easeOutCubic);
            },
          );
        },
      ),
    );
  }
}

class _NearPitchCard extends StatelessWidget {
  final dynamic pitch;
  final Position? userPosition;
  final bool isLoadingLocation;

  const _NearPitchCard({
    required this.pitch,
    this.userPosition,
    this.isLoadingLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;

    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.pitchDetails.replaceFirst(':id', pitch.id),
        extra: {'pitch': pitch, 'heroTag': 'near_${pitch.id}'},
      ),
      child: Container(
        width: 275.w,
        margin: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32.r),
                    ),
                    child: Hero(
                      tag: 'near_${pitch.id}',
                      child: AppCachedImage(
                        imageUrl: pitch.imageUrl.isNotEmpty
                            ? pitch.imageUrl
                            : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Overlay for better text contrast
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Distance Badge
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                IconsaxPlusBold.location,
                                color: pitchTheme.accentGreen,
                                size: 12,
                              ),
                              SizedBox(width: 4.w),
                              if (isLoadingLocation)
                                SizedBox(
                                  width: 12.w,
                                  height: 12.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Text(
                                  _getDistanceText(),
                                  style: TextStyle(
                                    fontFamily: 'Chewy',
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pitch.name,
                          style: TextStyle(
                            fontFamily: 'Chewy',
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            const Icon(
                              IconsaxPlusLinear.map_1,
                              color: Color(0xFFBCC7DE),
                              size: 14,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                pitch.location.city,
                                style: TextStyle(
                                  fontFamily: 'Chewy',
                                  color: const Color(0xFFBCC7DE),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _AvailabilityBadge(isAvailable: pitch.isAvailable),
                        RichText(
                          text: TextSpan(
                            text: '${pitch.pricePerHour.toInt()}',
                            style: TextStyle(
                              fontFamily: 'Chewy',
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                            ),
                            children: [
                              TextSpan(
                                text: ' EGP',
                                style: TextStyle(
                                  fontFamily: 'Chewy',
                                  color: pitchTheme.accentGreen,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDistanceText() {
    if (userPosition == null) return '-- KM';

    try {
      final distanceInMeters = Geolocator.distanceBetween(
        userPosition!.latitude,
        userPosition!.longitude,
        pitch.location.latitude,
        pitch.location.longitude,
      );

      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} KM';
    } catch (e) {
      AppLogger.warning('Failed to calculate distance for pitch: $e');
      return '-- KM';
    }
  }
}

class _AvailabilityBadge extends StatelessWidget {
  final bool isAvailable;
  const _AvailabilityBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    final color = isAvailable ? pitchTheme.accentGreen : context.colors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        isAvailable ? 'AVAILABLE' : 'BOOKED',
        style: TextStyle(
          fontFamily: 'Chewy',
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
