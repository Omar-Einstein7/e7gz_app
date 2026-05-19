import 'package:e7gz/src/imports/imports.dart';
import '../widgets/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PitchReviewsSection extends StatelessWidget {
  final dynamic pitch;
  const PitchReviewsSection({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PitchSectionHeader(title: 'pitch_details.reviews_title'),
            TextButton.icon(
              onPressed: () => _showRatingDialog(context),
              icon: Icon(
                IconsaxPlusBold.edit,
                size: 16.sp,
                color: colors.primary,
              ),
              label: Text(
                'pitch_details.rate_pitch'.tr(),
                style: typography.labelLarge?.copyWith(color: colors.primary),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        if (pitch.rating == 0)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
            child: Text(
              'pitch_details.no_reviews'.tr(),
              style: typography.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(AppSpacing.md.w),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
            ),
            child: Row(
              children: [
                Text(
                  pitch.rating.toStringAsFixed(1),
                  style: typography.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBarIndicator(
                      rating: pitch.rating.toDouble(),
                      itemBuilder: (context, index) =>
                          Icon(Icons.star_rounded, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 20.sp,
                      direction: Axis.horizontal,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Based on community ratings',
                      style: typography.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showRatingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _RatingBottomSheet(),
    );
  }
}

class _RatingBottomSheet extends StatefulWidget {
  const _RatingBottomSheet();

  @override
  State<_RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<_RatingBottomSheet> {
  double _rating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg.w,
        right: AppSpacing.lg.w,
        top: AppSpacing.lg.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.outlineVariant,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: AppSpacing.xl.h),
          Text(
            'How was your experience?',
            style: typography.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSpacing.md.h),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
            itemBuilder: (context, _) =>
                Icon(Icons.star_rounded, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: AppSpacing.xl.h),
          AppTextField(
            controller: _controller,
            hint: 'Write your thoughts (optional)',
            maxLines: 3,
          ),
          SizedBox(height: AppSpacing.xl.h),
          AppButton(
            label: 'Submit Review',
            isFullWidth: true,
            onPressed: _rating == 0
                ? null
                : () {
                    context.showSuccessSnackBar('Thank you for your review!');
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }
}
