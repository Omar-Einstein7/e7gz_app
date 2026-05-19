import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
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
    return Scaffold(
      body: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if (state.status == PitchDetailStatus.loading ||
              state.status == PitchDetailStatus.initial) {
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
              // 1. Custom Header with adaptive height for web/wide screens
              SliverPersistentHeader(
                pinned: true,
                delegate: _PitchHeaderDelegate(
                  pitch: pitch,
                  expandedHeight: isWide ? 500 : 0.8.sh,
                  collapsedHeight: isWide ? 300 : 0.5.sh,
                  topPadding: MediaQuery.paddingOf(context).top,
                ),
              ),

              // 2. The "Sheet-like" Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(color: context.colors.background),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg.w,
                      right: AppSpacing.lg.w,
                      bottom: AppSpacing.xl.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BookingHeaderRow(pitch: pitch),
                        SizedBox(height: AppSpacing.xl.h),
                        Divider(
                          color: context.colors.outlineVariant,
                          height: 1,
                        ),
                        SizedBox(height: AppSpacing.xl.h),
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

class _PitchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final dynamic pitch;
  final double expandedHeight;
  final double collapsedHeight;
  final double topPadding;

  _PitchHeaderDelegate({
    required this.pitch,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.topPadding,
  });

  @override
  double get minExtent => collapsedHeight;
  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final pc = context.pitchColors;
    final double percent = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      1.0,
    );

    // Zoom/Parallax calculation
    final double imageScale = 1.0 + (percent * 0.1);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Background Image
        Transform.scale(
          scale: imageScale,
          child: Hero(
            tag: 'pitch_image_${pitch.id}',
            child: pitch.images.isNotEmpty
                ? ImagePageView(images: pitch.images, opacity: 1.0 - percent)
                : AppCachedImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // 2. Gradient
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: pc.heroGradient),
          ),
        ),

        // 4. Venue Card (Moves up with the header)
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500.w),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                child: ClipRRect(
                  borderRadius: AppRadius.bxxl.r,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg.w,
                        vertical: AppSpacing.md.h,
                      ),
                      decoration: BoxDecoration(
                        color: pc.glassSurface,
                        borderRadius: AppRadius.bxxl.r,
                        border: Border.all(color: pc.glassBorder, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PremiumBadge().animate().scale(
                            delay: 400.ms,
                            curve: Curves.elasticOut,
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          Text(
                            pitch.name,
                            style: context.typography.headlineMedium?.copyWith(
                              color: context.colors.onSurface,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs.h),
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
                                  style: context.typography.bodyLarge?.copyWith(
                                    color: context.colors.onSurfaceVariant,
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
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms).moveY(begin: 30, end: 0),
        ),

        // 5. White "Lip" (Seamless connection to body)
        Positioned(
          bottom: -1, // Overlap slightly to prevent pixel lines
          left: 0,
          right: 0,
          child: Container(
            height: 32.h,
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
          ),
        ),

        // 5. Back Button (Always at top)
        Positioned(
          top: topPadding + 8,
          left: 16.w,
          child: _CircleActionButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        // 6. Right Actions
        Positioned(
          top: topPadding + 8,
          right: 16.w,
          child: Row(
            children: [
              _CircleActionButton(
                icon: IconsaxPlusLinear.share,
                onPressed: () {},
              ),
              _CircleActionButton(
                icon: IconsaxPlusLinear.heart,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _PitchHeaderDelegate oldDelegate) => true;
}

// Separate stateful widget for the PageView to prevent rebuild issues
class ImagePageView extends StatefulWidget {
  final List<String> images;
  final double opacity;
  const ImagePageView({super.key, required this.images, required this.opacity});

  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            final bool isWide = MediaQuery.sizeOf(context).width > 900;
            if (isWide) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Blurred background to fill space
                  AppCachedImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                  // Contained main image to show the "whole image"
                  AppCachedImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ],
              );
            }
            return AppCachedImage(
              imageUrl: widget.images[index],
              fit: BoxFit.cover,
            );
          },
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 180.h, // Positioned upper within the PageView's space
            left: 0,
            right: 0,
            child: Opacity(
              opacity: widget.opacity,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: widget.images.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 4.5.h,
                      dotWidth: 4.5.w,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.5),
                      expansionFactor: 4,
                      spacing: 8.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.xs.h,
      ),
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
        style: context.typography.labelSmall?.copyWith(
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.1),
        borderRadius: AppRadius.blg.r,
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
          SizedBox(width: AppSpacing.xs.w),
          Text(
            rating.toString(),
            style: context.typography.titleSmall?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ($reviews+)',
            style: context.typography.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
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
            if (amenity.toLowerCase().contains('shower'))
              iconData = IconsaxPlusLinear.cloud_drizzle;
            if (amenity.toLowerCase().contains('parking'))
              iconData = IconsaxPlusLinear.car;
            if (amenity.toLowerCase().contains('wifi'))
              iconData = IconsaxPlusLinear.wifi;
            if (amenity.toLowerCase().contains('cafe'))
              iconData = IconsaxPlusLinear.cup;
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
    final Uri googleMapUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );
    try {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open map: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    final lat = pitch.location.latitude;
    final lng = pitch.location.longitude;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'pitch_details.location_title'.tr().toUpperCase(),
        ),
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
                    style: context.typography.bodyLarge?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Icon(IconsaxPlusBold.map_1, color: pc.accentGreen, size: 20),
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
                border: Border.all(color: context.colors.outlineVariant),
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
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.e7gz.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(lat, lng),
                              width: 60,
                              height: 60,
                              child:
                                  Container(
                                        decoration: BoxDecoration(
                                          color: pc.accentGreen.withValues(
                                            alpha: 0.2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          IconsaxPlusBold.location,
                                          color: pc.accentGreen,
                                          size: 32,
                                        ),
                                      )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(),
                                      )
                                      .scale(
                                        begin: const Offset(0.8, 0.8),
                                        end: const Offset(1.2, 1.2),
                                        duration: 1000.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .then()
                                      .scale(
                                        begin: const Offset(1.2, 1.2),
                                        end: const Offset(0.8, 0.8),
                                        duration: 1000.ms,
                                        curve: Curves.easeInOut,
                                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'pitch_details.description'.tr().toUpperCase()),
        SizedBox(height: AppSpacing.md.h),
        Text(
          description.isNotEmpty
              ? description
              : "Featuring high-grade FIFA certified artificial turf, this pitch offers a premium playing surface that reduces injury risk and ensures optimal ball roll.",
          style: context.typography.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
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
      style: context.typography.labelSmall?.copyWith(
        color: pc.accentGreen,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );
  }
}

class _BookingHeaderRow extends StatelessWidget {
  final Pitch pitch;
  const _BookingHeaderRow({required this.pitch});

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'pitch_details.price_per_hour'.tr().toUpperCase(),
                    style: context.typography.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  RichText(
                    text: TextSpan(
                      text: '${pitch.pricePerHour.toInt()} ',
                      style: context.typography.titleMedium?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        TextSpan(
                          text: 'pitch_details.egp'.tr(),
                          style: context.typography.labelMedium?.copyWith(
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
            _BookNowButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push(
                  AppRoutes.bookingSlots.replaceFirst(':id', pitch.id),
                  extra: pitch,
                );
              },
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 100.ms)
        .moveY(begin: 10, end: 0);
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
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.md.h,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.bxl.r),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'pitch_details.book_now'.tr().toUpperCase(),
              style: context.typography.labelLarge?.copyWith(
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
