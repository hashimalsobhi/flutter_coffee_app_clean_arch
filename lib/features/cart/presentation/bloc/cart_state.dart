import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartEmpty extends CartState {
  final String message;

  const CartEmpty({this.message = 'Your coffee cart is empty.\nExplore our artisan menu to add your favorite drinks!'});

  @override
  List<Object?> get props => [message];
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String? promoCode;
  final double promoDiscountPercentage;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    this.deliveryFee = 2.50,
    this.discount = 0.0,
    required this.total,
    this.promoCode,
    this.promoDiscountPercentage = 0.0,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartLoaded copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? discount,
    double? total,
    String? promoCode,
    double? promoDiscountPercentage,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
      promoDiscountPercentage:
          promoDiscountPercentage ?? this.promoDiscountPercentage,
    );
  }

  @override
  List<Object?> get props => [
        items,
        subtotal,
        deliveryFee,
        discount,
        total,
        promoCode,
        promoDiscountPercentage,
      ];
}

class CartOrderSuccess extends CartState {
  final String orderId;
  final double amountPaid;
  final int totalItems;

  const CartOrderSuccess({
    required this.orderId,
    required this.amountPaid,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [orderId, amountPaid, totalItems];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
