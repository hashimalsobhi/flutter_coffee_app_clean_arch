import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/coffee_product.dart';

part 'coffee_product_model.g.dart';

@JsonSerializable()
class CoffeeProductModel {
  final int id;
  final String title;
  final String description;
  final String? category;
  final double price;
  final double rating;
  final int stock;
  final String? thumbnail;
  final List<String>? images;
  final List<String>? tags;
  final String? brand;

  const CoffeeProductModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.price,
    this.rating = 4.5,
    this.stock = 50,
    this.thumbnail,
    this.images,
    this.tags,
    this.brand,
  });

  factory CoffeeProductModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoffeeProductModelToJson(this);

  CoffeeProduct toEntity({
    String? customCategory,
    String? roastLevel,
    String? origin,
    int? calories,
    String? fallbackImage,
  }) {
    // Elegant fallback high-res coffee images if DummyJSON returns generic grocery image
    final effectiveImage = (thumbnail != null && thumbnail!.isNotEmpty)
        ? thumbnail!
        : (images != null && images!.isNotEmpty)
            ? images!.first
            : (fallbackImage ??
                'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=600&q=80');

    // Categorization logic for specialty coffee lounge
    String resolvedCategory = customCategory ?? _inferCoffeeCategory(title, category);

    return CoffeeProduct(
      id: id,
      title: title,
      description: description,
      category: resolvedCategory,
      price: price > 0 ? price : 5.50,
      rating: rating > 0 ? rating : 4.8,
      stock: stock > 0 ? stock : 25,
      imageUrl: effectiveImage,
      tags: tags ?? ['Freshly Brewed', 'Specialty'],
      roastLevel: roastLevel ?? _inferRoast(title),
      origin: origin ?? _inferOrigin(id),
      calories: calories ?? (110 + (id % 15) * 10),
    );
  }

  static String _inferCoffeeCategory(String title, String? cat) {
    final lower = title.toLowerCase();
    if (lower.contains('espresso') || lower.contains('ristretto') || lower.contains('americano')) {
      return 'Espresso';
    } else if (lower.contains('cold brew') || lower.contains('iced') || lower.contains('frappe')) {
      return 'Cold Brew';
    } else if (lower.contains('latte') || lower.contains('cappuccino') || lower.contains('flat white')) {
      return 'Latte';
    } else if (lower.contains('bean') || lower.contains('roast') || lower.contains('grounds')) {
      return 'Beans';
    } else if (lower.contains('croissant') || lower.contains('pastry') || lower.contains('cake') || lower.contains('cookie')) {
      return 'Pastries';
    }
    return 'Espresso';
  }

  static String _inferRoast(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('dark') || lower.contains('espresso')) {
      return 'Dark French Roast';
    } else if (lower.contains('light') || lower.contains('blonde')) {
      return 'Light Blonde Roast';
    }
    return 'Medium Velvet Roast';
  }

  static String _inferOrigin(int id) {
    const origins = [
      'Ethiopian Yirgacheffe (Altitude 1,900m)',
      'Colombian Huila Supremo',
      'Guatemala Antigua Volcanic',
      'Sumatra Mandheling Single-Estate',
      'Costa Rica Tarrazú Reserve',
      'Kenya AA Nyeri Highlands',
    ];
    return origins[id % origins.length];
  }
}
