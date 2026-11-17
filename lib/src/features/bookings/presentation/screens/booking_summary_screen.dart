import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/core/di/injection_container.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String pitchId;
  final String date;
  final String time;

  const BookingSummaryScreen({
    super.key,
    required this.pitchId,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PitchDetailCubit>()..loadPitch(pitchId),
      child: _BookingSummaryView(date: date, time: time),
    );
  }
}

class _BookingSummaryView extends StatelessWidget {
  final String date;
  final String time;

  const _BookingSummaryView({required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'bookings.review_title'.tr(),
          style: typography.titleLarge?.copyWith(color: colors.onSurface),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if (state.status == PitchDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PitchDetailStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'bookings.failed_load'.tr(),
                style: typography.bodyMedium?.copyWith(color: colors.error),
              ),
            );
          }

          final pitch = state.pitch;
          if (pitch == null) {
            return Center(
              child: Text(
                'bookings.pitch_not_found'.tr(),
                style: typography.bodyMedium?.copyWith(color: colors.onSurface),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPitchCard(pitch, typography, colors),
                SizedBox(height: 32.h),
                _buildSectionTitle('bookings.details_title'.tr(), typography, colors),
                SizedBox(height: 16.h),
                _buildDetailTile(
                  'bookings.date'.tr(),
                  date,
                  Icons.calendar_today,
                  colors,
                  typography,
                ),
                _buildDetailTile(
                  'bookings.time'.tr(),
                  time,
                  Icons.access_time,
                  colors,
                  typography,
                ),
                _buildDetailTile(
                  'bookings.duration'.tr(),
                  'bookings.duration_value'.tr(),
                  Icons.timer,
                  colors,
                  typography,
                ),
                SizedBox(height: 32.h),
                _buildSectionTitle('bookings.payment_summary'.tr(), typography, colors),
                SizedBox(height: 16.h),
                _buildPriceRow(
                  'bookings.court_price'.tr(),
                  '${pitch.pricePerHour} ${'pitch_details.egp'.tr()}',
                  typography,
                  colors,
                ),
                _buildPriceRow(
                  'bookings.service_fee'.tr(),
                  '20 ${'pitch_details.egp'.tr()}',
                  typography,
                  colors,
                ),
                Divider(color: colors.outlineVariant),
                _buildPriceRow(
                  'bookings.total_amount'.tr(),
                  '${pitch.pricePerHour + 20} ${'pitch_details.egp'.tr()}',
                  typography,
                  colors,
                  isTotal: true,
                ),
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<PitchDetailCubit, PitchDetailState>(
        builder: (context, state) {
          if (state.pitch == null) return const SizedBox.shrink();
          return Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              border: Border(
                top: BorderSide(color: colors.outlineVariant),
              ),
            ),
            child: AppButton(
              label: 'bookings.proceed_payment'.tr(),
              onPressed: () => context.push(
                AppRoutes.paymentCheckout,
                extra: {
                  'pitchName': state.pitch!.name,
                  'pitchImage': state.pitch!.imageUrl,
                  'amount': state.pitch!.pricePerHour + 20,
                  'bookingDetails': '$date at $time',
                },
              ),
              isFullWidth: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPitchCard(Pitch pitch, TextTheme typography, ColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          AppCachedImage(
            imageUrl: pitch.imageUrl.isNotEmpty
                ? pitch.imageUrl
                : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
            width: 80.w,
            height: 80.w,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pitch.name,
                  style: typography.titleMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pitch.location.city,
                  style: typography.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme typography, ColorScheme colors) {
    return Text(
      title,
      style: typography.titleLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailTile(
    String label,
    String value,
    IconData icon,
    ColorScheme colors,
    TextTheme typography,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          SizedBox(width: 16.w),
          Text(
            label,
            style: typography.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: typography.bodyMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String price,
    TextTheme typography,
    ColorScheme colors, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: typography.bodyMedium?.copyWith(
              color: isTotal ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: typography.titleLarge?.copyWith(
              color: isTotal ? colors.primary : colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
