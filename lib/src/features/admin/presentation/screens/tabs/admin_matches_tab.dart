import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AdminMatchesTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminMatchesTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Matches',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: FutureBuilder<List<dynamic>>(
              future: dataSource.getAllMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF4BE277)));
                }
                
                final matches = snapshot.data ?? [];
                
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 350.w),
                      child: DataTable(
                        headingTextStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
                        dataTextStyle: const TextStyle(color: Colors.white70),
                        columns: const [
                          DataColumn(label: Text('TITLE')),
                          DataColumn(label: Text('PLAYERS')),
                          DataColumn(label: Text('SPORT')),
                          DataColumn(label: Text('FEE')),
                        ],
                        rows: matches.map((match) {
                          return DataRow(cells: [
                            DataCell(Text(match['title'] ?? 'Friendly Match')),
                            DataCell(Text('${match['players']?.length ?? 0}/${match['maxPlayers'] ?? 10}')),
                            DataCell(Text(match['sportType']?.toString().toUpperCase() ?? 'FOOTBALL')),
                            DataCell(Text('EGP ${match['pricePerPlayer'] ?? 0}')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
