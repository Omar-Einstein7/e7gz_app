import 'dart:ui';
import 'package:e7gz/src/imports/imports.dart';

class PitchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final dynamic pitch;
  final double expandedHeight;
  final double collapsedHeight;
  final double topPadding;
  final String? heroTag;

  PitchHeaderDelegate({
    required this.pitch,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.topPadding,
    this.heroTag,
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
    final double imageScale = 1.0 + (percent * 0.1);

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: imageScale,
          child: Hero(
            tag: heroTag ?? 'pitch_image_${pitch.id}',

            child: pitch.images.isNotEmpty
                ? ImagePageView(images: pitch.images, opacity: 1.0 - percent)
                : const AppCachedImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: pc.heroGradient),
          ),
        ),
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
        Positioned(
          bottom: -1,
          left: 0,
          right: 0,
          child: Container(
            height: 32.h,
            decoration: BoxDecoration(
              color: context.colors.surface,
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
        Positioned(
          top: topPadding + 8,
          left: 16.w,
          child: CircleActionButton(
            icon: Icons.arrow_back_ios_new_outlined,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: topPadding + 8,
          right: 16.w,
          child: Row(
            children: [
              CircleActionButton(
                icon: IconsaxPlusLinear.share,
                onPressed: () {},
              ),
              CircleActionButton(
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
  bool shouldRebuild(covariant PitchHeaderDelegate oldDelegate) => true;
}

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
                  AppCachedImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ),
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
            bottom: 180.h,
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
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: widget.images.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 4.5.h,
                      dotWidth: 4.5.w,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withValues(alpha: 0.5),
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

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const CircleActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
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
