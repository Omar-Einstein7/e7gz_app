import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  late final List<Map<String, dynamic>> _onboardingData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _onboardingData = [
      {
        'titleKey': 'onboarding.title_1',
        'subtitleKey': 'onboarding.subtitle_1',
        'image': AppAssets.onboardingPitch,
      },
      {
        'titleKey': 'onboarding.title_2',
        'subtitleKey': 'onboarding.subtitle_2',
        'image': AppAssets.onboardingStadium,
      },
      {
        'titleKey': 'onboarding.title_3',
        'subtitleKey': 'onboarding.subtitle_3',
        'image': AppAssets.onboardingPlayers,
      },
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100.h,
            left: -100.w,
            child: Container(
              width: 500.w,
              height: 500.h,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingData.length,
                      onPageChanged: (index) =>
                          setState(() => _currentIndex = index),
                      itemBuilder: (context, index) {
                        final item = _onboardingData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Section - Now responsive
                            Expanded(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: 40.h,
                                    right: -40.w,
                                    left: 20.w,
                                    bottom: 20.h,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(48.r),
                                          bottomLeft: Radius.circular(48.r),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            item['image'] as String,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 30,
                                            offset: const Offset(0, 15),
                                          ),
                                        ],
                                      ),
                                    )
                                        .animate()
                                        .fadeIn(duration: 600.ms)
                                        .slideX(
                                          begin: 0.2,
                                          end: 0,
                                          curve: Curves.easeOutCubic,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Text Section - Scrollable to prevent vertical overflow
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                          (item['titleKey'] as String).tr(),
                                          style: textTheme.displayMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28.sp,
                                            height: 1.1,
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(delay: 200.ms, duration: 500.ms)
                                        .slideY(begin: 0.2, end: 0),

                                    SizedBox(height: 16.h),

                                    Text(
                                          (item['subtitleKey'] as String).tr(),
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: const Color(
                                              0xFFBCC7DE,
                                            ).withValues(alpha: 0.8),
                                            fontSize: 15.sp,
                                            height: 1.5,
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(delay: 400.ms, duration: 500.ms)
                                        .slideY(begin: 0.2, end: 0),

                                    SizedBox(height: 32.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Bottom Section
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 48.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Indicators
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _onboardingData.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: colorScheme.primary,
                            dotColor: const Color(
                              0xFFBCC7DE,
                            ).withValues(alpha: 0.2),
                            dotHeight: 8.h,
                            dotWidth: 8.w,
                            expansionFactor: 3,
                            spacing: 8.w,
                          ),
                        ),

                        // Navigation Button
                        if (_currentIndex == _onboardingData.length - 1)
                          AppButton(
                            label: 'shared.get_started'.tr(),
                            onPressed: _onGetStarted,
                            width: ButtonSize.medium,
                            suffixIcon: const Icon(Icons.arrow_forward),
                          ).animate().scale(
                            duration: 300.ms,
                            curve: Curves.easeOutBack,
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF131B2E),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
