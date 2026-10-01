import 'package:equatable/equatable.dart';
import '../../domain/entities/coffee_product.dart';

abstract class CoffeeState extends Equatable {
  const CoffeeState();

  @override
  List<Object?> get props => [];
}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeLoaded extends CoffeeState {
  final List<CoffeeProduct> allProducts;
  final List<CoffeeProduct> filteredProducts;
  final String selectedCategory;
  final CoffeeProduct? selectedProduct;

  const CoffeeLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedCategory = 'All',
    this.selectedProduct,
  });

  CoffeeLoaded copyWith({
    List<CoffeeProduct>? allProducts,
    List<CoffeeProduct>? filteredProducts,
    String? selectedCategory,
    CoffeeProduct? selectedProduct,
  }) {
    return CoffeeLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        selectedCategory,
        selectedProduct,
      ];
}

class CoffeeEmpty extends CoffeeState {
  final String message;

  const CoffeeEmpty({this.message = 'No artisan coffee found for this selection.'});

  @override
  List<Object?> get props => [message];
}

class CoffeeError extends CoffeeState {
  final String message;

  const CoffeeError(this.message);

  @override
  List<Object?> get props => [message];
}
