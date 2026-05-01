import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AdminBookingsTab extends StatelessWidget {
  final AdminRemoteDataSource dataSource;

  const AdminBookingsTab({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bookings',
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
              future: dataSource.getMyBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF4BE277)));
                }
                
                final bookings = snapshot.data ?? [];
                
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
                          DataColumn(label: Text('CUSTOMER')),
                          DataColumn(label: Text('PITCH')),
                          DataColumn(label: Text('DATE')),
                          DataColumn(label: Text('TIME')),
                          DataColumn(label: Text('STATUS')),
                        ],
                        rows: bookings.map((booking) {
                          return DataRow(cells: [
                            DataCell(Text(booking['user']?['name'] ?? 'Guest')),
                            DataCell(Text(booking['pitch']?['name'] ?? 'Premium')),
                            DataCell(Text(booking['date'] ?? 'May 12')),
                            DataCell(Text('${booking['startTime']} - ${booking['endTime']}')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4BE277).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (booking['status'] ?? 'Confirmed').toString().toUpperCase(),
                                  style: const TextStyle(color: Color(0xFF4BE277), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
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
