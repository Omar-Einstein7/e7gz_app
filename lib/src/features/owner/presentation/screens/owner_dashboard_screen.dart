import 'dart:typed_data';
import 'package:e7gz/src/features/auth/presentation/providers/auth_bloc.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_bloc.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_state.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import 'package:image_picker/image_picker.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerCubit>().loadDashboardData();
    });
  }

  final List<_TabConfig> _tabs = const [
    _TabConfig('Home', IconsaxPlusBold.element_3, IconsaxPlusLinear.element_3),
    _TabConfig('Pitches', IconsaxPlusBold.ranking, IconsaxPlusLinear.ranking),
    _TabConfig('Revenue', IconsaxPlusBold.empty_wallet_tick, IconsaxPlusLinear.empty_wallet_tick),
    _TabConfig('Profile', IconsaxPlusBold.user, IconsaxPlusLinear.user),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0B1326) : Theme.of(context).colorScheme.surface;

    return BlocBuilder<OwnerCubit, OwnerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: _buildBody(context, state),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OwnerState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.brightness == Brightness.dark ? const Color(0xFF4BE277) : colorScheme.primary;
    final textColor = colorScheme.brightness == Brightness.dark ? const Color(0xFFBCC7DE) : colorScheme.onSurfaceVariant;

    // Global loading (first load, no data yet)
    if (state.status == OwnerStatus.loading && state.stats.isEmpty && state.myPitches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: primaryColor),
            SizedBox(height: 16.h),
            Text('Loading dashboard...', style: TextStyle(color: textColor)),
          ],
        ),
      );
    }

    switch (_currentTab) {
      case 0:
        return _HomeTab(state: state);
      case 1:
        return _PitchesTab(state: state);
      case 2:
        return _RevenueTab(state: state);
      case 3:
        return const _ProfileTab();
      default:
        return _HomeTab(state: state);
    }
  }

  Widget _buildBottomNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF131B2E) : Theme.of(context).colorScheme.surface;
    final selectedColor = isDark ? const Color(0xFF4BE277) : Theme.of(context).colorScheme.primary;
    final unselectedColor = isDark ? const Color(0xFFBCC7DE) : Theme.of(context).colorScheme.onSurfaceVariant;

    return BottomNavigationBar(
      currentIndex: _currentTab,
      onTap: (index) => setState(() => _currentTab = index),
      backgroundColor: bgColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.normal,
      ),
      items: List.generate(_tabs.length, (i) {
        final tab = _tabs[i];
        return BottomNavigationBarItem(
          icon: Icon(tab.inactiveIcon, size: 22),
          activeIcon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: selectedColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(tab.activeIcon, size: 22),
          ),
          label: tab.label,
        );
      }),
    );
  }
}

class _TabConfig {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  const _TabConfig(this.label, this.activeIcon, this.inactiveIcon);
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final OwnerState state;
  const _HomeTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      onRefresh: () => context.read<OwnerCubit>().loadDashboardData(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            floating: true,
            pinned: false,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text(
                  'e7gzz',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 22.sp,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(IconsaxPlusLinear.notification, color: colorScheme.onSurface),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Error banner
                if (state.status == OwnerStatus.failure && state.errorMessage != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error, size: 18),
                        SizedBox(width: 8.w),
                        Expanded(child: Text(state.errorMessage!, style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 13))),
                        TextButton(
                          onPressed: () => context.read<OwnerCubit>().loadDashboardData(),
                          child: Text('RETRY', style: TextStyle(color: colorScheme.primary)),
                        ),
                      ],
                    ),
                  ),

                // Greeting
                Text(
                  'Welcome back,',
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14.sp),
                ),
                Text(
                  'Dashboard Overview',
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 24.sp, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 32.h),

                // Stats Cards
                const _SectionLabel('STATISTICS'),
                SizedBox(height: 12.h),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard('Total Revenue', _fmt(stats['totalRevenue']), 'EGP'),
                    _StatCard('Net Earnings', _fmt(stats['netEarnings']), 'EGP'),
                    _StatCard('Active Bookings', _fmt(stats['activeBookingsCount']), '', accent: false),
                    _StatCard('My Pitches', _fmt(stats['pitchesCount']), '', accent: false),
                  ],
                ),
                SizedBox(height: 32.h),

                // Recent pitches preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _SectionLabel('MY PITCHES'),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All', style: TextStyle(color: colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (state.status == OwnerStatus.loading)
                  Center(child: CircularProgressIndicator(color: colorScheme.primary))
                else if (state.myPitches.isEmpty)
                  _EmptyPitches(onAdd: () => context.push(AppRoutes.addPitch))
                else
                  ...state.myPitches.take(3).map((p) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _PitchCard(pitch: p),
                      )),
                SizedBox(height: 100.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(dynamic value) {
    if (value == null) return '0';
    if (value is double) return value.toStringAsFixed(0);
    return value.toString();
  }
}

// ─── Pitches Tab ──────────────────────────────────────────────────────────────

class _PitchesTab extends StatelessWidget {
  final OwnerState state;
  const _PitchesTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      onRefresh: () => context.read<OwnerCubit>().refreshPitches(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            floating: true,
            automaticallyImplyLeading: false,
            title: Text('My Pitches', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20.sp)),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: FilledButton.icon(
                  onPressed: () async {
                    await context.push(AppRoutes.addPitch);
                    if (context.mounted) context.read<OwnerCubit>().refreshPitches();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          if (state.status == OwnerStatus.loading && state.myPitches.isEmpty)
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
            )
          else if (state.myPitches.isEmpty)
            SliverFillRemaining(child: _EmptyPitches(onAdd: () => context.push(AppRoutes.addPitch)))
          else
            SliverPadding(
              padding: EdgeInsets.all(24.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _PitchCard(pitch: state.myPitches[i], showActions: true),
                  ),
                  childCount: state.myPitches.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Revenue Tab ──────────────────────────────────────────────────────────────

class _RevenueTab extends StatelessWidget {
  final OwnerState state;
  const _RevenueTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final total = (stats['totalRevenue'] as num?)?.toDouble() ?? 0;
    final commission = (stats['platformCommission'] as num?)?.toDouble() ?? 0;
    final net = (stats['netEarnings'] as num?)?.toDouble() ?? 0;
    final monthly = (stats['monthlyRevenue'] as num?)?.toDouble() ?? 0;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return RefreshIndicator(
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      onRefresh: () => context.read<OwnerCubit>().loadDashboardData(),
      child: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          Text('Revenue', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 24.sp)),
          SizedBox(height: 8.h),
          Text('Financial overview of your pitches', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13.sp)),
          SizedBox(height: 32.h),

          // Big revenue card
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [const Color(0xFF1A2E1A), const Color(0xFF0F1F0F)]
                  : [colorScheme.primaryContainer, colorScheme.surfaceContainerHigh],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Lifetime Revenue', style: TextStyle(color: isDark ? const Color(0xFFBCC7DE) : colorScheme.onSurfaceVariant, fontSize: 12.sp)),
                SizedBox(height: 8.h),
                Text(
                  '${total.toStringAsFixed(0)} EGP',
                  style: TextStyle(color: isDark ? const Color(0xFF4BE277) : colorScheme.primary, fontSize: 36.sp, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _MiniStat('This Month', '${monthly.toStringAsFixed(0)} EGP', isDark: isDark),
                    SizedBox(width: 24.w),
                    _MiniStat('Commission', '${commission.toStringAsFixed(0)} EGP', isDark: isDark),
                    SizedBox(width: 24.w),
                    _MiniStat('Net Payout', '${net.toStringAsFixed(0)} EGP', isDark: isDark),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          if (state.status == OwnerStatus.loading)
            Center(child: CircularProgressIndicator(color: colorScheme.primary))
          else if (total == 0)
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  'No revenue yet.\nBookings will appear here once confirmed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

// ─── Profile Tab ──────────────────────────────────────────────────────────────

class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  Uint8List? _localPhotoBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, sessionState) {
        final user = sessionState.user;
        return ListView(
          padding: EdgeInsets.all(24.w),
          children: [
            Text('Profile', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 24.sp)),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null && context.mounted) {
                        final bytes = await image.readAsBytes();
                        setState(() => _localPhotoBytes = bytes);
                        context.read<AuthBloc>().add(UpdateProfileRequested(photoPath: image.path));
                      }
                    },
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: authState.isLoading
                                    ? Center(child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2))
                                    : _localPhotoBytes != null
                                        ? Image.memory(
                                            _localPhotoBytes!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(IconsaxPlusBold.user, color: colorScheme.onPrimary, size: 36),
                                          )
                                        : (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                                            ? CachedNetworkImage(
                                                imageUrl: '${user.photoUrl!}?v=${DateTime.now().millisecondsSinceEpoch}',
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2)),
                                                errorWidget: (context, url, error) => Icon(IconsaxPlusBold.user, color: colorScheme.onPrimary, size: 36),
                                              )
                                            : Icon(IconsaxPlusBold.user, color: colorScheme.onPrimary, size: 36),
                              ),
                            ),
                            if (!authState.isLoading)
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                                child: Icon(Icons.camera_alt, color: colorScheme.onPrimary, size: 14),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user?.name ?? 'Pitch Owner',
                    style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      user?.role?.toUpperCase() ?? 'OWNER',
                      style: TextStyle(color: colorScheme.primary, fontSize: 11.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _ProfileAction(icon: IconsaxPlusLinear.add_circle, label: 'Add New Pitch', onTap: () => context.push(AppRoutes.addPitch)),
            _ProfileAction(icon: IconsaxPlusLinear.notification, label: 'Notifications', onTap: () => context.push(AppRoutes.notifications)),
            
            // Theme Toggle
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark = mode == ThemeMode.dark || (mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
                return _ProfileAction(
                  icon: isDark ? IconsaxPlusLinear.sun_1 : IconsaxPlusLinear.moon,
                  label: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  onTap: () => context.read<ThemeCubit>().setTheme(isDark ? ThemeMode.light : ThemeMode.dark),
                );
              },
            ),

            _ProfileAction(
              icon: IconsaxPlusLinear.logout,
              label: 'Log Out',
              isDestructive: true,
              onTap: () => context.read<SessionBloc>().add(const SessionLogoutRequested()),
            ),
            SizedBox(height: 100.h),
          ],
        );
      },
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11.sp, fontWeight: FontWeight.w900, letterSpacing: 1.5),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool accent;
  const _StatCard(this.label, this.value, this.unit, {this.accent = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Text(
            unit.isNotEmpty ? '$value $unit' : value,
            style: TextStyle(
              color: accent ? colorScheme.primary : colorScheme.onSurface,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchCard extends StatelessWidget {
  final Pitch pitch;
  final bool showActions;
  const _PitchCard({required this.pitch, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'pitch_${pitch.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                pitch.imageUrl.isNotEmpty
                    ? pitch.imageUrl
                    : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80.w,
                  height: 80.w,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.sports_soccer, color: colorScheme.primary, size: 32),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pitch.name,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(IconsaxPlusLinear.location, color: colorScheme.onSurfaceVariant, size: 14),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        pitch.location.city,
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${pitch.pricePerHour.toInt()} EGP/hr',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showActions)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(IconsaxPlusLinear.edit, color: colorScheme.primary, size: 20),
                  onPressed: () {
                    context.push(AppRoutes.addPitch, extra: pitch);
                  },
                  tooltip: 'Edit Pitch',
                ),
                IconButton(
                  icon: const Icon(IconsaxPlusLinear.trash, color: Colors.redAccent, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: colorScheme.surface,
                        title: Text('Delete Pitch', style: TextStyle(color: colorScheme.onSurface)),
                        content: Text('Are you sure you want to delete this pitch?', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<OwnerCubit>().deletePitch(pitch.id);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Delete Pitch',
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _EmptyPitches extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyPitches({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, shape: BoxShape.circle),
            child: Icon(Icons.stadium_outlined, color: colorScheme.primary, size: 48),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Pitches Yet',
            style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text('Add your first pitch to get started', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          SizedBox(height: 24.h),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Pitch'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _MiniStat(this.label, this.value, {this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isDark ? const Color(0xFFBCC7DE) : colorScheme.onSurfaceVariant, fontSize: 10.sp)),
        Text(
          value,
          style: TextStyle(color: isDark ? Colors.white : colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _ProfileAction({required this.icon, required this.label, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? Colors.red : colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 20),
        title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5), size: 18),
        onTap: onTap,
      ),
    );
  }
}
