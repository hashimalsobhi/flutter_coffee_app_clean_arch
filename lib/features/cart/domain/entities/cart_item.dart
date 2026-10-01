import 'package:equatable/equatable.dart';
import 'package:coffee_lounge_app/features/coffee/domain/entities/coffee_product.dart';

class CartItem extends Equatable {
  final String id;
  final CoffeeProduct product;
  final String size;
  final String sugarLevel;
  final String milkType;
  final int quantity;
  final double unitPrice;

  const CartItem({
    required this.id,
    required this.product,
    required this.size,
    this.sugarLevel = 'Regular Sweet',
    this.milkType = 'Oat Milk',
    this.quantity = 1,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? id,
    CoffeeProduct? product,
    String? size,
    String? sugarLevel,
    String? milkType,
    int? quantity,
    double? unitPrice,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      milkType: milkType ?? this.milkType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [
        id,
        product,
        size,
        sugarLevel,
        milkType,
        quantity,
        unitPrice,
      ];
}
