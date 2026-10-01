import '../entities/coffee_product.dart';
import '../repositories/coffee_repository.dart';

class GetCoffeeProductsUseCase {
  final CoffeeRepository repository;

  GetCoffeeProductsUseCase(this.repository);

  Future<List<CoffeeProduct>> call({String? category}) async {
    return await repository.getCoffeeProducts(category: category);
  }
}
