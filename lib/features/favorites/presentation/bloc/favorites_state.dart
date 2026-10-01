import 'package:equatable/equatable.dart';
import 'package:coffee_lounge_app/features/coffee/domain/entities/coffee_product.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoritesState {
  final List<CoffeeProduct> favorites;

  const FavoritesLoaded({this.favorites = const []});

  bool isFavorite(int productId) => favorites.any((p) => p.id == productId);

  @override
  List<Object?> get props => [favorites];
}
