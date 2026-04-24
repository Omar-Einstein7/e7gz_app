import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/shared/data/mock_data.dart';

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
    final pitch = MockData.pitches.firstWhere((p) => p.id == pitchId);
    final typography = context.typography;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Review Booking', style: typography.titleLarge?.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPitchCard(pitch, typography),
            SizedBox(height: 32.h),
            _buildSectionTitle('Booking Details', typography),
            SizedBox(height: 16.h),
            _buildDetailTile('Date', date, Icons.calendar_today, colors),
            _buildDetailTile('Time', time, Icons.access_time, colors),
            _buildDetailTile('Duration', '60 Minutes', Icons.timer, colors),
            SizedBox(height: 32.h),
            _buildSectionTitle('Payment Summary', typography),
            SizedBox(height: 16.h),
            _buildPriceRow('Court Price', '${pitch.pricePerHour} EGP', typography),
            _buildPriceRow('Service Fee', '20 EGP', typography),
            const Divider(color: Colors.white10),
            _buildPriceRow('Total Amount', '${pitch.pricePerHour + 20} EGP', typography, isTotal: true),
            SizedBox(height: 100.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
        ),
        child: AppButton(
          label: 'Proceed to Payment',
          onPressed: () => context.push(AppRoutes.paymentCheckout),
          isFullWidth: true,
        ),
      ),
    );
  }

  Widget _buildPitchCard(pitch, typography) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(pitch.imageUrl, width: 80.w, height: 80.w, fit: BoxFit.cover),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pitch.name, style: typography.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(pitch.location, style: const TextStyle(color: Color(0xFFBCC7DE))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, typography) {
    return Text(title, style: typography.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold));
  }

  Widget _buildDetailTile(String label, String value, IconData icon, ColorScheme colors) {
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
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, typography, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : const Color(0xFFBCC7DE), fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(price, style: typography.titleLarge?.copyWith(color: isTotal ? const Color(0xFF4BE277) : Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
