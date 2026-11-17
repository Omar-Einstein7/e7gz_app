import 'package:e7gz/src/core/di/injection_container.dart';
import 'package:e7gz/src/features/auth/presentation/cubit/session_cubit.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';
import 'package:e7gz/src/imports/imports.dart';

class MatchDetailsScreen extends StatefulWidget {
  final String matchId;

  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchmakingCubit>().loadMatchById(widget.matchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return BlocListener<MatchmakingCubit, MatchmakingState>(
      listenWhen: (prev, curr) =>
          prev.singleMatchStatus != curr.singleMatchStatus &&
          curr.singleMatchStatus == MatchmakingStatus.failure,
      listener: (context, state) {
        if (state.selectedMatch != null) {
          showAppDialog<void>(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.errorContainer.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: colors.error,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'matchmaking.join_error_title'.tr().isEmpty ||
                                'matchmaking.join_error_title'.tr() ==
                                    'matchmaking.join_error_title'
                            ? 'Matchmaking'
                            : 'matchmaking.join_error_title'.tr(),
                        style: typography.titleLarge?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? 'matchmaking.error_joining'.tr(),
                        style: typography.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'OK',
                            style: typography.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'matchmaking.error_joining'.tr(),
                style: TextStyle(color: colors.onError),
              ),
              backgroundColor: colors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'matchmaking.details_title'.tr(),
            style: typography.titleLarge?.copyWith(color: colors.onSurface),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: colors.onSurface,
            ),
            onPressed: () {
              context.read<MatchmakingCubit>().clearSelectedMatch();
              context.pop();
            },
          ),
        ),
        body: BlocBuilder<MatchmakingCubit, MatchmakingState>(
          builder: (context, state) {
            final isLoading =
                state.singleMatchStatus == MatchmakingStatus.loading;

            if (state.singleMatchStatus == MatchmakingStatus.failure &&
                state.selectedMatch == null) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'matchmaking.error_loading_match'.tr(),
                  style: typography.bodyMedium?.copyWith(color: colors.error),
                ),
              );
            }

            final match = isLoading
                ? const MatchmakingMatch(
                    id: 'skeleton',
                    title: 'Loading Match Title Loading Match Title',
                    pitchId: 'pitch',
                    creatorId: 'creator',
                    date: '2024-01-01',
                    startTime: '18:00',
                    endTime: '19:00',
                    maxPlayers: 10,
                    participantIds: ['1', '2', '3'],
                    pricePerPlayer: 150,
                    skillLevel: 'Beginner',
                    status: 'open',
                    sportType: 'football',
                    pitchName: 'Loading Pitch Location',
                  )
                : state.selectedMatch;

            if (match == null) {
              return Center(
                child: Text(
                  'matchmaking.match_not_found'.tr(),
                  style: TextStyle(color: colors.onSurface),
                ),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Match Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: AppCachedImage(
                        imageUrl:
                            match.pitchImage ??
                            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                        height: 250.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      match.title,
                      style: typography.displaySmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: colors.primary,
                          size: 16,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            match.pitchName ?? 'Premium Pitch',
                            style: typography.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    // Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard(
                          context,
                          'bookings.date'.tr(),
                          match.date,
                          Icons.calendar_today,
                        ),
                        _infoCard(
                          context,
                          'bookings.time'.tr(),
                          match.startTime,
                          Icons.timer,
                        ),
                        _infoCard(
                          context,
                          'matchmaking.level'.tr(),
                          match.skillLevel.toUpperCase(),
                          Icons.bolt,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard(
                          context,
                          'matchmaking.slots'.tr(),
                          '${match.participantIds.length}/${match.maxPlayers}',
                          Icons.group,
                        ),
                        _infoCard(
                          context,
                          'matchmaking.price'.tr(),
                          '${match.pricePerPlayer.toInt()} ${'pitch_details.egp'.tr()}',
                          Icons.payments,
                        ),
                        _infoCard(
                          context,
                          'matchmaking.status'.tr(),
                          match.status.toUpperCase(),
                          Icons.info,
                        ),
                      ],
                    ),
                    SizedBox(height: 48.h),
                    Text(
                      'matchmaking.teams'.tr(),
                      style: typography.titleLarge?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _teamColumn(
                            context,
                            'Team A',
                            match.teamA,
                            match.winner == 'teamA',
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _teamColumn(
                            context,
                            'Team B',
                            match.teamB,
                            match.winner == 'teamB',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    if (match.participants.length < match.maxPlayers) ...[
                      Text(
                        'matchmaking.participants'.tr(),
                        style: typography.titleLarge?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (match.participants.isEmpty &&
                          match.participantIds.isEmpty)
                        Text(
                          'matchmaking.no_participants'.tr(),
                          style: TextStyle(color: colors.onSurfaceVariant),
                        )
                      else if (match.participants.isEmpty)
                        ...List.generate(
                          match.participantIds.length,
                          (index) => _participantTile(
                            context,
                            index,
                            '${'matchmaking.player'.tr()} ${match.participantIds[index]}',
                            null,
                          ),
                        )
                      else
                        ...List.generate(
                          match.participants.length,
                          (index) => _participantTile(
                            context,
                            index,
                            match.participants[index].name,
                            match.participants[index].photoUrl,
                          ),
                        ),
                    ],
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            );
          },
        ),
        bottomSheet: BlocBuilder<MatchmakingCubit, MatchmakingState>(
          builder: (context, state) {
            final match = state.selectedMatch;
            final user = sl<SessionCubit>().state.user;
            if (match == null || user == null) return const SizedBox.shrink();

            final bool isCreator = match.creatorId == user.id;
            final bool isInTeamA = match.teamA.any((p) => p.id == user.id);
            final bool isInTeamB = match.teamB.any((p) => p.id == user.id);
            final bool hasTeam = isInTeamA || isInTeamB;
            final bool isJoined = match.participantIds.contains(user.id);

            // If creator but not in a team, they might want to join a team first
            // OR if they are already in a team and match is ongoing, they can declare winner.
            if (isCreator &&
                match.status != 'completed' &&
                match.status != 'cancelled') {
              return Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!hasTeam && !match.isFull)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: AppButton(
                          label: 'matchmaking.select_team'.tr(),
                          onPressed: () =>
                              _showTeamSelectionDialog(context, match),
                          isFullWidth: true,
                          variant: ButtonVariant.secondary,
                        ),
                      ),
                    AppButton(
                      label: 'matchmaking.declare_winner'.tr(),
                      onPressed: () => _showResolveDialog(context, match),
                      isFullWidth: true,
                    ),
                  ],
                ),
              );
            }

            if (isJoined ||
                match.status == 'completed' ||
                match.status == 'cancelled') {
              return const SizedBox.shrink();
            }

            return Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                border: Border(
                  top: BorderSide(
                    color: colors.outlineVariant,
                  ),
                ),
              ),
              child: AppButton(
                label: match.isFull
                    ? 'matchmaking.match_full'.tr()
                    : 'matchmaking.join_match'.tr(),
                onPressed: match.isFull
                    ? null
                    : () => _showTeamSelectionDialog(context, match),
                isFullWidth: true,
                variant: match.isFull
                    ? ButtonVariant.secondary
                    : ButtonVariant.primary,
              ),
            );
          },
        ),
      ), // closes child: Scaffold(
    ); // closes BlocListener
  }

  void _showTeamSelectionDialog(BuildContext context, MatchmakingMatch match) {
    // Capture the cubit BEFORE opening the modal — the modal's builder
    // gets a new context that doesn't inherit from the widget tree above,
    // so context.read<MatchmakingCubit>() would throw inside the builder.
    final cubit = context.read<MatchmakingCubit>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surfaceContainer,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24.h,
            top: 16.h,
            left: 24.w,
            right: 24.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'matchmaking.select_team'.tr(),
                style: context.typography.headlineSmall?.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'matchmaking.select_team_subtitle'.tr(),
                style: context.typography.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 32.h),
              _teamSelectionCard(
                modalContext,
                title: 'Team A',
                currentPlayers: match.teamA.length,
                maxPlayers: (match.maxPlayers / 2).floor(),
                color: context.colors.error,
                icon: Icons.shield,
                onTap: () {
                  Navigator.of(modalContext).pop();
                  cubit.joinMatch(match.id, 'teamA');
                },
              ),
              SizedBox(height: 16.h),
              _teamSelectionCard(
                modalContext,
                title: 'Team B',
                currentPlayers: match.teamB.length,
                maxPlayers: (match.maxPlayers / 2).floor(),
                color: context.colors.primary,
                icon: Icons.security,
                onTap: () {
                  Navigator.of(modalContext).pop();
                  cubit.joinMatch(match.id, 'teamB');
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _teamSelectionCard(
    BuildContext context, {
    required String title,
    required int currentPlayers,
    required int maxPlayers,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isFull = currentPlayers >= maxPlayers;

    return InkWell(
      onTap: isFull ? null : onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isFull
              ? context.colors.surfaceContainerHighest.withValues(alpha: 0.5)
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isFull
                ? context.colors.outlineVariant
                : color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isFull
                    ? context.colors.surfaceContainerHighest
                    : color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isFull ? context.colors.onSurfaceVariant : color,
                size: 24,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.typography.titleMedium?.copyWith(
                      color: isFull
                          ? context.colors.onSurfaceVariant
                          : context.colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isFull ? 'Team is Full' : 'Available',
                    style: context.typography.labelMedium?.copyWith(
                      color: isFull ? context.colors.error : context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isFull
                    ? context.colors.surfaceContainerHighest
                    : color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                '$currentPlayers / $maxPlayers',
                style: context.typography.labelMedium?.copyWith(
                  color: isFull
                      ? context.colors.onSurfaceVariant
                      : context.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResolveDialog(BuildContext context, MatchmakingMatch match) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surfaceContainer,
        title: Text(
          'matchmaking.who_won'.tr(),
          style: context.typography.titleMedium?.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Team A',
                style: context.typography.bodyLarge?.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              onTap: () {
                dialogContext.pop();
                context.read<MatchmakingCubit>().resolveMatch(
                  match.id,
                  'teamA',
                );
              },
            ),
            ListTile(
              title: Text(
                'Team B',
                style: context.typography.bodyLarge?.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              onTap: () {
                dialogContext.pop();
                context.read<MatchmakingCubit>().resolveMatch(
                  match.id,
                  'teamB',
                );
              },
            ),
            ListTile(
              title: Text(
                'Draw',
                style: context.typography.bodyLarge?.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              onTap: () {
                dialogContext.pop();
                context.read<MatchmakingCubit>().resolveMatch(match.id, 'draw');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamColumn(
    BuildContext context,
    String title,
    List<Participant> players,
    bool isWinner,
  ) {
    final colors = context.colors;
    final typography = context.typography;
    final match = context.read<MatchmakingCubit>().state.selectedMatch;
    final int teamMax = (match?.maxPlayers ?? 10) ~/ 2;
    final user = sl<SessionCubit>().state.user;
    final bool isInTeamA = match?.teamA.any((p) => p.id == user?.id) ?? false;
    final bool isInTeamB = match?.teamB.any((p) => p.id == user?.id) ?? false;
    final bool hasTeam = isInTeamA || isInTeamB;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isWinner) ...[
              SizedBox(width: 4.w),
              Icon(Icons.emoji_events, color: colors.primary, size: 16),
            ],
          ],
        ),
        SizedBox(height: 12.h),
        // Existing Players
        ...players.map(
          (p) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: colors.surfaceContainerHighest,
                  backgroundImage: p.photoUrl != null
                      ? NetworkImage(p.photoUrl!)
                      : null,
                  child: p.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    p.id == user?.id ? 'matchmaking.you'.tr() : p.name,
                    style: typography.bodyMedium?.copyWith(
                      color: p.id == user?.id
                          ? colors.primary
                          : colors.onSurface,
                      fontWeight: p.id == user?.id
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Empty Slots (Clickable to join if user has no team)
        ...List.generate(
          (teamMax - players.length).clamp(0, teamMax),
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: InkWell(
              onTap: hasTeam
                  ? null
                  : () {
                      final match = context
                          .read<MatchmakingCubit>()
                          .state
                          .selectedMatch;
                      if (match != null) {
                        context.read<MatchmakingCubit>().joinMatch(
                          match.id,
                          title == 'Team A' ? 'teamA' : 'teamB',
                        );
                      }
                    },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: hasTeam
                        ? Colors.transparent
                        : colors.primary.withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 16,
                      color: hasTeam
                          ? colors.onSurfaceVariant.withValues(alpha: 0.3)
                          : colors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'matchmaking.empty_slot'.tr(),
                      style: typography.bodySmall?.copyWith(
                        color: hasTeam
                            ? colors.onSurfaceVariant.withValues(alpha: 0.3)
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colors = context.colors;
    final typography = context.typography;
    final isDark = context.isDarkMode;

    return Container(
      width: 99.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? null : Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          SizedBox(height: 8.h),
          Text(
            label,
            style: typography.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: typography.labelMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _participantTile(
    BuildContext context,
    int index,
    String name,
    String? photoUrl,
  ) {
    final colors = context.colors;
    final typography = context.typography;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? null : Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: colors.surfaceContainerHighest,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Icon(
                    Icons.person,
                    color: colors.onSurfaceVariant,
                    size: 20,
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Text(
            name,
            style: typography.bodyMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(Icons.check_circle, color: colors.primary, size: 16),
        ],
      ),
    );
  }
}
