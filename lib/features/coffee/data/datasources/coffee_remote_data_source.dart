import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/network_client.dart';
import '../models/coffee_product_model.dart';
import '../models/coffee_response_model.dart';

abstract class CoffeeRemoteDataSource {
  Future<List<CoffeeProductModel>> getCoffeeProducts();
  Future<CoffeeProductModel> getCoffeeProductById(int id);
  Future<List<CoffeeProductModel>> searchCoffeeProducts(String query);
}

class CoffeeRemoteDataSourceImpl implements CoffeeRemoteDataSource {
  final NetworkClient networkClient;

  CoffeeRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<List<CoffeeProductModel>> getCoffeeProducts() async {
    // 1. Fetch groceries / beverage items from DummyJSON with retry logic
    final response = await networkClient.get(
      ApiConstants.groceriesCategory,
      queryParameters: {'limit': 30},
    );

    List<CoffeeProductModel> apiProducts = [];
    if (response != null && response is Map<String, dynamic>) {
      final parsed = CoffeeResponseModel.fromJson(response);
      apiProducts = parsed.products;
    }

    // 2. Fetch specific coffee search items from DummyJSON to ensure coffee coverage
    try {
      final coffeeSearchResponse = await networkClient.get(
        ApiConstants.searchProducts,
        queryParameters: {'q': 'coffee'},
      );
      if (coffeeSearchResponse != null && coffeeSearchResponse is Map<String, dynamic>) {
        final parsedCoffee = CoffeeResponseModel.fromJson(coffeeSearchResponse);
        for (final p in parsedCoffee.products) {
          if (!apiProducts.any((item) => item.id == p.id)) {
            apiProducts.insert(0, p);
          }
        }
      }
    } catch (_) {
      // Non-blocking fallback if query returns empty
    }

    // 3. Merge with our curated specialty artisan coffee lounge menu
    final curatedList = _getCuratedLoungeProducts();
    final combined = <CoffeeProductModel>[];

    // Add curated specialty coffee first
    combined.addAll(curatedList);

    // Add DummyJSON items
    for (final apiItem in apiProducts) {
      if (!combined.any((x) => x.id == apiItem.id)) {
        combined.add(apiItem);
      }
    }

    return combined;
  }

  @override
  Future<CoffeeProductModel> getCoffeeProductById(int id) async {
    // Check if it's one of our lounge curated drinks
    final curated = _getCuratedLoungeProducts();
    final found = curated.where((p) => p.id == id);
    if (found.isNotEmpty) {
      return found.first;
    }

    // Otherwise fetch directly from DummyJSON endpoint
    final response = await networkClient.get('${ApiConstants.singleProduct}/$id');
    if (response != null && response is Map<String, dynamic>) {
      return CoffeeProductModel.fromJson(response);
    }

    throw Exception('Coffee product not found with ID: $id');
  }

  @override
  Future<List<CoffeeProductModel>> searchCoffeeProducts(String query) async {
    final lower = query.toLowerCase().trim();

    // Query DummyJSON API with retry
    List<CoffeeProductModel> remoteResults = [];
    try {
      final response = await networkClient.get(
        ApiConstants.searchProducts,
        queryParameters: {'q': query},
      );
      if (response != null && response is Map<String, dynamic>) {
        final parsed = CoffeeResponseModel.fromJson(response);
        remoteResults = parsed.products;
      }
    } catch (_) {
      // Remote search fallback
    }

    // Search curated lounge collection
    final curated = _getCuratedLoungeProducts().where((item) {
      return item.title.toLowerCase().contains(lower) ||
          item.description.toLowerCase().contains(lower) ||
          (item.category != null && item.category!.toLowerCase().contains(lower));
    }).toList();

    // Merge unique results
    final results = <CoffeeProductModel>[...curated];
    for (final remote in remoteResults) {
      if (!results.any((x) => x.id == remote.id)) {
        results.add(remote);
      }
    }

    return results;
  }

  /// Curated specialty coffee lounge collection for rich, premium coffee presentation
  List<CoffeeProductModel> _getCuratedLoungeProducts() {
    return const [
      CoffeeProductModel(
        id: 101,
        title: 'Velvet Caramel Macchiato',
        description: 'Freshly steamed whole milk with vanilla-flavored syrup, marked with rich espresso and drizzled with artisan caramel sauce.',
        category: 'Espresso',
        price: 5.75,
        rating: 4.9,
        stock: 45,
        brand: 'Antigravity Specialty Roast',
        thumbnail: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1485808191679-5f86510681a2?auto=format&fit=crop&w=800&q=80'],
        tags: ['Popular', 'Signature', 'Sweet'],
      ),
      CoffeeProductModel(
        id: 102,
        title: 'Nitro Cold Brew Reserve',
        description: 'Slow-steeped cold brew infused with nitrogen as it pours, creating a velvety micro-foam head and naturally sweet, cascading finish.',
        category: 'Cold Brew',
        price: 6.25,
        rating: 4.95,
        stock: 30,
        brand: 'Lounge Reserve',
        thumbnail: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=800&q=80'],
        tags: ['Nitro', 'Cold Brew', 'Zero Sugar'],
      ),
      CoffeeProductModel(
        id: 103,
        title: 'Spanish Saffron Latte',
        description: 'Signature espresso extracted over condensed milk and infused with delicate crimson saffron threads and steamed oat foam.',
        category: 'Latte',
        price: 6.50,
        rating: 4.88,
        stock: 40,
        brand: 'Artisan Lounge',
        thumbnail: 'https://images.unsplash.com/photo-1534778101976-62847782c213?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1534778101976-62847782c213?auto=format&fit=crop&w=800&q=80'],
        tags: ['Exclusive', 'Sweet', 'Aromatic'],
      ),
      CoffeeProductModel(
        id: 104,
        title: 'Cortado Doppio Espresso',
        description: 'Equal parts bold ristretto espresso and silky warm textured milk, cutting the acidity while preserving deep coffee aromatics.',
        category: 'Espresso',
        price: 4.85,
        rating: 4.82,
        stock: 60,
        brand: 'Single Origin',
        thumbnail: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=800&q=80'],
        tags: ['Strong', 'Classic', 'Intense'],
      ),
      CoffeeProductModel(
        id: 105,
        title: 'Vanilla Sweet Cream Cold Brew',
        description: 'Signature cold brew accentuated with vanilla syrup and topped with a handcrafted float of house-made vanilla sweet cream.',
        category: 'Cold Brew',
        price: 5.95,
        rating: 4.92,
        stock: 35,
        brand: 'Lounge Reserve',
        thumbnail: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=800&q=80'],
        tags: ['Creamy', 'Iced', 'Bestseller'],
      ),
      CoffeeProductModel(
        id: 106,
        title: 'Ethiopia Yirgacheffe Beans',
        description: 'Washed heirloom Arabica beans featuring crisp bergamot citrus notes, jasmine floral bouquets, and a clean peach tea finish.',
        category: 'Beans',
        price: 18.50,
        rating: 4.98,
        stock: 22,
        brand: 'Direct Trade Roast',
        thumbnail: 'https://images.unsplash.com/photo-1587734195503-904fca47e0e9?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1587734195503-904fca47e0e9?auto=format&fit=crop&w=800&q=80'],
        tags: ['Whole Beans', 'Light Roast', 'Direct Trade'],
      ),
      CoffeeProductModel(
        id: 107,
        title: 'Artisan Almond Croissant',
        description: 'Golden flaky French puff pastry layered with pure Normandy butter, filled with sweet almond frangipane and toasted sliced almonds.',
        category: 'Pastries',
        price: 4.75,
        rating: 4.85,
        stock: 18,
        brand: 'Bakery Atelier',
        thumbnail: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=800&q=80'],
        tags: ['Freshly Baked', 'Breakfast', 'Butter'],
      ),
      CoffeeProductModel(
        id: 108,
        title: 'Hazelnut Dark Mocha',
        description: 'Full-bodied espresso married with Belgian dark chocolate ganache, roasted hazelnut syrup, and whipped cream shavings.',
        category: 'Latte',
        price: 6.10,
        rating: 4.89,
        stock: 28,
        brand: 'Specialty Roast',
        thumbnail: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=800&q=80',
        images: ['https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=800&q=80'],
        tags: ['Mocha', 'Chocolate', 'Decadent'],
      ),
    ];
  }
}
