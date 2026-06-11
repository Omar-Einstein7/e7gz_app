import 'package:flutter/material.dart';
import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';

/// A styled DataTable wrapped in an AdminCard with a header row
class AdminDataTable extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final Widget? action;

  const AdminDataTable({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 14),
            child: Row(
              children: [
                Text(title, style: AdminTextStyles.sectionTitle),
                const Spacer(),
                ?action,
              ],
            ),
          ),
          const Divider(color: AdminColors.border, height: 1),
          // ── Table ─────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 42,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 52,
              headingTextStyle: const TextStyle(
                color: AdminColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
              dataTextStyle: const TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 13,
              ),
              dividerThickness: 0.6,
              columnSpacing: 24,
              horizontalMargin: 20,
              columns: columns,
              rows: rows,
            ),
          ),
        ],
      ),
    );
  }
}

/// A status chip (e.g., Active, Pending)
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Small icon action button
class TableIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const TableIconBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
