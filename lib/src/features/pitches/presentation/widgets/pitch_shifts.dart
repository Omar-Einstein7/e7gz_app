import 'package:e7gz/src/imports/imports.dart';
import '../widgets/widgets.dart';

class PitchShiftsSection extends StatelessWidget {
  final dynamic pitch;
  const PitchShiftsSection({super.key, required this.pitch});

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
    final morningPrice = pitch.morningPrice.toInt().toString();
    final nightPrice = pitch.nightPrice.toInt().toString();

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
        const PitchSectionHeader(title: 'pitch_details.shifts_title'),
        SizedBox(height: 20.h),
        if (showMorning) ...[
          ShiftCard(
            title: 'pitch_details.sunlight_play'.tr(),
            subtitle: 'pitch_details.morning_shift'.tr().toUpperCase(),
            price: morningPrice,
            timeRange: '$opening12 - 04:00 PM',
            icon: IconsaxPlusLinear.sun_1,
          ),
          SizedBox(height: 16.h),
        ],
        ShiftCard(
          title: 'pitch_details.under_lights'.tr(),
          subtitle: 'pitch_details.evening_shift'.tr().toUpperCase(),
          price: nightPrice,
          timeRange: '${showMorning ? '04:00 PM' : opening12} - $closing12',
          icon: IconsaxPlusLinear.moon,
          isSelected: true,
        ),
      ],
    );
  }
}
