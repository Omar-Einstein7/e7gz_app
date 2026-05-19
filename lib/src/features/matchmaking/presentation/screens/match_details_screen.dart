import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:easy_localization/easy_localization.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'matchmaking.details_title'.tr(),
          style: typography.titleLarge?.copyWith(color: colors.onSurface),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurface),
          onPressed: () {
            context.read<MatchmakingCubit>().clearSelectedMatch();
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<MatchmakingCubit, MatchmakingState>(
        builder: (context, state) {
          if (state.singleMatchStatus == MatchmakingStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          if (state.singleMatchStatus == MatchmakingStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'matchmaking.error_loading_match'.tr(),
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final match = state.selectedMatch;
          if (match == null) {
            return Center(
              child: Text(
                'matchmaking.match_not_found'.tr(),
                style: TextStyle(color: colors.onSurface),
              ),
            );
          }

          return SingleChildScrollView(
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
                    Icon(Icons.location_on, color: colors.primary, size: 16),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        match.pitchName ?? 'Premium Pitch',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14.sp,
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
                  'matchmaking.participants'.tr(),
                  style: typography.titleLarge?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                if (match.participants.isEmpty && match.participantIds.isEmpty)
                  Text(
                    'matchmaking.no_participants'.tr(),
                    style: TextStyle(color: colors.onSurfaceVariant),
                  )
                else if (match.participants.isEmpty)
                  // Fallback to IDs if names aren't populated yet
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
                SizedBox(height: 120.h),
              ],
            ),
          );
        },
      ),
      bottomSheet: BlocBuilder<MatchmakingCubit, MatchmakingState>(
        builder: (context, state) {
          final match = state.selectedMatch;
          if (match == null) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF131B2E)
                  : colors.surface,
              border: Border(
                top: BorderSide(
                  color: context.isDarkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : colors.outlineVariant,
                ),
              ),
            ),
            child: AppButton(
              label: match.isFull
                  ? 'matchmaking.match_full'.tr()
                  : 'matchmaking.join_match'.tr(),
              onPressed: match.isFull
                  ? null
                  : () => context.read<MatchmakingCubit>().joinMatch(match.id),
              isFullWidth: true,
              variant: match.isFull
                  ? ButtonVariant.secondary
                  : ButtonVariant.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colors = context.colors;
    final isDark = context.isDarkMode;

    return Container(
      width: 99.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark ? null : Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 10.sp),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
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
            backgroundColor: isDark
                ? const Color(0xFF2D3449)
                : colors.surfaceContainerHighest,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Icon(
                    Icons.person,
                    color: isDark ? Colors.white : colors.onSurfaceVariant,
                    size: 20,
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Text(
            name,
            style: TextStyle(
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
