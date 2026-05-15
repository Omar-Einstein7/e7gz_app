import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:e7gz/src/imports/imports.dart';
import '../add_pitch_screen.dart';

class AdminPitchesTab extends StatefulWidget {
  final AdminRemoteDataSource dataSource;

  const AdminPitchesTab({super.key, required this.dataSource});

  @override
  State<AdminPitchesTab> createState() => _AdminPitchesTabState();
}

class _AdminPitchesTabState extends State<AdminPitchesTab> with AutomaticKeepAliveClientMixin {
  late Future<List<dynamic>> _pitchesFuture;

  @override
  void initState() {
    super.initState();
    _pitchesFuture = widget.dataSource.getAllPitches();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ────────────────────────────────────────
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pitches', style: AdminTextStyles.pageTitle),
                  SizedBox(height: 2),
                  Text('Manage all venues', style: AdminTextStyles.label),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminAddPitchScreen(),
                  ),
                ),
                icon: const Icon(IconsaxPlusBold.add, size: 16),
                label: const Text('Add Pitch'),
                style: FilledButton.styleFrom(
                  backgroundColor: AdminColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // ── Table ─────────────────────────────────────────────
          FutureBuilder<List<dynamic>>(
            future: _pitchesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }
              final pitches = snapshot.data ?? [];
              return AdminDataTable(
                title: 'All Pitches',
                columns: const [
                  DataColumn(label: Text('VENUE')),
                  DataColumn(label: Text('CITY')),
                  DataColumn(label: Text('PRICE / HR')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('ACTIONS')),
                ],
                rows: pitches.map((p) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          p['name'] ?? 'Unknown',
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(Text(p['location']?['city'] ?? 'Cairo')),
                      DataCell(Text('EGP ${p['pricePerHour'] ?? '—'}')),
                      DataCell(
                        const StatusChip(
                          label: 'Active',
                          color: AdminColors.accent,
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            TableIconBtn(
                              icon: IconsaxPlusBold.edit_2,
                              color: AdminColors.accentBlue,
                              onTap: () {},
                            ),
                            const SizedBox(width: 6),
                            TableIconBtn(
                              icon: IconsaxPlusBold.trash,
                              color: const Color(0xFFEF4444),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
