import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';
import 'package:e7gz/src/di/injection_container.dart';

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
          style: typography.titleLarge?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final pitch = state.pitch;
          if (pitch == null) {
            return Center(
              child: Text(
                'bookings.pitch_not_found'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPitchCard(pitch, typography),
                SizedBox(height: 32.h),
                _buildSectionTitle('bookings.details_title'.tr(), typography),
                SizedBox(height: 16.h),
                _buildDetailTile(
                  'bookings.date'.tr(),
                  date,
                  Icons.calendar_today,
                  colors,
                ),
                _buildDetailTile(
                  'bookings.time'.tr(),
                  time,
                  Icons.access_time,
                  colors,
                ),
                _buildDetailTile(
                  'bookings.duration'.tr(),
                  'bookings.duration_value'.tr(),
                  Icons.timer,
                  colors,
                ),
                SizedBox(height: 32.h),
                _buildSectionTitle('bookings.payment_summary'.tr(), typography),
                SizedBox(height: 16.h),
                _buildPriceRow(
                  'bookings.court_price'.tr(),
                  '${pitch.pricePerHour} ${'pitch_details.egp'.tr()}',
                  typography,
                ),
                _buildPriceRow(
                  'bookings.service_fee'.tr(),
                  '20 ${'pitch_details.egp'.tr()}',
                  typography,
                ),
                const Divider(color: Colors.white10),
                _buildPriceRow(
                  'bookings.total_amount'.tr(),
                  '${pitch.pricePerHour + 20} ${'pitch_details.egp'.tr()}',
                  typography,
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
              color: const Color(0xFF131B2E),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
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

  Widget _buildPitchCard(Pitch pitch, typography) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(24.r),
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
            borderRadius: BorderRadius.circular(16.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pitch.name,
                  style: typography.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pitch.location.city,
                  style: const TextStyle(color: Color(0xFFBCC7DE)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, typography) {
    return Text(
      title,
      style: typography.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailTile(
    String label,
    String value,
    IconData icon,
    ColorScheme colors,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          SizedBox(width: 16.w),
          Text(label, style: const TextStyle(color: Color(0xFFBCC7DE))),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
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
    typography, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.white : const Color(0xFFBCC7DE),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: typography.titleLarge?.copyWith(
              color: isTotal ? const Color(0xFF4BE277) : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
