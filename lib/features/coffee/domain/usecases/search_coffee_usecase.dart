import '../entities/coffee_product.dart';
import '../repositories/coffee_repository.dart';

class SearchCoffeeUseCase {
  final CoffeeRepository repository;

  SearchCoffeeUseCase(this.repository);

  Future<List<CoffeeProduct>> call(String query) async {
    return await repository.searchCoffee(query);
  }
}
