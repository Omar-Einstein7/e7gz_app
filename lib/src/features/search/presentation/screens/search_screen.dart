import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/search_filter_chip.dart';
import '../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _selectedSport = 'Football';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
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
            icon: const Icon(IconsaxPlusLinear.map, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                // Glass Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search stadium or location...',
                      hintStyle: TextStyle(
                        color: const Color(0xFFBCC7DE).withValues(alpha: 0.5),
                      ),
                      icon: const Icon(IconsaxPlusLinear.search_normal_1, color: Color(0xFF4BE277)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Quick Filters
                SizedBox(
                  height: 44.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SearchFilterChip(
                        label: 'Football',
                        isSelected: _selectedSport == 'Football',
                      ),
                      SizedBox(width: 12.w),
                      SearchFilterChip(
                        label: 'Padel',
                        isSelected: _selectedSport == 'Padel',
                      ),
                      SizedBox(width: 12.w),
                      const SearchFilterChip(label: 'Basketball'),
                      SizedBox(width: 12.w),
                      const SearchFilterChip(
                        label: 'Price',
                        icon: IconsaxPlusLinear.arrow_down_1,
                      ),
                      SizedBox(width: 12.w),
                      const SearchFilterChip(
                        label: 'Rating',
                        icon: IconsaxPlusLinear.star,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: 5,
              itemBuilder: (context, index) {
                return SearchResultCard(
                  index: index,
                  onTap: () => context.push(AppRoutes.pitchDetails),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

