import 'package:equatable/equatable.dart';
import 'package:coffee_lounge_app/features/coffee/domain/entities/coffee_product.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final CoffeeProduct product;

  const ToggleFavoriteEvent(this.product);

  @override
  List<Object?> get props => [product];
}
