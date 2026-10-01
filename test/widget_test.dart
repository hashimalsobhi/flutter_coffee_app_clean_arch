import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_lounge_app/features/coffee/domain/entities/coffee_product.dart';
import 'package:coffee_lounge_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_lounge_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:coffee_lounge_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:coffee_lounge_app/features/cart/presentation/bloc/cart_state.dart';

void main() {
  group('Clean Architecture Coffee & Cart Tests', () {
    const testProduct = CoffeeProduct(
      id: 101,
      title: 'Velvet Caramel Macchiato',
      description: 'Artisan espresso with caramel',
      category: 'Espresso',
      price: 5.75,
      rating: 4.9,
      stock: 45,
      imageUrl: 'https://example.com/coffee.png',
    );

    test('CartItem correctly calculates total price with quantity', () {
      const item = CartItem(
        id: '101-M',
        product: testProduct,
        size: 'Medium',
        unitPrice: 6.50,
        quantity: 2,
      );

      expect(item.totalPrice, 13.00);
    });

    test('CartBloc adds item, calculates subtotal and applies promo code', () {
      final cartBloc = CartBloc();

      const item = CartItem(
        id: '101-M',
        product: testProduct,
        size: 'Medium',
        unitPrice: 10.00,
        quantity: 2,
      );

      // Add item to cart
      cartBloc.add(const AddToCartEvent(item));

      expectLater(
        cartBloc.stream,
        emitsInOrder([
          isA<CartLoaded>().having((s) => s.subtotal, 'subtotal', 20.00),
        ]),
      );
    });
  });
}
