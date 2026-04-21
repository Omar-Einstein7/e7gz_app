import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'My Bookings',
          style: tt.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: cs.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          labelColor: cs.primary,
          unselectedLabelColor: const Color(0xFFBCC7DE),
          labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 1),
          tabs: const [
            Tab(text: 'UPCOMING'),
            Tab(text: 'PAST'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          bookingsList(isUpcoming: true, cs: cs, tt: tt),
          bookingsList(isUpcoming: false, cs: cs, tt: tt),
        ],
      ),
    );
  }

  Widget bookingsList({required bool isUpcoming, required ColorScheme cs, required TextTheme tt}) {
    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      itemCount: isUpcoming ? 2 : 5,
      itemBuilder: (context, index) {
        return bookingCard(index: index, isUpcoming: isUpcoming, cs: cs, tt: tt);
      },
    );
  }

  Widget bookingCard({required int index, required bool isUpcoming, required ColorScheme cs, required TextTheme tt}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anfield Arena Cairo',
                      style: tt.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Field A • 5-a-side',
                      style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isUpcoming ? const Color(0xFF4BE277).withValues(alpha: 0.1) : const Color(0xFF2D3449),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  isUpcoming ? 'UPCOMING' : 'COMPLETED',
                  style: TextStyle(
                    color: isUpcoming ? const Color(0xFF4BE277) : const Color(0xFFBCC7DE),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              detailItem('DATE', 'Oct 23, 2023'),
              detailItem('TIME', '21:00 - 22:00'),
              detailItem('PRICE', '500 EGP', highlight: true),
            ],
          ),
          if (isUpcoming) ...[
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'VIEW TICKET',
                    height: ButtonSize.small,
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF171F33),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: const Icon(IconsaxPlusLinear.location, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget detailItem(String label, String value, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
            fontSize: 8.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: highlight ? const Color(0xFF4BE277) : Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
