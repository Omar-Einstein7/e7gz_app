import 'package:e7gz/src/imports/imports.dart';

import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';

class AdminPitchesTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminPitchesTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Venues',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.addPitch),
              icon: const Icon(IconsaxPlusBold.add, color: Colors.white),
              label: const Text('Add New', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4BE277)),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: FutureBuilder<List<dynamic>>(
              future: dataSource.getAllPitches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF4BE277)));
                }
                
                final pitches = snapshot.data ?? [];
                
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
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('CITY')),
                          DataColumn(label: Text('PRICE')),
                          DataColumn(label: Text('STATUS')),
                          DataColumn(label: Text('ACTIONS')),
                        ],
                        rows: pitches.map((pitch) {
                          return DataRow(cells: [
                            DataCell(Text(pitch['name'] ?? 'Unknown')),
                            DataCell(Text(pitch['location']?['city'] ?? 'Cairo')),
                            DataCell(Text('EGP ${pitch['pricePerHour']}')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Active', style: TextStyle(color: Colors.green, fontSize: 12)),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(icon: const Icon(IconsaxPlusBold.edit_2, size: 18, color: Colors.blue), onPressed: () {}),
                                  IconButton(icon: const Icon(IconsaxPlusBold.trash, size: 18, color: Colors.red), onPressed: () {}),
                                ],
                              ),
                            ),
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
