import '../../domain/entities/coffee_product.dart';
import '../../domain/repositories/coffee_repository.dart';
import '../datasources/coffee_remote_data_source.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  final CoffeeRemoteDataSource remoteDataSource;

  CoffeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CoffeeProduct>> getCoffeeProducts({String? category}) async {
    final models = await remoteDataSource.getCoffeeProducts();
    final entities = models.map((m) => m.toEntity()).toList();

    if (category == null || category.isEmpty || category == 'All') {
      return entities;
    }

    return entities.where((item) {
      return item.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  @override
  Future<CoffeeProduct> getCoffeeDetails(int id) async {
    final model = await remoteDataSource.getCoffeeProductById(id);
    return model.toEntity();
  }

  @override
  Future<List<CoffeeProduct>> searchCoffee(String query) async {
    final models = await remoteDataSource.searchCoffeeProducts(query);
    return models.map((m) => m.toEntity()).toList();
  }
}
