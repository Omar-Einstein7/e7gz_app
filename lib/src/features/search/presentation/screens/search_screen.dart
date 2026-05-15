import 'package:e7gz/src/features/search/presentation/cubit/search_cubit.dart';
import 'package:e7gz/src/features/search/presentation/cubit/search_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import '../widgets/search_filter_chip.dart';
import '../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialSport;
  const SearchScreen({super.key, this.initialSport});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String? _selectedSport;
  double? _selectedRating;
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _selectedSport = widget.initialSport;
    _searchController.addListener(_onSearchChanged);
    
    // Trigger initial search on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSearchChanged();
    });
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSport != oldWidget.initialSport) {
      setState(() {
        _selectedSport = widget.initialSport;
      });
      _onSearchChanged();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged({bool immediate = false}) {
    if (immediate) {
      _debouncer.run(() {}); // Cancel any pending debounce
      context.read<SearchCubit>().search(
            query: _searchController.text,
            sportType: _selectedSport,
            rating: _selectedRating,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
          );
      return;
    }

    _debouncer.run(() {
      if (!mounted) return;
      context.read<SearchCubit>().search(
            query: _searchController.text,
            sportType: _selectedSport,
            rating: _selectedRating,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0B1326) : theme.colorScheme.surface;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;
    final searchBg = isDark ? const Color(0xFF131B2E) : theme.colorScheme.surfaceContainerLow;
    final searchHint = isDark ? const Color(0xFFBCC7DE).withValues(alpha: 0.5) : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);

    return Scaffold(
      backgroundColor: bgColor,
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
        actions: [
          IconButton(
            icon: Icon(IconsaxPlusLinear.map, color: textColor),
            onPressed: () => context.push(AppRoutes.search),
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
                    color: searchBg,
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Search stadium or location...',
                      hintStyle: TextStyle(
                        color: searchHint,
                      ),
                      icon: Icon(
                        IconsaxPlusLinear.search_normal_1,
                        color: isDark ? const Color(0xFF4BE277) : theme.colorScheme.primary,
                      ),
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
                        label: 'All',
                        isSelected: _selectedSport == null,
                        onTap: () => setState(() {
                          _selectedSport = null;
                          _onSearchChanged(immediate: true);
                        }),
                      ),
                      SizedBox(width: 12.w),
                      ...['Football', 'Padel', 'Basketball', 'Tennis', 'Volleyball'].map((sport) {
                        final value = sport.toLowerCase();
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: SearchFilterChip(
                            label: sport,
                            isSelected: _selectedSport == value,
                            onTap: () => setState(() {
                              _selectedSport = value;
                              _onSearchChanged(immediate: true);
                            }),
                          ),
                        );
                      }),
                      SearchFilterChip(
                        label: 'Price',
                        icon: IconsaxPlusLinear.arrow_down_1,
                        isSelected: _minPrice != null || _maxPrice != null,
                        onTap: () {
                          // Simple toggle for demonstration or could open a bottom sheet
                          setState(() {
                            if (_maxPrice == null) {
                              _maxPrice = 500; // Example filter
                            } else {
                              _maxPrice = null;
                            }
                            _onSearchChanged(immediate: true);
                          });
                        },
                      ),
                      SizedBox(width: 12.w),
                      SearchFilterChip(
                        label: 'Rating',
                        icon: IconsaxPlusLinear.star,
                        isSelected: _selectedRating != null,
                        onTap: () {
                          setState(() {
                            if (_selectedRating == null) {
                              _selectedRating = 4.0;
                            } else {
                              _selectedRating = null;
                            }
                            _onSearchChanged(immediate: true);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.loading &&
                    state.results.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == SearchStatus.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'An error occurred',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                final results = state.results;

                if (results.isEmpty) {
                  return const Center(
                    child: Text(
                      'No stadiums found',
                      style: TextStyle(color: Color(0xFFBCC7DE)),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(24.w),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final pitch = results[index];
                    return SearchResultCard(
                      pitch: pitch,
                      onTap: () => context.push(
                        AppRoutes.pitchDetails.replaceFirst(':id', pitch.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
