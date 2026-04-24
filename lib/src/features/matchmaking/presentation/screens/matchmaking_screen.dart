import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/matchmaking_card.dart';
import '../widgets/leaderboard_tile.dart';
import 'package:e7gz/src/shared/data/mock_data.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  bool _isPublicOnly = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final matches = MockData.matches;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.menu_1, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'e7gzz',
          style: typography.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.notification, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFF2D3449),
              child: const Icon(IconsaxPlusBold.user, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Find Team',
              style: typography.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 36.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Join open matches across Cairo's premium pitches. The field is waiting for its next star.",
              style: typography.bodyMedium?.copyWith(
                color: const Color(0xFFBCC7DE),
                height: 1.5,
              ),
            ),

            SizedBox(height: 32.h),

            // Toggle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PUBLIC MATCHES',
                    style: typography.labelSmall?.copyWith(
                      color: const Color(0xFFBCC7DE),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Switch(
                    value: _isPublicOnly,
                    onChanged: (v) => setState(() => _isPublicOnly = v),
                    activeColor: colors.primary,
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Matches
            ...matches.map((match) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: MatchmakingCard(
                  id: match.id,
                  title: match.title,
                  location: match.location,
                  price: match.pricePerPlayer.toInt().toString(),
                  slotsLeft: match.availableSlots,
                  kickoff: '${match.kickoffTime.hour}:${match.kickoffTime.minute} Today',
                  image: match.imageUrl,
                  participantsCount: match.participantIds.length,
                  isFull: match.isFull,
                  onTap: () => context.push(
                    AppRoutes.matchDetails.replaceFirst(':id', match.id),
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
                    'Weekly Leaderboard',
                    style: typography.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Top individual match contributors',
                    style: typography.bodySmall?.copyWith(
                      color: const Color(0xFFBCC7DE),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            TextButton.icon(
              onPressed: () {},
              icon: const Icon(IconsaxPlusLinear.export, size: 16),
              label: Text(
                'VIEW ALL RANKINGS',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  letterSpacing: 1,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            const LeaderboardTile(
              rank: '01',
              name: 'Amira Khaled',
              progress: '12 Matches Won',
              isMvp: true,
            ),
            SizedBox(height: 12.h),
            const LeaderboardTile(
              rank: '02',
              name: 'Youssef Tarek',
              progress: '10 Matches Won',
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Color(0xFF003915), size: 32),
      ),
    );
  }
}

