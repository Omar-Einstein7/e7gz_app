import 'package:flutter/material.dart';
import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive scaling based on card width. Tighter clamp to prevent height overflow.
          final isCompact = constraints.maxWidth < 180;
          final double baseScale = isCompact
              ? 0.8
              : (constraints.maxWidth / 280).clamp(0.85, 1.05);

          return Row(
            children: [
              // Icon container
              Container(
                width: 48 * baseScale,
                height: 48 * baseScale,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12 * baseScale),
                ),
                child: Icon(icon, color: color, size: 24 * baseScale),
              ),
              SizedBox(width: 16 * baseScale),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          color: AdminColors.getTextSecondary(context),
                          fontSize: 13 * baseScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4 * baseScale),
                      Text(
                        value,
                        maxLines: 1,
                        style: TextStyle(
                          color: AdminColors.getTextPrimary(context),
                          fontSize: 20 * baseScale,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2 * baseScale),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          style: TextStyle(
                            color: AdminColors.accentBlue,
                            fontSize: 12 * baseScale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Top-right accent line
              Container(
                width: 3 * baseScale,
                height: 40 * baseScale,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
