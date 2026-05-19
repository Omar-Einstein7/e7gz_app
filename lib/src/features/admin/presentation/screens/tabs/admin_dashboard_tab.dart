import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/chart_placeholder.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../cubit/admin_cubit.dart';
import '../../cubit/admin_state.dart';

class AdminDashboardTab extends StatefulWidget {
  const AdminDashboardTab({super.key});

  @override
  State<AdminDashboardTab> createState() => _AdminDashboardTabState();
}

class _AdminDashboardTabState extends State<AdminDashboardTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadDashboardStats();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state.statsStatus == AdminStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  IconsaxPlusBold.warning_2,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading dashboard: ${state.statsError}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AdminColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AdminCubit>().loadDashboardStats(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final stats = state.stats;
        final loading =
            state.statsStatus == AdminStatus.loading ||
            state.statsStatus == AdminStatus.initial;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stat Cards ────────────────────────────────────────
              LayoutBuilder(
                builder: (context, c) {
                  final cols = c.maxWidth > 900
                      ? 4
                      : (c.maxWidth > 560 ? 2 : 1);
                  return GridView.count(
                    crossAxisCount: cols,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: cols == 4 ? 2.4 : (cols == 2 ? 2.8 : 3.6),
                    children: [
                      StatCard(
                        title: 'Total Revenue',
                        value: loading
                            ? '—'
                            : 'EGP ${stats?.totalRevenue ?? '0'}',
                        subtitle: '+12% this month',
                        icon: IconsaxPlusBold.wallet_3,
                        color: AdminColors.accent,
                      ),
                      StatCard(
                        title: 'Bookings',
                        value: loading ? '—' : '${stats?.totalBookings ?? '0'}',
                        subtitle: '+8 today',
                        icon: IconsaxPlusBold.calendar_tick,
                        color: AdminColors.accentBlue,
                      ),
                      StatCard(
                        title: 'Pitches',
                        value: loading ? '—' : '${stats?.pitchCount ?? '0'}',
                        subtitle: '2 pending review',
                        icon: IconsaxPlusBold.location,
                        color: AdminColors.accentAmber,
                      ),
                      StatCard(
                        title: 'Total Users',
                        value: loading ? '—' : '${stats?.userCount ?? '0'}',
                        subtitle: '+24 this week',
                        icon: IconsaxPlusBold.user_square,
                        color: AdminColors.accentPurple,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // ── Middle row: Chart + Activity ─────────────────────
              LayoutBuilder(
                builder: (context, c) {
                  if (c.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: const ChartPlaceholder(
                            title: 'Bookings Overview',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _TopVenuesCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      const ChartPlaceholder(title: 'Bookings Overview'),
                      const SizedBox(height: 16),
                      _TopVenuesCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // ── Recent Activity ───────────────────────────────────
              _RecentActivityCard(),
            ],
          ),
        );
      },
    );
  }
}

// ── Top Venues ─────────────────────────────────────────────────────────────

class _TopVenuesCard extends StatelessWidget {
  static const _venues = [
    ('Wembley Field', '92%', 0.92),
    ('Champions Arena', '85%', 0.85),
    ('Elite Turf', '78%', 0.78),
    ('Star Ground', '61%', 0.61),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Venues', style: AdminTextStyles.sectionTitle),
          const SizedBox(height: 4),
          const Text('By occupancy rate', style: AdminTextStyles.label),
          const SizedBox(height: 20),
          ..._venues.map(
            (v) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        v.$1,
                        style: const TextStyle(
                          color: AdminColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        v.$2,
                        style: const TextStyle(
                          color: AdminColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: v.$3),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (_, val, __) => LinearProgressIndicator(
                        value: val,
                        backgroundColor: AdminColors.surfaceHigh,
                        valueColor: const AlwaysStoppedAnimation(
                          AdminColors.accent,
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent Activity ─────────────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  static const _activities = [
    (
      IconsaxPlusBold.location,
      AdminColors.accent,
      'New Pitch: Champions Arena',
      '2 min ago',
    ),
    (
      IconsaxPlusBold.ticket,
      AdminColors.accentBlue,
      'Booking: Ali Hassan — Wembley Field',
      '15 min ago',
    ),
    (
      IconsaxPlusBold.card,
      AdminColors.accentAmber,
      'Payment received: EGP 350',
      '1 hr ago',
    ),
    (
      IconsaxPlusBold.user_octagon,
      AdminColors.accentPurple,
      'New Match: 5v5 Football',
      '3 hr ago',
    ),
    (
      IconsaxPlusBold.user_add,
      AdminColors.accentBlue,
      'New user joined: Sara M.',
      '5 hr ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Activity', style: AdminTextStyles.sectionTitle),
          const SizedBox(height: 16),
          ..._activities.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: a.$2.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a.$1, color: a.$2, size: 16),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      a.$3,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    a.$4,
                    style: const TextStyle(
                      color: AdminColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

