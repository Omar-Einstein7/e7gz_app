import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(cs, tt),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildHeader(cs, tt, isDesktop, context),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildStatsGrid(tt, cs, isDesktop),
                      SizedBox(height: 48.h),
                      _buildPitchesSection(tt, cs, context),
                      SizedBox(height: 48.h),
                      _buildLedgerSection(tt, cs),
                      SizedBox(height: 100.h),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _buildMobileNav(cs),
    );
  }

  Widget _buildSidebar(ColorScheme cs, TextTheme tt) {
    return Container(
      width: 280.w,
      color: const Color(0xFF131B2E),
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'e7gzz',
            style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 48.h),
          _sidebarItem('Dashboard', IconsaxPlusBold.element_3, true, cs),
          _sidebarItem('My Pitches', IconsaxPlusLinear.ranking, false, cs),
          _sidebarItem('Revenue', IconsaxPlusLinear.empty_wallet_tick, false, cs),
          _sidebarItem('Schedule', IconsaxPlusLinear.calendar_1, false, cs),
          _sidebarItem('Settings', IconsaxPlusLinear.setting_2, false, cs),
          const Spacer(),
          _sidebarItem('Logout', IconsaxPlusLinear.logout, false, cs, isLogout: true),
        ],
      ),
    );
  }

  Widget _sidebarItem(String label, IconData icon, bool isActive, ColorScheme cs, {bool isLogout = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isActive ? cs.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: isActive ? Border(left: BorderSide(color: cs.primary, width: 4)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? cs.primary : (isLogout ? Colors.red : const Color(0xFFBCC7DE)), size: 20),
          SizedBox(width: 16.w),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : (isLogout ? Colors.red : const Color(0xFFBCC7DE)),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs, TextTheme tt, bool isDesktop, BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0B1326).withValues(alpha: 0.8),
      floating: true,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: isDesktop 
        ? Text('OWNER DASHBOARD', style: tt.titleSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.w900, letterSpacing: 2))
        : Text('e7gzz', style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900)),
      actions: [
        IconButton(
          icon: const Icon(IconsaxPlusLinear.notification, color: Colors.white),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        SizedBox(width: 8.w),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: CircleAvatar(
            radius: 18.r,
            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(TextTheme tt, ColorScheme cs, bool isDesktop) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 4 : 1,
      mainAxisSpacing: 20.h,
      crossAxisSpacing: 20.w,
      childAspectRatio: isDesktop ? 1.5 : 2.5,
      children: [
        _statCard('Monthly Revenue', '24,500', 'EGP', '+12.5%', cs, tt),
        _statCard('Active Bookings', '42', '', 'Today', cs, tt),
        _statCard('Avg. Capacity', '88%', '', 'High', cs, tt),
        _statCard('Loyalty Points', '12K', 'PTS', 'Gold', cs, tt),
      ],
    );
  }

  Widget _statCard(String label, String value, String unit, String trend, ColorScheme cs, TextTheme tt) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 10.sp, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100.r)),
                child: Text(trend, style: TextStyle(color: cs.primary, fontSize: 8.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          RichText(
            text: TextSpan(
              text: value,
              style: tt.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              children: [
                if (unit.isNotEmpty) 
                  TextSpan(text: ' $unit', style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPitchesSection(TextTheme tt, ColorScheme cs, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MY PITCHES', style: tt.titleSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                Text('Manage your facilities', style: TextStyle(color: const Color(0xFFBCC7DE).withValues(alpha: 0.5), fontSize: 12.sp)),
              ],
            ),
            AppButton(
              label: 'ADD NEW',
              height: ButtonSize.small,
              onPressed: () {},
              prefixIcon: const Icon(Icons.add, size: 16),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _pitchOwnerCard('Old Trafford Giza', '6x6 • Artificial Turf', '450', cs, tt),
        SizedBox(height: 16.h),
        _pitchOwnerCard('Stadium Arena 5', '5x5 • Natural Grass', '380', cs, tt),
      ],
    );
  }

  Widget _pitchOwnerCard(String title, String type, String price, ColorScheme cs, TextTheme tt) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.network(
              'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(type, style: const TextStyle(color: Color(0xFFBCC7DE), fontSize: 12)),
                SizedBox(height: 8.h),
                Text('$price EGP/hr', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(IconsaxPlusLinear.edit, color: Colors.white, size: 20)),
              IconButton(onPressed: () {}, icon: const Icon(IconsaxPlusLinear.trash, color: Colors.red, size: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerSection(TextTheme tt, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DIGITAL LEDGER', style: tt.titleSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        SizedBox(height: 24.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131B2E),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _ledgerTile('Mohamed S.', 'Vodafone Cash', '450 EGP', true),
              const Divider(color: Colors.white10),
              _ledgerTile('Youssef A.', 'InstaPay', '380 EGP', true),
              const Divider(color: Colors.white10),
              _ledgerTile('Sherif K.', 'Offline Cash', '450 EGP', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ledgerTile(String payer, String method, String amount, bool isOnline) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF171F33),
        child: Icon(isOnline ? IconsaxPlusBold.card : IconsaxPlusBold.wallet, color: const Color(0xFF4BE277), size: 18),
      ),
      title: Text(payer, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(method, style: const TextStyle(color: Color(0xFFBCC7DE), fontSize: 12)),
      trailing: Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildMobileNav(ColorScheme cs) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1326),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, 'HOME', IconsaxPlusBold.element_3, true, cs),
          _navItem(1, 'REVENUE', IconsaxPlusLinear.empty_wallet_tick, false, cs),
          _navItem(2, 'PITCHES', IconsaxPlusLinear.ranking, false, cs),
          _navItem(3, 'CALENDAR', IconsaxPlusLinear.calendar_1, false, cs),
          _navItem(4, 'PROFILE', IconsaxPlusLinear.user, false, cs),
        ],
      ),
    );
  }

  Widget _navItem(int index, String label, IconData icon, bool isSelected, ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSelected)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF003915), size: 24),
          )
        else
          Icon(icon, color: const Color(0xFFBCC7DE), size: 24),
      ],
    );
  }
}
