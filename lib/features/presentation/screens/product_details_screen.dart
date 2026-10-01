import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_helper.dart';
import '../../cart/domain/entities/cart_item.dart';
import '../../cart/presentation/bloc/cart_bloc.dart';
import '../../cart/presentation/bloc/cart_event.dart';
import '../../coffee/domain/entities/coffee_product.dart';
import '../../coffee/presentation/bloc/coffee_bloc.dart';
import '../../coffee/presentation/bloc/coffee_state.dart';
import '../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../favorites/presentation/bloc/favorites_event.dart';
import '../../favorites/presentation/bloc/favorites_state.dart';
import '../widgets/state_views.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _selectedSize = 'Medium';
  String _selectedSugar = 'Regular Sweet';
  String _selectedMilk = 'Oat Milk';
  int _quantity = 1;

  final Map<String, double> _sizeSurcharges = {
    'Small': 0.0,
    'Medium': 0.75,
    'Large': 1.50,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<CoffeeBloc, CoffeeState>(
        builder: (context, state) {
          CoffeeProduct? product;

          if (state is CoffeeLoaded) {
            final found = state.allProducts.where((p) => p.id == widget.productId);
            if (found.isNotEmpty) {
              product = found.first;
            }
          }

          if (product == null) {
            return SafeArea(
              child: Stack(
                children: [
                  CoffeeEmptyView(
                    title: 'Coffee Not Found',
                    message: 'We could not locate this coffee drink. Please return to the menu.',
                    onAction: () => context.pop(),
                    actionLabel: 'Back to Menu',
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.cream),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
            );
          }

          final unitPrice = product.price + (_sizeSurcharges[_selectedSize] ?? 0.0);
          final totalPrice = unitPrice * _quantity;

          return Stack(
            children: [
              // Scrollable Content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar with Hero Image
                  SliverAppBar(
                    expandedHeight: 38.h,
                    pinned: true,
                    backgroundColor: AppColors.background,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.cream,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, favState) {
                            final isFav = favState is FavoritesLoaded && favState.isFavorite(product!.id);
                            return GestureDetector(
                              onTap: () {
                                context.read<FavoritesBloc>().add(ToggleFavoriteEvent(product!));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  size: 20,
                                  color: isFav ? AppColors.error : AppColors.cream,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(color: AppColors.surfaceElevated),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.transparent,
                                  AppColors.background,
                                ],
                                stops: const [0.0, 0.6, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Drink Details Body
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Category
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        color: AppColors.cream,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.category,
                                      style: const TextStyle(
                                        color: AppColors.primaryLight,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Rating Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: AppColors.starGold, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: AppColors.cream,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Tasting badges (Roast, Origin, Calories)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildPill(Icons.local_fire_department_rounded, product.roastLevel),
                              _buildPill(Icons.public_rounded, product.origin),
                              _buildPill(Icons.bolt_rounded, '${product.calories} kcal'),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Description
                          const Text(
                            'About this Brew',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Size Selection (Small, Medium, Large)
                          const Text(
                            'Select Cup Size',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildSizeOption('Small', '8 oz', 0.0),
                              const SizedBox(width: 12),
                              _buildSizeOption('Medium', '12 oz', 0.75),
                              const SizedBox(width: 12),
                              _buildSizeOption('Large', '16 oz', 1.50),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Milk Customization
                          const Text(
                            'Milk Choice',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildMilkOption('Oat Milk'),
                                const SizedBox(width: 8),
                                _buildMilkOption('Whole Milk'),
                                const SizedBox(width: 8),
                                _buildMilkOption('Almond Milk'),
                                const SizedBox(width: 8),
                                _buildMilkOption('No Milk'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Sweetness Customization
                          const Text(
                            'Sweetness Level',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildSugarOption('No Sugar'),
                              const SizedBox(width: 8),
                              _buildSugarOption('Less Sweet'),
                              const SizedBox(width: 8),
                              _buildSugarOption('Regular Sweet'),
                            ],
                          ),

                          // Space for bottom sticky bar
                          SizedBox(height: 14.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Sticky Add-To-Cart & Quantity Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Quantity Controller
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_rounded, color: AppColors.cream, size: 20),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Text(
                                '$_quantity',
                                style: const TextStyle(
                                  color: AppColors.cream,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_rounded, color: AppColors.cream, size: 20),
                                onPressed: () {
                                  setState(() => _quantity++);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Add to Cart Button
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {
                                final cartItem = CartItem(
                                  id: '${product!.id}-$_selectedSize-$_selectedMilk',
                                  product: product,
                                  size: _selectedSize,
                                  sugarLevel: _selectedSugar,
                                  milkType: _selectedMilk,
                                  unitPrice: unitPrice,
                                  quantity: _quantity,
                                );
                                context.read<CartBloc>().add(AddToCartEvent(cartItem));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added $_quantity × ${product.title} ($_selectedSize) to Cart!'),
                                    action: SnackBarAction(
                                      label: 'View Cart',
                                      textColor: AppColors.primary,
                                      onPressed: () => context.push('/cart'),
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: AppColors.surfaceElevated,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    CurrencyHelper.format(totalPrice),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryLight),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size, String volume, double surcharge) {
    final isSelected = _selectedSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSize = size),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                size,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryLight : AppColors.cream,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                volume,
                style: TextStyle(
                  color: isSelected ? AppColors.cream : AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilkOption(String milk) {
    final isSelected = _selectedMilk == milk;
    return GestureDetector(
      onTap: () => setState(() => _selectedMilk = milk),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.border,
          ),
        ),
        child: Text(
          milk,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.cream,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSugarOption(String sugar) {
    final isSelected = _selectedSugar == sugar;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSugar = sugar),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryLight : AppColors.border,
            ),
          ),
          child: Text(
            sugar,
            style: TextStyle(
              color: isSelected ? AppColors.background : AppColors.cream,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
