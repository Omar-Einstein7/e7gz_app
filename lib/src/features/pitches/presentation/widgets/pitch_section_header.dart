import 'package:e7gz/src/imports/imports.dart';

class PitchSectionHeader extends StatelessWidget {
  final String title;
  const PitchSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final pc = context.pitchColors;
    return Text(
      title.tr().toUpperCase(),
      style: context.typography.labelSmall?.copyWith(
        color: pc.accentGreen,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );
  }
}
