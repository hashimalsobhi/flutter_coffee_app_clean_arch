import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../coffee/presentation/bloc/coffee_bloc.dart';
import '../../coffee/presentation/bloc/coffee_event.dart';
import '../../coffee/presentation/bloc/coffee_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/coffee_card.dart';
import '../widgets/state_views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _categories = const [
    {'name': 'All', 'icon': Icons.local_cafe_rounded},
    {'name': 'Espresso', 'icon': Icons.coffee_rounded},
    {'name': 'Cold Brew', 'icon': Icons.ac_unit_rounded},
    {'name': 'Latte', 'icon': Icons.grain_rounded},
    {'name': 'Beans', 'icon': Icons.inventory_2_outlined},
    {'name': 'Pastries', 'icon': Icons.bakery_dining_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CoffeeBloc>();
    if (bloc.state is CoffeeInitial) {
      bloc.add(const FetchCoffeeProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surfaceElevated,
          onRefresh: () async {
            context.read<CoffeeBloc>().add(const FetchCoffeeProductsEvent());
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // 1. Header with Location & VIP Pill
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                'San Francisco, CA',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Specialty Lounge ☕',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.stars_rounded, color: AppColors.starGold, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'VIP Gold',
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Search Bar Shortcut
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search_rounded, color: AppColors.primaryLight, size: 22),
                          SizedBox(width: 12),
                          Text(
                            'Find espresso, cold brew, or beans...',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Specialty Promo Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2B1F19), Color(0xFF1F1612)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -15,
                          bottom: -20,
                          child: Icon(
                            Icons.coffee_maker_rounded,
                            size: 150,
                            color: AppColors.primary.withValues(alpha: 0.08),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'PROMO: 20% OFF',
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Nitro Cold Brew Special',
                                style: TextStyle(
                                  color: AppColors.cream,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Use promo code LOUNGE20 in your cart',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Category Selector Horizontal List
              SliverToBoxAdapter(
                child: BlocBuilder<CoffeeBloc, CoffeeState>(
                  builder: (context, state) {
                    final selectedCat = (state is CoffeeLoaded) ? state.selectedCategory : 'All';
                    return Container(
                      height: 44,
                      margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final name = cat['name'] as String;
                          final icon = cat['icon'] as IconData;
                          return CategoryChip(
                            label: name,
                            icon: icon,
                            isSelected: selectedCat.toLowerCase() == name.toLowerCase(),
                            onTap: () {
                              context.read<CoffeeBloc>().add(SelectCategoryEvent(name));
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // 5. Products Grid or State Handling
              BlocBuilder<CoffeeBloc, CoffeeState>(
                builder: (context, state) {
                  if (state is CoffeeLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: CoffeeLoadingView(),
                    );
                  }

                  if (state is CoffeeError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: CoffeeErrorView(
                        message: state.message,
                        onRetry: () => context.read<CoffeeBloc>().add(const FetchCoffeeProductsEvent()),
                      ),
                    );
                  }

                  if (state is CoffeeEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: CoffeeEmptyView(
                        message: state.message,
                        onAction: () => context.read<CoffeeBloc>().add(const FetchCoffeeProductsEvent(category: 'All')),
                      ),
                    );
                  }

                  if (state is CoffeeLoaded) {
                    final items = state.filteredProducts;
                    if (items.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: CoffeeEmptyView(
                          title: 'No Items in ${state.selectedCategory}',
                          message: 'We could not find any drinks in this category.',
                          onAction: () => context.read<CoffeeBloc>().add(const SelectCategoryEvent('All')),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = items[index];
                            return CoffeeCard(product: product);
                          },
                          childCount: items.length,
                        ),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }
}
