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
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(IconsaxPlusBold.warning_2, color: Colors.red, size: 40),
                      const SizedBox(height: 12),
                      Text('Failed to load pitches: ${snapshot.error}', style: const TextStyle(color: AdminColors.textSecondary)),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => setState(() {
                          _pitchesFuture = widget.dataSource.getAllPitches();
                        }),
                        child: const Text('Retry'),
                      ),
                    ],
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
                              onTap: () async {
                                final result = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (_) => AdminAddPitchScreen(pitchData: p),
                                  ),
                                );
                                if (result == true && context.mounted) {
                                  setState(() {
                                    _pitchesFuture = widget.dataSource.getAllPitches();
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 6),
                            TableIconBtn(
                              icon: IconsaxPlusBold.trash,
                              color: const Color(0xFFEF4444),
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    backgroundColor: AdminColors.surface,
                                    title: const Text('Delete Pitch?', style: TextStyle(color: AdminColors.textPrimary)),
                                    content: const Text('Are you sure you want to delete this pitch?', style: TextStyle(color: AdminColors.textSecondary)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel', style: TextStyle(color: AdminColors.textSecondary))),
                                      TextButton(
                                        onPressed: () => Navigator.pop(c, true), 
                                        child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  final id = p['_id'] ?? p['id'];
                                  if (id != null) {
                                    final success = await widget.dataSource.deletePitch(id);
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pitch deleted successfully'), backgroundColor: AdminColors.accent));
                                      setState(() {
                                        _pitchesFuture = widget.dataSource.getAllPitches();
                                      });
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete pitch'), backgroundColor: Colors.redAccent));
                                    }
                                  }
                                }
                              },
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
