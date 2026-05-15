import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
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
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Match Details',
          style: typography.titleLarge?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<MatchmakingCubit>().clearSelectedMatch();
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<MatchmakingCubit, MatchmakingState>(
        builder: (context, state) {
          if (state.singleMatchStatus == MatchmakingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.singleMatchStatus == MatchmakingStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error loading match',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final match = state.selectedMatch;
          if (match == null) {
            return const Center(
              child: Text(
                'Match not found',
                style: TextStyle(color: Colors.white),
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
                    imageUrl: match.pitchImage ??
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF4BE277),
                      size: 16,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        match.pitchName ?? 'Premium Pitch',
                        style: TextStyle(
                          color: const Color(0xFFBCC7DE),
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
                    _infoCard('Date', match.date, Icons.calendar_today, colors),
                    _infoCard('Time', match.startTime, Icons.timer, colors),
                    _infoCard(
                      'Level',
                      match.skillLevel.toUpperCase(),
                      Icons.bolt,
                      colors,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoCard(
                      'Slots',
                      '${match.participantIds.length}/${match.maxPlayers}',
                      Icons.group,
                      colors,
                    ),
                    _infoCard(
                      'Price',
                      '${match.pricePerPlayer.toInt()} EGP',
                      Icons.payments,
                      colors,
                    ),
                    _infoCard(
                      'Status',
                      match.status.toUpperCase(),
                      Icons.info,
                      colors,
                    ),
                  ],
                ),
                SizedBox(height: 48.h),
                Text(
                  'Participants',
                  style: typography.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                if (match.participants.isEmpty && match.participantIds.isEmpty)
                  const Text(
                    'No participants yet',
                    style: TextStyle(color: Color(0xFFBCC7DE)),
                  )
                else if (match.participants.isEmpty)
                  // Fallback to IDs if names aren't populated yet
                  ...List.generate(
                    match.participantIds.length,
                    (index) => _participantTile(
                      index,
                      'Player ${match.participantIds[index]}',
                      null,
                    ),
                  )
                else
                  ...List.generate(
                    match.participants.length,
                    (index) => _participantTile(
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
              color: const Color(0xFF131B2E),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            child: AppButton(
              label: match.isFull ? 'Match Full' : 'Join This Match',
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
    String label,
    String value,
    IconData icon,
    ColorScheme colors,
  ) {
    return Container(
      width: 105.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
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

  Widget _participantTile(int index, String name, String? photoUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: const Color(0xFF2D3449),
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null,
          ),
          SizedBox(width: 16.w),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.check_circle, color: Color(0xFF4BE277), size: 16),
        ],
      ),
    );
  }
}
