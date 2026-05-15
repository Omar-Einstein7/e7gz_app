import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/amenity_item.dart';
import '../widgets/shift_card.dart';
import 'dart:ui';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/di/injection_container.dart';
import 'package:flutter_animate/flutter_animate.dart';


class PitchDetailsScreen extends StatelessWidget {
  final String pitchId;
  const PitchDetailsScreen({super.key, required this.pitchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PitchDetailCubit>()..loadPitch(pitchId),
      child: const _PitchDetailsView(),
    );
  }
}

class _PitchDetailsView extends StatelessWidget {
  const _PitchDetailsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pitchTheme = context.pitchTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: isDark ? pitchTheme.nightBackground : Theme.of(context).colorScheme.surface,
      body: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if (state.status == PitchDetailStatus.loading ||
              state.status == PitchDetailStatus.initial) {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
          }

          if (state.status == PitchDetailStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitch details',
                style: TextStyle(color: colors.error, fontSize: 16.sp),
              ),
            );
          }

          final pitch = state.pitch;
          if (pitch == null) {
            return Center(
              child: Text(
                'Pitch not found',
                style: TextStyle(color: textColor, fontSize: 16.sp),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _HeaderSection(pitch: pitch),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _AmenitiesSection(amenities: pitch.amenities)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: 48.h),
                    _ShiftsSection()
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: 48.h),
                    _LocationSection(pitch: pitch)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 600.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: 48.h),
                    _AboutSection(description: pitch.description)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 800.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: 140.h),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: _BookingBottomSheet(),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final dynamic pitch;
  const _HeaderSection({required this.pitch});

  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SliverAppBar(
      expandedHeight: 500.h,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      stretch: true,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        _CircleActionButton(
          icon: IconsaxPlusLinear.share,
          onPressed: () {},
        ),
        _CircleActionButton(
          icon: IconsaxPlusLinear.heart,
          onPressed: () {},
        ),
        SizedBox(width: 16.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppCachedImage(
              imageUrl: pitch.imageUrl.isNotEmpty
                  ? pitch.imageUrl
                  : 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
              fit: BoxFit.cover,
            ),
            // Sophisticated Gradient Overlay from PitchTheme
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: pitchTheme.heroGradient,
              ),
            ),
            // Venue Info Card with Glassmorphism
            Positioned(
              bottom: 30.h,
              left: 20.w,
              right: 20.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: pitchTheme.glassSurface,
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(
                        color: pitchTheme.glassBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _PremiumBadge().animate().scale(delay: 400.ms, curve: Curves.elasticOut),
                        SizedBox(height: 16.h),
                        Text(
                          pitch.name,
                          style: TextStyle(
                            fontFamily: 'Chewy',
                            color: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 32.sp,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              IconsaxPlusBold.location,
                              color: pitchTheme.accentGreen,
                              size: 18,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                pitch.location.city,
                                style: TextStyle(
                                  fontFamily: 'Chewy',
                                  color: isDark ? const Color(0xFFBCC7DE) : Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            _RatingBadge(rating: pitch.rating, reviews: pitch.reviewsCount, isDark: isDark, cs: Theme.of(context).colorScheme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).moveY(begin: 30, end: 0),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _CircleActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [pitchTheme.accentGreen, pitchTheme.accentGreen.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: pitchTheme.accentGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        'PREMIUM ARENA',
        style: TextStyle(
          fontFamily: 'Chewy',
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  final int reviews;
  final bool isDark;
  final ColorScheme cs;
  const _RatingBadge({required this.rating, required this.reviews, required this.isDark, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : cs.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
          SizedBox(width: 4.w),
          Text(
            rating.toString(),
            style: TextStyle(
              fontFamily: 'Chewy',
              color: isDark ? Colors.white : cs.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Text(
            ' ($reviews+)',
            style: TextStyle(
              fontFamily: 'Chewy',
              color: isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  final List<String> amenities;
  const _AmenitiesSection({required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'VENUE AMENITIES'),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: amenities.map((amenity) {
            IconData iconData = IconsaxPlusLinear.star;
            if (amenity.toLowerCase().contains('shower')) iconData = IconsaxPlusLinear.cloud_drizzle;
            if (amenity.toLowerCase().contains('parking')) iconData = IconsaxPlusLinear.car;
            if (amenity.toLowerCase().contains('wifi')) iconData = IconsaxPlusLinear.wifi;
            if (amenity.toLowerCase().contains('cafe')) iconData = IconsaxPlusLinear.cup;
            return AmenityItem(label: amenity, icon: iconData);
          }).toList(),
        ),
      ],
    );
  }
}

class _ShiftsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'AVAILABLE SHIFTS'),
        SizedBox(height: 20.h),
        const ShiftCard(
          title: 'Sunlight Play',
          subtitle: 'MORNING SHIFT',
          price: '350',
          timeRange: '08:00 AM - 04:00 PM',
          icon: IconsaxPlusLinear.sun_1,
        ),
        SizedBox(height: 16.h),
        const ShiftCard(
          title: 'Under the Lights',
          subtitle: 'EVENING SHIFT',
          price: '550',
          timeRange: '05:00 PM - 02:00 AM',
          icon: IconsaxPlusLinear.moon,
          isSelected: true,
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  final dynamic pitch;
  const _LocationSection({required this.pitch});

  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'LOCATION & ACCESS'),
        SizedBox(height: 16.h),
        Text(
          pitch.location.fullAddress,
          style: TextStyle(
            fontFamily: 'Chewy',
            color: isDark ? const Color(0xFFBCC7DE) : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16.sp,
            height: 1.6,
          ),
        ),
        SizedBox(height: 24.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: Container(
            height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Theme.of(context).colorScheme.outlineVariant),
            ),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  pitch.location.latitude,
                  pitch.location.longitude,
                ),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.e7gz.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        pitch.location.latitude,
                        pitch.location.longitude,
                      ),
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: pitchTheme.accentGreen.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconsaxPlusBold.location,
                          color: pitchTheme.accentGreen,
                          size: 32,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1000.ms, curve: Curves.easeInOut)
                       .then()
                       .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8), duration: 1000.ms, curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String description;
  const _AboutSection({required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ABOUT THIS ARENA'),
        SizedBox(height: 16.h),
        Text(
          description.isNotEmpty
              ? description
              : "Featuring high-grade FIFA certified artificial turf, this pitch offers a premium playing surface that reduces injury risk and ensures optimal ball roll.",
          style: TextStyle(
            fontFamily: 'Chewy',
            color: isDark ? const Color(0xFFBCC7DE).withOpacity(0.8) : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16.sp,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Chewy',
        color: pitchTheme.accentGreen,
        fontWeight: FontWeight.w800,
        fontSize: 12.sp,
        letterSpacing: 2,
      ),
    );
  }
}

class _BookingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<PitchDetailCubit, PitchDetailState>(
      builder: (context, state) {
        final pitch = state.pitch;
        if (pitch == null) return const SizedBox.shrink();

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 40.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131B2E).withOpacity(0.8) : cs.surface.withOpacity(0.9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                border: Border.all(color: isDark ? pitchTheme.glassBorder : cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRICE / HOUR',
                          style: TextStyle(
                            fontFamily: 'Chewy',
                            color: isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        RichText(
                          text: TextSpan(
                            text: '${pitch.pricePerHour.toInt()} ',
                            style: TextStyle(
                              fontFamily: 'Chewy',
                              color: isDark ? Colors.white : cs.onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: 15.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'EGP',
                                style: TextStyle(
                                  fontFamily: 'Chewy',
                                  color: pitchTheme.accentGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  _BookNowButton(onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.push(
                      AppRoutes.bookingSlots.replaceFirst(':id', pitch.id),
                      extra: pitch,
                    );
                  }),
                ],
              ),
            ),
          ),
        ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _BookNowButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BookNowButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final pitchTheme = context.pitchTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: pitchTheme.accentGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: pitchTheme.accentGreen,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 18.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BOOK NOW',
              style: TextStyle(
                fontFamily: 'Chewy',
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 12.w),
            const Icon(IconsaxPlusBold.calendar_2, size: 18),
          ],
        ),
      ),
    );
  }
}


