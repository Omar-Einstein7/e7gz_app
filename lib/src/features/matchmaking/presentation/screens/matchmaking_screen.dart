import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  bool _isPublicOnly = true;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

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
          style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900),
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
              style: tt.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 36.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              "Join open matches across Cairo's premium pitches. The field is waiting for its next star.",
              style: tt.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE), height: 1.5),
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
                    style: tt.labelSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  Switch(
                    value: _isPublicOnly,
                    onChanged: (v) => setState(() => _isPublicOnly = v),
                    activeColor: cs.primary,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Matches
            matchCard(
              title: 'Camp Nou Cairo',
              location: 'Maadi, Cairo',
              price: '150',
              slotsLeft: 2,
              kickoff: '21:00 Today',
              image: 'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
              participantsCount: 8,
              cs: cs,
              tt: tt,
            ),
            
            SizedBox(height: 16.h),
            
            matchCard(
              title: 'The Arena Futsal',
              location: 'New Cairo',
              price: '200',
              slotsLeft: 4,
              kickoff: '22:30 Today',
              image: 'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
              participantsCount: 6,
              cs: cs,
              tt: tt,
            ),
            
            SizedBox(height: 16.h),
            
            matchCard(
              title: 'Zayed Stars',
              location: 'Sheikh Zayed',
              price: '180',
              slotsLeft: 0,
              kickoff: '20:00 Tomorrow',
              image: 'https://images.unsplash.com/photo-1431324155629-1a6eda1eed2d?auto=format&fit=crop&q=80',
              participantsCount: 11,
              isFull: true,
              cs: cs,
              tt: tt,
            ),
            
            SizedBox(height: 48.h),
            
            // Leaderboard Section
            Center(
              child: Column(
                children: [
                  Text(
                    'Weekly Leaderboard',
                    style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Top individual match contributors',
                    style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
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
                style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 12.sp, letterSpacing: 1),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            leaderboardTile('01', 'Amira Khaled', '12 Matches Won', true, cs),
            SizedBox(height: 12.h),
            leaderboardTile('02', 'Youssef Tarek', '10 Matches Won', false, cs),
            
            SizedBox(height: 100.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: cs.primary,
        child: const Icon(Icons.add, color: Color(0xFF003915), size: 32),
      ),
      
    );
  }

  Widget matchCard({
    required String title,
    required String location,
    required String price,
    required int slotsLeft,
    required String kickoff,
    required String image,
    required int participantsCount,
    bool isFull = false,
    required ColorScheme cs,
    required TextTheme tt,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)],
      ),
      child: Column(
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                child: Image.network(image, height: 160.h, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isFull ? Colors.red : const Color(0xFF4BE277),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    isFull ? 'FULL' : '$slotsLeft SLOTS LEFT',
                    style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFBCC7DE), size: 14),
                              SizedBox(width: 4.w),
                              Text(location, style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: tt.titleLarge?.copyWith(color: const Color(0xFF4BE277), fontWeight: FontWeight.w900),
                        ),
                        Text('EGP / PLAYER', style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 8.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    // Avatars mockup
                    SizedBox(
                      width: 80.w,
                      child: Stack(
                        children: [
                          CircleAvatar(radius: 14.r, backgroundColor: Colors.grey),
                          Positioned(left: 20.w, child: CircleAvatar(radius: 14.r, backgroundColor: Colors.blueGrey)),
                          Positioned(left: 40.w, child: CircleAvatar(radius: 14.r, backgroundColor: Colors.amber)),
                        ],
                      ),
                    ),
                    Text(
                      '+$participantsCount',
                      style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'KICKOFF',
                          style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 1),
                        ),
                        Text(
                          kickoff,
                          style: tt.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                AppButton(
                  label: isFull ? 'Waiting List' : 'Join Match',
                  isFullWidth: true,
                  height: ButtonSize.large,
                  onPressed: isFull ? null : () {},
                  suffixIcon: isFull ? const Icon(Icons.hourglass_empty, size: 18) : const Icon(Icons.arrow_forward),
                  variant: isFull ? ButtonVariant.secondary : ButtonVariant.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leaderboardTile(String rank, String name, String progress, bool isMvp, ColorScheme cs) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(color: const Color(0xFFBCC7DE).withValues(alpha: 0.3), fontWeight: FontWeight.w900, fontSize: 20.sp, fontStyle: FontStyle.italic),
          ),
          SizedBox(width: 16.w),
          CircleAvatar(radius: 20.r, backgroundColor: Colors.blueGrey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text(progress, style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp)),
              ],
            ),
          ),
          if (isMvp)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(color: const Color(0xFF4BE277).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
              child: Text('MVP', style: TextStyle(color: const Color(0xFF4BE277), fontSize: 10.sp, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

}
