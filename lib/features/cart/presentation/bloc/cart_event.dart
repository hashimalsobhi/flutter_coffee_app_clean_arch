import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final CartItem item;

  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItemQuantityEvent extends CartEvent {
  final String itemId;
  final int newQuantity;

  const UpdateItemQuantityEvent(this.itemId, this.newQuantity);

  @override
  List<Object?> get props => [itemId, newQuantity];
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  const RemoveCartItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ApplyPromoCodeEvent extends CartEvent {
  final String promoCode;

  const ApplyPromoCodeEvent(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

class ClearCartEvent extends CartEvent {}

class CheckoutCartEvent extends CartEvent {}
