import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../coffee/presentation/bloc/coffee_bloc.dart';
import '../../coffee/presentation/bloc/coffee_event.dart';
import '../../coffee/presentation/bloc/coffee_state.dart';
import '../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../favorites/presentation/bloc/favorites_state.dart';
import '../widgets/coffee_card.dart';
import '../widgets/state_views.dart';

class SearchFavoritesScreen extends StatefulWidget {
  const SearchFavoritesScreen({super.key});

  @override
  State<SearchFavoritesScreen> createState() => _SearchFavoritesScreenState();
}

class _SearchFavoritesScreenState extends State<SearchFavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _onlyHighRated = false;
  String _selectedFilterCategory = 'All';

  final List<String> _quickCategories = const [
    'All',
    'Espresso',
    'Cold Brew',
    'Latte',
    'Beans',
    'Pastries',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search & Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              labelColor: AppColors.background,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(
                  icon: Icon(Icons.search_rounded, size: 16),
                  text: 'Search Menu',
                ),
                Tab(
                  icon: Icon(Icons.favorite_rounded, size: 16),
                  text: 'Favorites',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Live Search & Filters
          _buildSearchTab(),

          // Tab 2: Saved Favorites
          _buildFavoritesTab(),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        // Search Input
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.cream),
            onChanged: (val) {
              context.read<CoffeeBloc>().add(SearchCoffeeEvent(val));
            },
            decoration: InputDecoration(
              hintText: 'Search roasts, lattes, cold brews...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        context.read<CoffeeBloc>().add(const SearchCoffeeEvent(''));
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Quick Category Filter Pills & 4.8+ Rating Chip
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              // Rating Chip
              GestureDetector(
                onTap: () {
                  setState(() => _onlyHighRated = !_onlyHighRated);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _onlyHighRated ? AppColors.starGold : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _onlyHighRated ? AppColors.starGold : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: _onlyHighRated ? AppColors.background : AppColors.starGold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.8+ Stars',
                        style: TextStyle(
                          color: _onlyHighRated ? AppColors.background : AppColors.cream,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories
              ..._quickCategories.map((cat) {
                final isSelected = _selectedFilterCategory.toLowerCase() == cat.toLowerCase();
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedFilterCategory = cat);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryLight : AppColors.border,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.cream,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Search Results List
        Expanded(
          child: BlocBuilder<CoffeeBloc, CoffeeState>(
            builder: (context, state) {
              if (state is CoffeeLoading) {
                return const CoffeeLoadingView(message: 'Searching coffee archive...');
              }

              if (state is CoffeeError) {
                return CoffeeErrorView(
                  message: state.message,
                  onRetry: () => context.read<CoffeeBloc>().add(SearchCoffeeEvent(_searchController.text)),
                );
              }

              if (state is CoffeeEmpty) {
                return CoffeeEmptyView(
                  title: 'No Coffees Found',
                  message: state.message,
                  onAction: () {
                    _searchController.clear();
                    setState(() {
                      _selectedFilterCategory = 'All';
                      _onlyHighRated = false;
                    });
                    context.read<CoffeeBloc>().add(const SearchCoffeeEvent(''));
                  },
                );
              }

              if (state is CoffeeLoaded) {
                var list = state.filteredProducts;

                // Apply local category filter
                if (_selectedFilterCategory != 'All') {
                  list = list.where((p) => p.category.toLowerCase() == _selectedFilterCategory.toLowerCase()).toList();
                }

                // Apply rating filter
                if (_onlyHighRated) {
                  list = list.where((p) => p.rating >= 4.8).toList();
                }

                if (list.isEmpty) {
                  return CoffeeEmptyView(
                    title: 'No Matches Found',
                    message: 'Try changing your search keywords or relaxing filter criteria.',
                    onAction: () {
                      _searchController.clear();
                      setState(() {
                        _selectedFilterCategory = 'All';
                        _onlyHighRated = false;
                      });
                      context.read<CoffeeBloc>().add(const SearchCoffeeEvent(''));
                    },
                    actionLabel: 'Reset Filters',
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return CoffeeCard(product: list[index]);
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favState) {
        if (favState is FavoritesLoaded) {
          final favs = favState.favorites;
          if (favs.isEmpty) {
            return CoffeeEmptyView(
              title: 'No Favorites Yet',
              message: 'Tap the heart icon on any coffee or tea to save it here for quick ordering.',
              onAction: () {
                _tabController.animateTo(0);
              },
              actionLabel: 'Browse Coffee Collection',
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
            ),
            itemCount: favs.length,
            itemBuilder: (context, index) {
              return CoffeeCard(product: favs[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
