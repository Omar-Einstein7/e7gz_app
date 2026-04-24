import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/shared/data/mock_data.dart';

class MatchDetailsScreen extends StatelessWidget {
  final String matchId;

  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final match = MockData.matches.firstWhere((m) => m.id == matchId);
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Match Details', style: typography.titleLarge?.copyWith(color: Colors.white)),
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
            // Match Image
            ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: Image.network(
                match.imageUrl,
                height: 250.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              match.title,
              style: typography.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF4BE277), size: 16),
                SizedBox(width: 8.w),
                Text(match.location, style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 32.h),
            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard('Kickoff', match.kickoffTime.toString().substring(11, 16), Icons.timer, colors),
                _infoCard('Slots', '${match.availableSlots}/${match.totalSlots}', Icons.group, colors),
                _infoCard('Price', '${match.pricePerPlayer} EGP', Icons.payments, colors),
              ],
            ),
            SizedBox(height: 48.h),
            Text(
              'Participants',
              style: typography.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            // Mock participants list
            ...List.generate(match.participantIds.length, (index) => _participantTile(index)),
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
          label: match.isFull ? 'Match Full' : 'Join This Match',
          onPressed: match.isFull ? null : () {},
          isFullWidth: true,
          variant: match.isFull ? ButtonVariant.secondary : ButtonVariant.primary,
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon, ColorScheme colors) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.primary, size: 24),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _participantTile(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20.r, backgroundColor: Colors.grey),
          SizedBox(width: 16.w),
          Text('Player ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.check_circle, color: Color(0xFF4BE277), size: 16),
        ],
      ),
    );
  }
}
