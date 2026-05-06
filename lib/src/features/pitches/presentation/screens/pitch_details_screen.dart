import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/amenity_item.dart';
import '../widgets/shift_card.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/features/pitches/domain/usecases/pitch_usecases.dart';
import 'package:e7gz/src/features/pitches/data/repositories/pitch_repository_impl.dart';
import 'package:e7gz/src/features/pitches/data/datasources/pitch_remote_datasource.dart';

class PitchDetailsScreen extends StatelessWidget {
  final String pitchId;
  const PitchDetailsScreen({super.key, required this.pitchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PitchDetailCubit(
        GetPitchDetailsUseCase(PitchRepositoryImpl(PitchRemoteDataSource())),
      )..loadPitch(pitchId),
      child: const _PitchDetailsView(),
    );
  }
}

class _PitchDetailsView extends StatelessWidget {
  const _PitchDetailsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      body: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if (state.status == PitchDetailStatus.loading ||
              state.status == PitchDetailStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PitchDetailStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitch details',
                style: TextStyle(color: Colors.redAccent, fontSize: 16.sp),
              ),
            );
          }

          final pitch = state.pitch;
          if (pitch == null) {
            return Center(
              child: Text(
                'Pitch not found',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Hero Header with App Bar
              SliverAppBar(
                expandedHeight: 450.h,
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      IconsaxPlusLinear.share,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      IconsaxPlusLinear.heart,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 8.w),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      Image.network(
                        pitch.imageUrl.isNotEmpty
                            ? pitch.imageUrl
                            : 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                        fit: BoxFit.cover,
                      ),
                      // Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              const Color(0xFF0B1326),
                            ],
                          ),
                        ),
                      ),
                      // Venue Info Card
                      Positioned(
                        bottom: 40.h,
                        left: 24.w,
                        right: 24.w,
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2D3449,
                            ).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4BE277,
                                      ).withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                    ),
                                    child: Text(
                                      'PREMIUM ARENA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    pitch.name,
                                    style: typography.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 28.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Color(0xFFBCC7DE),
                                        size: 16,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          pitch.location.city,
                                          style: TextStyle(
                                            color: const Color(0xFFBCC7DE),
                                            fontSize: 14.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF131B2E,
                                          ).withValues(alpha: 0.8),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Color(0xFF4BE277),
                                              size: 14,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              pitch.rating.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            Text(
                                              ' (${pitch.reviewsCount}+)',
                                              style: TextStyle(
                                                color: const Color(0xFFBCC7DE),
                                                fontSize: 10.sp,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VENUE AMENITIES',
                        style: typography.labelSmall?.copyWith(
                          color: const Color(0xFFBCC7DE),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: pitch.amenities.map((amenity) {
                          IconData iconData = Icons.star;
                          if (amenity.toLowerCase().contains('shower'))
                            iconData = Icons.shower;
                          if (amenity.toLowerCase().contains('parking'))
                            iconData = Icons.local_parking;
                          if (amenity.toLowerCase().contains('wifi'))
                            iconData = Icons.wifi;
                          if (amenity.toLowerCase().contains('cafe'))
                            iconData = Icons.coffee;
                          return AmenityItem(label: amenity, icon: iconData);
                        }).toList(),
                      ),

                      SizedBox(height: 48.h),

                      // Shifts (Hardcoded for now, or you could derive from pitch slots)
                      const ShiftCard(
                        title: 'Sunlight Play',
                        subtitle: 'MORNING SHIFT',
                        price: '350',
                        timeRange: '08:00 AM - 04:00 PM',
                        icon: Icons.wb_sunny_outlined,
                      ),

                      SizedBox(height: 16.h),

                      const ShiftCard(
                        title: 'Under the Lights',
                        subtitle: 'EVENING SHIFT',
                        price: '550',
                        timeRange: '05:00 PM - 02:00 AM',
                        icon: Icons.nightlight_round,
                        isSelected: true,
                      ),

                      SizedBox(height: 48.h),

                      // Map section
                      Text(
                        'Location & Map',
                        style: typography.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        pitch.location.fullAddress,
                        style: typography.bodyMedium?.copyWith(
                          color: const Color(0xFFBCC7DE),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32.r),
                        child: SizedBox(
                          height: 250.h,
                          width: double.infinity,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                pitch.location.latitude,
                                pitch.location.longitude,
                              ),
                              initialZoom: 14.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.e7gz.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      pitch.location.latitude,
                                      pitch.location.longitude,
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      IconsaxPlusBold.location,
                                      color: colors.primary,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 48.h),

                      // About
                      Text(
                        'About this pitch',
                        style: typography.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        pitch.description.isNotEmpty
                            ? pitch.description
                            : "Featuring high-grade FIFA certified artificial turf, this pitch offers a premium playing surface that reduces injury risk and ensures optimal ball roll.",
                        style: typography.bodyMedium?.copyWith(
                          color: const Color(0xFFBCC7DE).withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),

                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          final pitch = state.pitch;
          if (pitch == null) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 40.h),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRICE PER HOUR',
                      style: typography.labelSmall?.copyWith(
                        color: const Color(0xFFBCC7DE),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${pitch.pricePerHour.toInt()} ',
                        style: typography.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          TextSpan(
                            text: 'EGP',
                            style: typography.titleSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppButton(
                  label: 'BOOK NOW',
                  width: ButtonSize.large,
                  onPressed: () => context.push(
                    AppRoutes.bookingSlots.replaceFirst(':id', pitch.id),
                    extra: pitch,
                  ),
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
