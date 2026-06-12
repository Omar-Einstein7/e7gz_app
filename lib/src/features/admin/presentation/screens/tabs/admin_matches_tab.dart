import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_state.dart';

class AdminMatchesTab extends StatefulWidget {
  const AdminMatchesTab({super.key});

  @override
  State<AdminMatchesTab> createState() => _AdminMatchesTabState();
}

class _AdminMatchesTabState extends State<AdminMatchesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadAllMatches();
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
          Text('Matches', style: AdminTextStyles.getPageTitle(context)),
          const SizedBox(height: 4),
          Text(
            'All open & completed matches',
            style: AdminTextStyles.getLabel(context),
          ),
          const SizedBox(height: 24),
          BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state.matchesStatus == AdminStatus.loading ||
                  state.matchesStatus == AdminStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }

              if (state.matchesStatus == AdminStatus.failure) {
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
                        'Failed to load matches: ${state.matchesError}',
                        style: TextStyle(
                          color: AdminColors.getTextSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            context.read<AdminCubit>().loadAllMatches(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final matches = state.matches;
              return AdminDataTable(
                title: 'All Matches',
                columns: const [
                  DataColumn(label: Text('TITLE')),
                  DataColumn(label: Text('SPORT')),
                  DataColumn(label: Text('PLAYERS')),
                  DataColumn(label: Text('FEE / PLAYER')),
                  DataColumn(label: Text('STATUS')),
                ],
                rows: matches.map((m) {
                  final players = m.participantIds.length;
                  final max = m.maxPlayers;
                  final isFull = m.isFull;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          m.title.isEmpty ? 'Friendly Match' : m.title,
                          style: TextStyle(
                            color: AdminColors.getTextPrimary(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(Text(m.sportType.toUpperCase())),
                      DataCell(Text('$players / $max')),
                      DataCell(Text('EGP ${m.pricePerPlayer}')),
                      DataCell(
                        StatusChip(
                          label: isFull ? 'FULL' : 'OPEN',
                          color: isFull
                              ? AdminColors.accentAmber
                              : AdminColors.accent,
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
