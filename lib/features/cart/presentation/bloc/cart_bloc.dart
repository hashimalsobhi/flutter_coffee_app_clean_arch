import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _items = [];
  String? _currentPromo;
  double _promoDiscountPercentage = 0.0;
  static const double _deliveryFee = 2.50;

  CartBloc() : super(const CartEmpty()) {
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateItemQuantityEvent>(_onUpdateQuantity);
    on<RemoveCartItemEvent>(_onRemoveItem);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<ClearCartEvent>(_onClearCart);
    on<CheckoutCartEvent>(_onCheckout);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final newItem = event.item;
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == newItem.product.id &&
          item.size == newItem.size &&
          item.sugarLevel == newItem.sugarLevel &&
          item.milkType == newItem.milkType,
    );

    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + newItem.quantity,
      );
    } else {
      _items.add(newItem);
    }

    _emitCartState(emit);
  }

  void _onUpdateQuantity(UpdateItemQuantityEvent event, Emitter<CartState> emit) {
    final index = _items.indexWhere((item) => item.id == event.itemId);
    if (index >= 0) {
      if (event.newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: event.newQuantity);
      }
    }

    _emitCartState(emit);
  }

  void _onRemoveItem(RemoveCartItemEvent event, Emitter<CartState> emit) {
    _items.removeWhere((item) => item.id == event.itemId);
    _emitCartState(emit);
  }

  void _onApplyPromoCode(ApplyPromoCodeEvent event, Emitter<CartState> emit) {
    final code = event.promoCode.trim().toUpperCase();
    if (code == 'LOUNGE20' || code == 'COFFEE20') {
      _currentPromo = code;
      _promoDiscountPercentage = 0.20; // 20% off
    } else if (code == 'VIP50') {
      _currentPromo = code;
      _promoDiscountPercentage = 0.50; // 50% off
    } else {
      _currentPromo = null;
      _promoDiscountPercentage = 0.0;
    }
    _emitCartState(emit);
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    _items.clear();
    _currentPromo = null;
    _promoDiscountPercentage = 0.0;
    emit(const CartEmpty());
  }

  Future<void> _onCheckout(CheckoutCartEvent event, Emitter<CartState> emit) async {
    if (_items.isEmpty) {
      emit(const CartEmpty(message: 'Your cart is empty. Add items to place an order.'));
      return;
    }

    emit(CartLoading());
    await Future.delayed(const Duration(milliseconds: 900));

    final subtotal = _calculateSubtotal();
    final discount = subtotal * _promoDiscountPercentage;
    final total = (subtotal - discount) + _deliveryFee;
    final totalItems = _items.fold(0, (sum, i) => sum + i.quantity);

    final randomId = '#CL-${Random().nextInt(900000) + 100000}';
    _items.clear();
    _currentPromo = null;
    _promoDiscountPercentage = 0.0;

    emit(CartOrderSuccess(
      orderId: randomId,
      amountPaid: total,
      totalItems: totalItems,
    ));
  }

  void _emitCartState(Emitter<CartState> emit) {
    if (_items.isEmpty) {
      emit(const CartEmpty());
      return;
    }

    final subtotal = _calculateSubtotal();
    final discount = subtotal * _promoDiscountPercentage;
    final total = (subtotal - discount) + _deliveryFee;

    emit(CartLoaded(
      items: List.unmodifiable(_items),
      subtotal: subtotal,
      deliveryFee: _deliveryFee,
      discount: discount,
      total: total,
      promoCode: _currentPromo,
      promoDiscountPercentage: _promoDiscountPercentage,
    ));
  }

  double _calculateSubtotal() {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
