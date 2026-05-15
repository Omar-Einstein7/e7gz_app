import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_data_table.dart';
import 'package:flutter/material.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AdminBookingsTab extends StatefulWidget {
  final AdminRemoteDataSource dataSource;

  const AdminBookingsTab({super.key, required this.dataSource});

  @override
  State<AdminBookingsTab> createState() => _AdminBookingsTabState();
}

class _AdminBookingsTabState extends State<AdminBookingsTab> with AutomaticKeepAliveClientMixin {
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = widget.dataSource.getMyBookings();
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
          const Text('Bookings', style: AdminTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text('Track all reservations', style: AdminTextStyles.label),
          const SizedBox(height: 24),
          FutureBuilder<List<dynamic>>(
            future: _bookingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }
              final bookings = snapshot.data ?? [];
              return AdminDataTable(
                title: 'All Bookings',
                columns: const [
                  DataColumn(label: Text('CUSTOMER')),
                  DataColumn(label: Text('PITCH')),
                  DataColumn(label: Text('DATE')),
                  DataColumn(label: Text('TIME')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('ACTIONS')),
                ],
                rows: bookings.map((b) {
                  final status = (b['status'] ?? 'CONFIRMED')
                      .toString()
                      .toUpperCase();
                  final statusColor = status == 'CANCELLED'
                      ? const Color(0xFFEF4444)
                      : status == 'PENDING'
                      ? AdminColors.accentAmber
                      : AdminColors.accent;

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          b['user']?['name'] ?? 'Guest',
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(Text(b['pitch']?['name'] ?? '—')),
                      DataCell(Text(b['date'] ?? '—')),
                      DataCell(
                        Text(
                          '${b['startTime'] ?? '—'} – ${b['endTime'] ?? '—'}',
                        ),
                      ),
                      DataCell(StatusChip(label: status, color: statusColor)),
                      DataCell(
                        IconButton(
                          icon: const Icon(
                            IconsaxPlusLinear.location,
                            color: AdminColors.accent,
                            size: 20,
                          ),
                          onPressed: () => _viewLocation(context, b['pitch']),
                          tooltip: 'View Pitch Location',
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

  void _viewLocation(BuildContext context, dynamic pitch) {
    if (pitch == null || pitch['location'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No location found for this pitch')),
      );
      return;
    }

    final coords = pitch['location']['coordinates']['coordinates'];
    if (coords == null || coords.length < 2) return;

    final latLng = LatLng(coords[1].toDouble(), coords[0].toDouble());

    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AdminColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    IconsaxPlusBold.location,
                    color: AdminColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    pitch['name'] ?? 'Pitch Location',
                    style: AdminTextStyles.pageTitle.copyWith(fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 350,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                child: FlutterMap(
                  options: MapOptions(initialCenter: latLng, initialZoom: 15),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.e7gz.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: latLng,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
