import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';
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
                    _ShiftsSection(pitch: pitch)
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
        'pitch_details.premium_arena'.tr().toUpperCase(),
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
        _SectionHeader(title: 'pitch_details.amenities'.tr().toUpperCase()),
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
  final dynamic pitch;
  const _ShiftsSection({required this.pitch});

  String _formatTo12Hour(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? parts[1] : '00';
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final hourStr = hour12.toString().padLeft(2, '0');
      return '$hourStr:$minute $period';
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final opening = pitch.openingTime ?? '08:00';
    final closing = pitch.closingTime ?? '23:00';
    final price = pitch.pricePerHour.toInt().toString();
    final eveningPrice = (pitch.pricePerHour * 1.3).toInt().toString();

    final opening12 = _formatTo12Hour(opening);
    final closing12 = _formatTo12Hour(closing);

    int openingHour = 8;
    try {
      openingHour = int.parse(opening.split(':')[0]);
    } catch (_) {}

    final showMorning = openingHour < 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'pitch_details.shifts_title'.tr().toUpperCase()),
        SizedBox(height: 20.h),
        if (showMorning) ...[
          ShiftCard(
            title: 'pitch_details.sunlight_play'.tr(),
            subtitle: 'pitch_details.morning_shift'.tr().toUpperCase(),
            price: price,
            timeRange: '$opening12 - 04:00 PM',
            icon: IconsaxPlusLinear.sun_1,
          ),
          SizedBox(height: 16.h),
        ],
        ShiftCard(
          title: 'pitch_details.under_lights'.tr(),
          subtitle: 'pitch_details.evening_shift'.tr().toUpperCase(),
          price: eveningPrice,
          timeRange: '${showMorning ? '04:00 PM' : opening12} - $closing12',
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

  Future<void> _openMap(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    try {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open map: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    final cs = context.colorScheme;
    final lat = pitch.location.latitude;
    final lng = pitch.location.longitude;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'pitch_details.location_title'.tr().toUpperCase()),
        SizedBox(height: AppSpacing.md.h),
        InkWell(
          onTap: () => _openMap(lat, lng),
          borderRadius: AppRadius.bmd.r,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    pitch.location.fullAddress,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Icon(
                  IconsaxPlusBold.map_1,
                  color: pc.accentGreen,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        GestureDetector(
          onTap: () => _openMap(lat, lng),
          child: ClipRRect(
            borderRadius: AppRadius.bxxl.r,
            child: Container(
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Stack(
                children: [
                  AbsorbPointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(lat, lng),
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
                              point: LatLng(lat, lng),
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
                  Positioned(
                    bottom: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.directions_rounded, color: Colors.white, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'pitch_details.open_in_maps'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
        _SectionHeader(title: 'pitch_details.description'.tr().toUpperCase()),
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
                          'pitch_details.price_per_hour'.tr().toUpperCase(),
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
                                text: 'pitch_details.egp'.tr(),
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
              'pitch_details.book_now'.tr().toUpperCase(),
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


