import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class PitchDetailsScreen extends StatefulWidget {
  const PitchDetailsScreen({super.key});

  @override
  State<PitchDetailsScreen> createState() => _PitchDetailsScreenState();
}

class _PitchDetailsScreenState extends State<PitchDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      body: CustomScrollView(
        slivers: [
          // Hero Header with App Bar
          SliverAppBar(
            expandedHeight: 450.h,
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(IconsaxPlusLinear.share, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(IconsaxPlusLinear.heart, color: Colors.white),
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
                    'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
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
                        color: const Color(0xFF2D3449).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4BE277).withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(100.r),
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
                                'Al-Maadi International Center',
                                style: tt.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color(0xFFBCC7DE), size: 16),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Maadi, Cairo',
                                    style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF131B2E).withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star, color: Color(0xFF4BE277), size: 14),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '4.9',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                                        ),
                                        Text(
                                          ' (120+)',
                                          style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp),
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
                    style: tt.labelSmall?.copyWith(
                      color: const Color(0xFFBCC7DE),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      amenityItem('Showers', Icons.shower),
                      amenityItem('Parking', Icons.local_parking),
                      amenityItem('Free WiFi', Icons.wifi),
                      amenityItem('Cafeteria', Icons.coffee),
                    ],
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // Shifts
                  shiftCard(
                    title: 'Sunlight Play',
                    subtitle: 'MORNING SHIFT',
                    price: '350',
                    timeRange: '08:00 AM - 04:00 PM',
                    icon: Icons.wb_sunny_outlined,
                    isSelected: false,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  shiftCard(
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
                    style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Street 250, behind the Grand Mall, Maadi, Cairo. Easy access via Metro and private parking available.',
                    style: tt.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE), height: 1.5),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: Color(0xFF003915), size: 30),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // About
                  Text(
                    'About this pitch',
                    style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Featuring high-grade FIFA certified artificial turf, Al-Maadi International Center offers a premium playing surface that reduces injury risk and ensures optimal ball roll. Our 5-a-side and 7-a-side pitches are equipped with professional-grade LED floodlights for perfect visibility during night matches. We provide clean locker rooms, fresh water, and a viewing area for spectators.",
                    style: tt.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE).withValues(alpha: 0.8), height: 1.6),
                  ),
                  
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 40.h),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL PRICE',
                  style: tt.labelSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    text: '550 ',
                    style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                    children: [
                      TextSpan(
                        text: 'EGP',
                        style: tt.titleSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppButton(
              label: 'BOOK NOW',
              width: ButtonSize.large,
              onPressed: () => context.push(AppRoutes.bookingSlots),
              suffixIcon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }

  Widget amenityItem(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: const Color(0xFF171F33),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF4BE277), size: 24),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget shiftCard({
    required String title,
    required String subtitle,
    required String price,
    required String timeRange,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
        border: isSelected ? Border.all(color: const Color(0xFF4BE277), width: 1.5) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: context.theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? const Color(0xFF4BE277) : const Color(0xFFBCC7DE),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  title,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  timeRange,
                  style: TextStyle(color: const Color(0xFFBCC7DE).withValues(alpha: 0.5), fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: '$price ',
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(
                      text: 'EGP / HOUR',
                      style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
