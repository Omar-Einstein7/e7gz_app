import 'dart:ui';
import 'dart:typed_data';
import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
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
    _TabConfig(
      'Revenue',
      IconsaxPlusBold.empty_wallet_tick,
      IconsaxPlusLinear.empty_wallet_tick,
    ),
    _TabConfig('Profile', IconsaxPlusBold.user, IconsaxPlusLinear.user),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<OwnerCubit, OwnerState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(child: _buildBody(context, state)),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OwnerState state) {
    final colors = context.colors;
    final tt = context.typography;

    // Global loading (first load, no data yet)
    if (state.status == OwnerStatus.loading &&
        state.stats.isEmpty &&
        state.myPitches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.primary),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'Loading dashboard...',
              style: tt.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
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
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding > 0 ? bottomPadding : AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.outlineVariant, width: 1)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: AppSpacing.sm.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                return Expanded(
                  child: _OwnerNavItem(
                    label: tab.label,
                    icon: tab.inactiveIcon,
                    activeIcon: tab.activeIcon,
                    isSelected: _currentTab == index,
                    onTap: () => setState(() => _currentTab = index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _OwnerNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OwnerNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppRadius.bxxl.r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                  size: 24.sp,
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 200.ms,
                )
                .shimmer(
                  delay: 200.ms,
                  duration: 1000.ms,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
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
    final colors = context.colors;
    final tt = context.typography;

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<OwnerCubit>().loadDashboardData(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.background,
            floating: true,
            pinned: false,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Text(
                  'e7gzz',
                  style: tt.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    IconsaxPlusLinear.notification,
                    color: colors.onSurface,
                  ),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Error banner
                if (state.status == OwnerStatus.failure &&
                    state.errorMessage != null)
                  Container(
                    margin: EdgeInsets.only(bottom: AppSpacing.md.h),
                    padding: EdgeInsets.all(AppSpacing.md.w),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: AppRadius.blg.r,
                      border: Border.all(
                        color: colors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: colors.error, size: 18),
                        SizedBox(width: AppSpacing.xs.w),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: tt.bodySmall?.copyWith(
                              color: colors.onErrorContainer,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.read<OwnerCubit>().loadDashboardData(),
                          child: Text(
                            'RETRY',
                            style: TextStyle(color: colors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Greeting
                Text(
                  'Welcome back,',
                  style: tt.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                ),
                Text(
                  'Dashboard Overview',
                  style: tt.headlineMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),

                // Stats Cards
                const _SectionLabel('STATISTICS'),
                SizedBox(height: AppSpacing.sm.h),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md.h,
                  crossAxisSpacing: AppSpacing.md.w,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(
                      'Total Revenue',
                      _fmt(stats['totalRevenue']),
                      'EGP',
                    ),
                    _StatCard(
                      'Net Earnings',
                      _fmt(stats['netEarnings']),
                      'EGP',
                    ),
                    _StatCard(
                      'Active Bookings',
                      _fmt(stats['activeBookingsCount']),
                      '',
                      accent: false,
                    ),
                    _StatCard(
                      'My Pitches',
                      _fmt(stats['pitchesCount']),
                      '',
                      accent: false,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl.h),

                // Recent pitches preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _SectionLabel('MY PITCHES'),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm.h),
                if (state.status == OwnerStatus.loading)
                  Center(child: CircularProgressIndicator(color: colors.primary))
                else if (state.myPitches.isEmpty)
                  _EmptyPitches(onAdd: () => context.push(AppRoutes.addPitch))
                else
                  ...state.myPitches
                      .take(3)
                      .map(
                        (p) => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: _PitchCard(pitch: p),
                        ),
                      ),
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
    final colors = context.colors;
    final tt = context.typography;

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<OwnerCubit>().refreshPitches(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.background,
            floating: true,
            automaticallyImplyLeading: false,
            title: Text(
              'My Pitches',
              style: tt.titleLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: AppSpacing.md.w),
                child: FilledButton.icon(
                  onPressed: () async {
                    await context.push(AppRoutes.addPitch);
                    if (context.mounted)
                      context.read<OwnerCubit>().refreshPitches();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (state.status == OwnerStatus.loading && state.myPitches.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
            )
          else if (state.myPitches.isEmpty)
            SliverFillRemaining(
              child: _EmptyPitches(
                onAdd: () => context.push(AppRoutes.addPitch),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                    child: _PitchCard(
                      pitch: state.myPitches[i],
                      showActions: true,
                    ),
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

    final colors = context.colors;
    final tt = context.typography;

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<OwnerCubit>().loadDashboardData(),
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        children: [
          Text(
            'Revenue',
            style: tt.headlineMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Financial overview of your pitches',
            style: tt.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.xl.h),

          // Big revenue card
          Container(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primaryContainer, colors.surfaceContainerHigh],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.bxxl.r,
              border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Lifetime Revenue',
                  style: tt.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  '${total.toStringAsFixed(0)} EGP',
                  style: tt.displaySmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Row(
                  children: [
                    _MiniStat(
                      'This Month',
                      '${monthly.toStringAsFixed(0)} EGP',
                    ),
                    SizedBox(width: AppSpacing.lg.w),
                    _MiniStat(
                      'Commission',
                      '${commission.toStringAsFixed(0)} EGP',
                    ),
                    SizedBox(width: AppSpacing.lg.w),
                    _MiniStat('Net Payout', '${net.toStringAsFixed(0)} EGP'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),

          if (state.status == OwnerStatus.loading)
            Center(child: CircularProgressIndicator(color: colors.primary))
          else if (total == 0)
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppRadius.blg.r,
              ),
              child: Center(
                child: Text(
                  'No revenue yet.\nBookings will appear here once confirmed.',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
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
    final colors = context.colors;
    final tt = context.typography;

    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        final user = sessionState.user;
        return ListView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          children: [
            Text(
              'Profile',
              style: tt.headlineMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppRadius.blg.r,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null && context.mounted) {
                        final bytes = await image.readAsBytes();
                        setState(() => _localPhotoBytes = bytes);
                        context.read<AuthCubit>().updateProfile(
                          photoPath: image.path,
                        );
                      }
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colors.primary,
                                    colors.primary.withValues(alpha: 0.7),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: authState.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: colors.onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : _localPhotoBytes != null
                                    ? Image.memory(
                                        _localPhotoBytes!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          IconsaxPlusBold.user,
                                          color: colors.onPrimary,
                                          size: 36,
                                        ),
                                      )
                                    : (user?.photoUrl != null &&
                                          user!.photoUrl!.isNotEmpty)
                                    ? AppCachedImage(
                                        imageUrl: user.photoUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: Center(
                                          child: CircularProgressIndicator(
                                            color: colors.onPrimary,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        errorWidget: Container(
                                          color: colors.surfaceContainerHighest,
                                          child: Icon(
                                            IconsaxPlusBold.user,
                                            color: colors.onPrimary,
                                            size: 36,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        IconsaxPlusBold.user,
                                        color: colors.onPrimary,
                                        size: 36,
                                      ),
                              ),
                            ),
                            if (!authState.isLoading)
                              Container(
                                padding: EdgeInsets.all(AppSpacing.xxs.w),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: colors.onPrimary,
                                  size: 14,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Text(
                    user?.name ?? 'Pitch Owner',
                    style: tt.titleLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md.w,
                      vertical: AppSpacing.xs.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: AppRadius.bxxl.r,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      user?.role?.toUpperCase() ?? 'OWNER',
                      style: tt.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            _ProfileAction(
              icon: IconsaxPlusLinear.add_circle,
              label: 'Add New Pitch',
              onTap: () => context.push(AppRoutes.addPitch),
            ),
            _ProfileAction(
              icon: IconsaxPlusLinear.notification,
              label: 'Notifications',
              onTap: () => context.push(AppRoutes.notifications),
            ),

            // Theme Toggle
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark =
                    mode == ThemeMode.dark ||
                    (mode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark);
                return _ProfileAction(
                  icon: isDark
                      ? IconsaxPlusLinear.sun_1
                      : IconsaxPlusLinear.moon,
                  label: isDark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  onTap: () => context.read<ThemeCubit>().setTheme(
                    isDark ? ThemeMode.light : ThemeMode.dark,
                  ),
                );
              },
            ),

            _ProfileAction(
              icon: IconsaxPlusLinear.logout,
              label: 'Log Out',
              isDestructive: true,
              onTap: () => context.read<SessionCubit>().logout(),
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
    final colors = context.colors;
    final tt = context.typography;
    return Text(
      text,
      style: tt.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
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
    final colors = context.colors;
    final tt = context.typography;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.blg.r,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            unit.isNotEmpty ? '$value $unit' : value,
            style: tt.headlineSmall?.copyWith(
              color: accent ? colors.primary : colors.onSurface,
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
    final colors = context.colors;
    final tt = context.typography;

    final refreshKey = context.read<OwnerCubit>().state.refreshKey;

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
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
            child: AppCachedImage(
              imageUrl: pitch.imageUrl.isNotEmpty
                  ? pitch.imageUrl
                  : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
              cacheKey: pitch.imageUrl.isNotEmpty
                  ? '${pitch.imageUrl}_$refreshKey'
                  : null,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              borderRadius: AppRadius.blg.r,
              errorWidget: Container(
                width: 80.w,
                height: 80.w,
                color: colors.surfaceContainerHighest,
                child: Icon(Icons.sports_soccer, color: colors.primary, size: 32),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pitch.name,
                  style: tt.titleMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xxs.h),
                Row(
                  children: [
                    Icon(
                      IconsaxPlusLinear.location,
                      color: colors.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: AppSpacing.xxs.w),
                    Expanded(
                      child: Text(
                        pitch.location.city,
                        style: tt.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: AppRadius.bsm.r,
                  ),
                  child: Text(
                    '${pitch.pricePerHour.toInt()} EGP/hr',
                    style: tt.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
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
                  icon: Icon(
                    IconsaxPlusLinear.edit,
                    color: colors.primary,
                    size: 20,
                  ),
                  onPressed: () async {
                    final result = await context.push(
                      AppRoutes.addPitch,
                      extra: pitch,
                    );
                    if (result == true && context.mounted) {
                      context.read<OwnerCubit>().refreshPitches();
                    }
                  },
                  tooltip: 'Edit Pitch',
                ),
                IconButton(
                  icon: Icon(
                    IconsaxPlusLinear.trash,
                    color: colors.error,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: colors.surface,
                        title: Text(
                          'Delete Pitch',
                          style: tt.titleLarge?.copyWith(color: colors.onSurface),
                        ),
                        content: Text(
                          'Are you sure you want to delete this pitch?',
                          style: tt.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<OwnerCubit>().deletePitch(pitch.id);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: colors.error),
                            ),
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
    final colors = context.colors;
    final tt = context.typography;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.stadium_outlined, color: colors.primary, size: 48),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'No Pitches Yet',
            style: tt.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Add your first pitch to get started',
            style: tt.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.xl.h),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Pitch'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
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
  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontSize: 10.sp,
          ),
        ),
        SizedBox(height: AppSpacing.xxs.h),
        Text(
          value,
          style: tt.titleSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
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
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;
    final color = isDestructive ? colors.error : colors.onSurface;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: tt.bodyLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: colors.onSurfaceVariant,
        size: 14,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.xs.h,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.blg.r),
    );
  }
}

