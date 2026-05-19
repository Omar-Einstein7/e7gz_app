import 'package:e7gz/src/imports/imports.dart';
import '../widgets/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PitchLocationSection extends StatelessWidget {
  final dynamic pitch;
  const PitchLocationSection({super.key, required this.pitch});

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
        const PitchSectionHeader(title: 'pitch_details.location_title'),
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
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(lat, lng),
                      initialZoom: 15.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
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
