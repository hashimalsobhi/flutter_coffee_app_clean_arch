import '../entities/coffee_product.dart';
import '../repositories/coffee_repository.dart';

class GetCoffeeDetailsUseCase {
  final CoffeeRepository repository;

  GetCoffeeDetailsUseCase(this.repository);

  Future<CoffeeProduct> call(int id) async {
    return await repository.getCoffeeDetails(id);
  }
}
