import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_lounge_app/features/coffee/domain/entities/coffee_product.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final List<CoffeeProduct> _favorites = [];

  FavoritesBloc() : super(const FavoritesLoaded()) {
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  void _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) {
    final index = _favorites.indexWhere((p) => p.id == event.product.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(event.product);
    }
    emit(FavoritesLoaded(favorites: List.unmodifiable(_favorites)));
  }
}
