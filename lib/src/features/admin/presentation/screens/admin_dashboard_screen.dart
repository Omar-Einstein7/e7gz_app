import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:e7gz/src/features/admin/presentation/screens/tabs/admin_dashboard_tab.dart';
import 'package:e7gz/src/features/admin/presentation/screens/tabs/admin_pitches_tab.dart';
import 'package:e7gz/src/features/admin/presentation/screens/tabs/admin_bookings_tab.dart';
import 'package:e7gz/src/features/admin/presentation/screens/tabs/admin_matches_tab.dart';
import 'package:e7gz/src/features/admin/presentation/screens/tabs/admin_notifications_tab.dart';
import 'package:e7gz/src/features/admin/presentation/screens/tabs/admin_profile_tab.dart';
import 'package:e7gz/src/di/injection_container.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminCubit>(
      create: (_) => sl<AdminCubit>(),
      child: Builder(
        builder: (context) {
          return AdminLayout(
            selectedIndex: _selectedIndex,
            onIndexChanged: (index) {
              setState(() => _selectedIndex = index);
              _pageController.jumpToPage(index);
            },
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                AdminDashboardTab(),
                AdminPitchesTab(),
                AdminBookingsTab(),
                AdminMatchesTab(),
                AdminNotificationsTab(),
                AdminProfileTab(),
              ],
            ),
          );
        },
      ),
    );
  }
}
