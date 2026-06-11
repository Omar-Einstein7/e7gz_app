import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/matchmaking/presentation/widgets/matchmaking_card.dart';
import 'package:e7gz/src/features/matchmaking/presentation/widgets/leaderboard_tile.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MatchmakingView();
  }
}

class _MatchmakingView extends StatefulWidget {
  const _MatchmakingView();

  @override
  State<_MatchmakingView> createState() => _MatchmakingViewState();
}

class _MatchmakingViewState extends State<_MatchmakingView> {
  bool _isPublicOnly = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchmakingCubit>().loadMatches();
      context.read<MatchmakingCubit>().loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final secondaryTextColor = isDark
        ? const Color(0xFFBCC7DE)
        : theme.colorScheme.onSurfaceVariant;
    final cardBg = isDark
        ? const Color(0xFF131B2E)
        : theme.colorScheme.surfaceContainerLow;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'e7gzz',
          style: typography.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<MatchmakingCubit, MatchmakingState>(
        listenWhen: (prev, curr) =>
            (prev.status != curr.status &&
                curr.status != MatchmakingStatus.loading) ||
            (curr.status == MatchmakingStatus.failure &&
                curr.errorMessage != null),
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: state.status == MatchmakingStatus.failure
                    ? Colors.red
                    : Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<MatchmakingCubit, MatchmakingState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              onRefresh: () async {
                context.read<MatchmakingCubit>().loadMatches();
                context.read<MatchmakingCubit>().loadLeaderboard();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'matchmaking.title'.tr(),
                      style: typography.displaySmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 36.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'matchmaking.subtitle'.tr(),
                      style: typography.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Toggle
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'matchmaking.public_matches'.tr().toUpperCase(),
                            style: typography.labelSmall?.copyWith(
                              color: secondaryTextColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          Switch(
                            value: _isPublicOnly,
                            onChanged: (v) => setState(() => _isPublicOnly = v),
                            activeThumbColor: colors.primary,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    if (state.status == MatchmakingStatus.loading &&
                        state.matches.isEmpty)
                      Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    else if (state.status == MatchmakingStatus.failure &&
                        state.matches.isEmpty)
                      Center(
                        child: Text(
                          state.errorMessage ??
                              'matchmaking.error_loading'.tr(),
                          style: TextStyle(color: textColor),
                        ),
                      )
                    else if (state.matches.isEmpty)
                      Center(
                        child: Text(
                          'matchmaking.no_matches'.tr(),
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      )
                    else
                      ...state.matches.map((match) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: MatchmakingCard(
                            match: match,
                            onTap: () => context.push(
                              AppRoutes.matchDetails.replaceFirst(
                                ':id',
                                match.id,
                              ),
                            ),
                            onJoin: () => context.push(
                              AppRoutes.matchDetails.replaceFirst(
                                ':id',
                                match.id,
                              ),
                            ),
                          ),
                        );
                      }),

                    SizedBox(height: 48.h),

                    // Leaderboard Section
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'matchmaking.weekly_leaderboard'.tr(),
                            style: typography.headlineSmall?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'matchmaking.leaderboard_subtitle'.tr(),
                            style: typography.bodySmall?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    if (state.leaderboardStatus == MatchmakingStatus.loading &&
                        state.leaderboard.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else if (state.leaderboard.isEmpty)
                      Center(
                        child: Text(
                          'matchmaking.no_leaderboard_data'.tr(),
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      )
                    else
                      ...List.generate(state.leaderboard.length, (index) {
                        final entry = state.leaderboard[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: LeaderboardTile(
                            rank: (index + 1).toString().padLeft(2, '0'),
                            name: entry.name,
                            progress: 'matchmaking.matches_won'.tr(
                              namedArgs: {'count': entry.wins.toString()},
                            ),
                            isMvp: index == 0,
                          ),
                        );
                      }),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createMatch),
        backgroundColor: colors.primary,
        child: Icon(
          Icons.add,
          color: isDark ? const Color(0xFF003915) : theme.colorScheme.onPrimary,
          size: 32,
        ),
      ),
    );
  }
}
