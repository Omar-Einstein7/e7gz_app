import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:e7gz/src/imports/imports.dart';
import '../add_pitch_screen.dart';
import '../../cubit/admin_cubit.dart';
import '../../cubit/admin_state.dart';

class AdminPitchesTab extends StatefulWidget {
  const AdminPitchesTab({super.key});

  @override
  State<AdminPitchesTab> createState() => _AdminPitchesTabState();
}

class _AdminPitchesTabState extends State<AdminPitchesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadAllPitches();
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
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute<bool>(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AdminCubit>(),
                        child: const AdminAddPitchScreen(),
                      ),
                    ),
                  );
                  if (result == true && mounted) {
                    context.read<AdminCubit>().loadAllPitches();
                  }
                },
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
          BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state.pitchesStatus == AdminStatus.loading ||
                  state.pitchesStatus == AdminStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }

              if (state.pitchesStatus == AdminStatus.failure) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(
                        IconsaxPlusBold.warning_2,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load pitches: ${state.pitchesError}',
                        style: const TextStyle(
                          color: AdminColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            context.read<AdminCubit>().loadAllPitches(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final pitches = state.pitches;
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
                          p.name,
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(Text(p.location.city)),
                      DataCell(Text('EGP ${p.pricePerHour}')),
                      const DataCell(
                        StatusChip(label: 'Active', color: AdminColors.accent),
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
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<AdminCubit>(),
                                      child: AdminAddPitchScreen(pitch: p),
                                    ),
                                  ),
                                );
                                if (result == true && mounted) {
                                  context.read<AdminCubit>().loadAllPitches();
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
                                    title: const Text(
                                      'Delete Pitch?',
                                      style: TextStyle(
                                        color: AdminColors.textPrimary,
                                      ),
                                    ),
                                    content: const Text(
                                      'Are you sure you want to delete this pitch?',
                                      style: TextStyle(
                                        color: AdminColors.textSecondary,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(c, false),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: AdminColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(c, true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true && mounted) {
                                  context.read<AdminCubit>().deletePitch(p.id);
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

