import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:flutter/material.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';

class AdminMatchesTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminMatchesTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Matches', style: AdminTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text(
            'All open & completed matches',
            style: AdminTextStyles.label,
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<dynamic>>(
            future: dataSource.getAllMatches(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }
              final matches = snapshot.data ?? [];
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
                  final players = m['players']?.length ?? 0;
                  final max = m['maxPlayers'] ?? 10;
                  final isFull = players >= max;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          m['title'] ?? 'Friendly Match',
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          (m['sportType'] ?? 'Football')
                              .toString()
                              .toUpperCase(),
                        ),
                      ),
                      DataCell(Text('$players / $max')),
                      DataCell(Text('EGP ${m['pricePerPlayer'] ?? '0'}')),
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
