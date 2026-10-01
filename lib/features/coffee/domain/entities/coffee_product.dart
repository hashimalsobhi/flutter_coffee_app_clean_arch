import 'package:equatable/equatable.dart';

class CoffeeProduct extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String imageUrl;
  final List<String> tags;
  final String roastLevel;
  final String origin;
  final int calories;

  const CoffeeProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.imageUrl,
    this.tags = const [],
    this.roastLevel = 'Medium Roast',
    this.origin = 'Single Origin Blend',
    this.calories = 140,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        price,
        rating,
        stock,
        imageUrl,
        tags,
        roastLevel,
        origin,
        calories,
      ];
}
