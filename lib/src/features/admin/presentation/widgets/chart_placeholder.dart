import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

/// Placeholder bar chart (no external charting package required)
class ChartPlaceholder extends StatelessWidget {
  final String title;
  final List<_BarData> bars;

  const ChartPlaceholder({
    super.key,
    required this.title,
    this.bars = const [
      _BarData('Mon', 0.6),
      _BarData('Tue', 0.9),
      _BarData('Wed', 0.5),
      _BarData('Thu', 0.75),
      _BarData('Fri', 0.95),
      _BarData('Sat', 0.45),
      _BarData('Sun', 0.3),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AdminTextStyles.sectionTitle),
          const SizedBox(height: 4),
          const Text('Last 7 days', style: AdminTextStyles.label),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (b) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _AnimatedBar(fraction: b.fraction),
                            const SizedBox(height: 6),
                            Text(
                              b.label,
                              style: const TextStyle(
                                color: AdminColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final double fraction; // 0..1
  const _BarData(this.label, this.fraction);
}

class _AnimatedBar extends StatefulWidget {
  final double fraction;
  const _AnimatedBar({required this.fraction});

  @override
  State<_AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Container(
          height: 96 * widget.fraction * _anim.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AdminColors.accent.withOpacity(0.9),
                AdminColors.accent.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }
}
