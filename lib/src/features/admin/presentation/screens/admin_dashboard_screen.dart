import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';
import 'tabs/admin_dashboard_tab.dart';
import 'tabs/admin_pitches_tab.dart';
import 'tabs/admin_bookings_tab.dart';
import 'tabs/admin_matches_tab.dart';
import 'tabs/admin_notifications_tab.dart';
import 'tabs/admin_profile_tab.dart';
import '../../../../di/injection_container.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminRemoteDataSource _dataSource = sl<AdminRemoteDataSource>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      selectedIndex: _selectedIndex,
      onIndexChanged: (index) {
        setState(() => _selectedIndex = index);
        _pageController.jumpToPage(index);
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AdminDashboardTab(dataSource: _dataSource),
          AdminPitchesTab(dataSource: _dataSource),
          AdminBookingsTab(dataSource: _dataSource),
          AdminMatchesTab(dataSource: _dataSource),
          AdminNotificationsTab(dataSource: _dataSource),
          AdminProfileTab(dataSource: _dataSource),
        ],
      ),
    );
  }
}
