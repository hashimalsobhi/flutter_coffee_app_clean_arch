import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_helper.dart';
import '../../cart/domain/entities/cart_item.dart';
import '../../cart/presentation/bloc/cart_bloc.dart';
import '../../cart/presentation/bloc/cart_event.dart';
import '../../cart/presentation/bloc/cart_state.dart';
import '../widgets/state_views.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Coffee Cart'),
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
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.textSecondary),
                  tooltip: 'Clear Cart',
                  onPressed: () {
                    context.read<CartBloc>().add(ClearCartEvent());
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartOrderSuccess) {
            _showOrderSuccessDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const CoffeeLoadingView(message: 'Securing your artisan brew order...');
          }

          if (state is CartEmpty || (state is CartLoaded && state.items.isEmpty)) {
            return CoffeeEmptyView(
              title: 'Your Cart is Empty',
              message: 'Looks like you haven\'t added any delicious coffees yet.',
              onAction: () => context.go('/home'),
              actionLabel: 'Browse Coffee Menu',
            );
          }

          if (state is CartLoaded) {
            return Column(
              children: [
                // Scrollable Item List
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _buildCartItemTile(context, item);
                    },
                  ),
                ),

                // Bottom Order Summary Panel
                _buildOrderSummaryPanel(context, state),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildCartItemTile(BuildContext context, CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              item.product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 72,
                height: 72,
                color: AppColors.surfaceElevated,
                child: const Icon(Icons.coffee_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.size} • ${item.milkType}',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyHelper.format(item.totalPrice),
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Buttons (+ / -)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<CartBloc>().add(
                          UpdateItemQuantityEvent(item.id, item.quantity - 1),
                        );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Icon(Icons.remove, size: 16, color: AppColors.cream),
                  ),
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<CartBloc>().add(
                          UpdateItemQuantityEvent(item.id, item.quantity + 1),
                        );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Icon(Icons.add, size: 16, color: AppColors.cream),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryPanel(BuildContext context, CartLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Promo Code Input Box
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _promoController,
                      style: const TextStyle(color: AppColors.cream, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter promo (e.g. LOUNGE20)',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                        suffixIcon: state.promoCode != null
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18)
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(ApplyPromoCodeEvent(_promoController.text));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Cost Breakdown
            _buildPriceRow('Subtotal', CurrencyHelper.format(state.subtotal)),
            const SizedBox(height: 6),
            _buildPriceRow('Barista Delivery Fee', CurrencyHelper.format(state.deliveryFee)),
            if (state.discount > 0) ...[
              const SizedBox(height: 6),
              _buildPriceRow(
                'Lounge Discount (${(state.promoDiscountPercentage * 100).toInt()}%)',
                '-${CurrencyHelper.format(state.discount)}',
                isDiscount: true,
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: AppColors.border, height: 1),
            ),

            // Grand Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment',
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  CurrencyHelper.format(state.total),
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(CheckoutCartEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.coffee_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Place Lounge Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? AppColors.success : AppColors.cream,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  void _showOrderSuccessDialog(BuildContext context, CartOrderSuccess successState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Placed!',
              style: TextStyle(
                color: AppColors.cream,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Receipt: ${successState.orderId}',
              style: const TextStyle(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your ${successState.totalItems} coffee items (${CurrencyHelper.format(successState.amountPaid)}) are being freshly brewed by our master baristas.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go('/home');
                },
                child: const Text('Back to Coffee Lounge'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
