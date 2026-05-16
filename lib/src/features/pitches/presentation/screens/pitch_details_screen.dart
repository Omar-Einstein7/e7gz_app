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
    final cs = context.colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if (state.status == PitchDetailStatus.loading ||
              state.status == PitchDetailStatus.initial) {
            return Center(child: CircularProgressIndicator(color: cs.primary));
          }

          if (state.status == PitchDetailStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load pitch details',
                style: TextStyle(color: cs.error, fontSize: 16.sp),
              ),
            );
          }

          final pitch = state.pitch;
          if (pitch == null) {
            return Center(
              child: Text(
                'Pitch not found',
                style: TextStyle(color: cs.onSurface, fontSize: 16.sp),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _HeaderSection(pitch: pitch),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.xl.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _AmenitiesSection(amenities: pitch.amenities)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: AppSpacing.xxl.h),
                    _ShiftsSection()
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: AppSpacing.xxl.h),
                    _LocationSection(pitch: pitch)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 600.ms)
                        .moveY(begin: 20, end: 0),
                    SizedBox(height: AppSpacing.xxl.h),
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
    final pc = context.pitchColors;
    final cs = context.colorScheme;
    
    return SliverAppBar(
      expandedHeight: 500.h,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      stretch: true,
      leading: Container(
        margin: EdgeInsets.all(AppSpacing.sm.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
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
        SizedBox(width: AppSpacing.md.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'pitch_image_${pitch.id}',
              child: AppCachedImage(
                imageUrl: pitch.imageUrl.isNotEmpty
                    ? pitch.imageUrl
                    : 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
              ),
            ),
            // Sophisticated Gradient Overlay from PitchColors extension
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: pc.heroGradient,
              ),
            ),
            // Venue Info Card with Glassmorphism
            Positioned(
              bottom: AppSpacing.xl.h,
              left: AppSpacing.md.w,
              right: AppSpacing.md.w,
              child: ClipRRect(
                borderRadius: AppRadius.bxxl.r,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.lg.w),
                    decoration: BoxDecoration(
                      color: pc.glassSurface,
                      borderRadius: AppRadius.bxxl.r,
                      border: Border.all(
                        color: pc.glassBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _PremiumBadge().animate().scale(delay: 400.ms, curve: Curves.elasticOut),
                        SizedBox(height: AppSpacing.md.h),
                        Text(
                          pitch.name,
                          style: context.textTheme.headlineLarge?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        Row(
                          children: [
                            Icon(
                              IconsaxPlusBold.location,
                              color: pc.accentGreen,
                              size: 18,
                            ),
                            SizedBox(width: AppSpacing.xs.w),
                            Expanded(
                              child: Text(
                                pitch.location.city,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            _RatingBadge(
                              rating: pitch.rating, 
                              reviews: pitch.reviewsCount, 
                            ),
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
    final pc = context.pitchColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.xs.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [pc.accentGreen, pc.accentGreen.withValues(alpha: 0.8)],
        ),
        borderRadius: AppRadius.bfull.r,
        boxShadow: [
          BoxShadow(
            color: pc.accentGreen.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        'PREMIUM ARENA',
        style: context.textTheme.labelSmall?.copyWith(
          color: Colors.white,
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
  const _RatingBadge({required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.1),
        borderRadius: AppRadius.blg.r,
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
          SizedBox(width: AppSpacing.xs.w),
          Text(
            rating.toString(),
            style: context.textTheme.titleSmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ($reviews+)',
            style: context.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
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
    final pc = context.pitchColors;
    final cs = context.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'LOCATION & ACCESS'),
        SizedBox(height: AppSpacing.md.h),
        Text(
          pitch.location.fullAddress,
          style: context.textTheme.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        ClipRRect(
          borderRadius: AppRadius.bxxl.r,
          child: Container(
            height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
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
                          color: pc.accentGreen.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconsaxPlusBold.location,
                          color: pc.accentGreen,
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
    final cs = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ABOUT THIS ARENA'),
        SizedBox(height: AppSpacing.md.h),
        Text(
          description.isNotEmpty
              ? description
              : "Featuring high-grade FIFA certified artificial turf, this pitch offers a premium playing surface that reduces injury risk and ensures optimal ball roll.",
          style: context.textTheme.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
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
    final pc = context.pitchColors;
    return Text(
      title,
      style: context.textTheme.labelSmall?.copyWith(
        color: pc.accentGreen,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );
  }
}

class _BookingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    final cs = context.colorScheme;

    return BlocBuilder<PitchDetailCubit, PitchDetailState>(
      builder: (context, state) {
        final pitch = state.pitch;
        if (pitch == null) return const SizedBox.shrink();

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(AppSpacing.xl.w, AppSpacing.md.h, AppSpacing.xl.w, AppSpacing.xxl.h),
              decoration: BoxDecoration(
                color: pc.glassSurface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl.r)),
                border: Border.all(color: pc.glassBorder),
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
                          style: context.textTheme.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        RichText(
                          text: TextSpan(
                            text: '${pitch.pricePerHour.toInt()} ',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                            children: [
                              TextSpan(
                                text: 'EGP',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: pc.accentGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
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
    final pc = context.pitchColors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.bxl.r,
        boxShadow: [
          BoxShadow(
            color: pc.accentGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: pc.accentGreen,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w, vertical: AppSpacing.md.h),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.bxl.r,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BOOK NOW',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            const Icon(IconsaxPlusBold.calendar_2, size: 18),
          ],
        ),
      ),
    );
  }
}


