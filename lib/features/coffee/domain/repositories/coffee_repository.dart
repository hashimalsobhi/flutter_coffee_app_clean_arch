import '../entities/coffee_product.dart';

abstract class CoffeeRepository {
  Future<List<CoffeeProduct>> getCoffeeProducts({String? category});
  Future<CoffeeProduct> getCoffeeDetails(int id);
  Future<List<CoffeeProduct>> searchCoffee(String query);
}
