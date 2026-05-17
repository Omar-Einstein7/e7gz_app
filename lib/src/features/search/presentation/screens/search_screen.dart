import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
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
  final ScrollController _scrollController = ScrollController();
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
    _scrollController.addListener(_onScroll);
    
    // Trigger initial search on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSearchChanged();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<SearchCubit>().loadMore(
        query: _searchController.text,
        sportType: _selectedSport,
        rating: _selectedRating,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );
    }
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
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
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
    final cs = context.colorScheme;
    final typography = context.textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          'e7gzz',
          style: typography.headlineSmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
       
          ),
        ),
      
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.md.h,
            ),
            child: Column(
              children: [
                // Modern Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: AppRadius.bfull.r,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search stadium or location...',
                      hintStyle: TextStyle(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      icon: Icon(
                        IconsaxPlusLinear.search_normal_1,
                        color: cs.primary,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false, // Override theme if necessary
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
                if (state.status == SearchStatus.loading && state.results.isEmpty) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      padding: EdgeInsets.all(24.w),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return SearchResultCard(
                          pitch: Pitch.empty(),
                          onTap: () {},
                        );
                      },
                    ),
                  );
                }

                if (state.status == SearchStatus.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'An error occurred',
                      style: TextStyle(color: cs.error),
                    ),
                  );
                }

                final results = state.results;

                if (results.isEmpty) {
                  return Center(
                    child: Text(
                      'No stadiums found',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(24.w),
                  itemCount: results.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= results.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final pitch = results[index];
                    return SearchResultCard(
                      pitch: pitch,
                      onTap: () => context.push(
                        AppRoutes.pitchDetails.replaceFirst(':id', pitch.id),
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
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
