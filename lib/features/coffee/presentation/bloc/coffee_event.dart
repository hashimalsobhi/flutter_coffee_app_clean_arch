import 'package:equatable/equatable.dart';

abstract class CoffeeEvent extends Equatable {
  const CoffeeEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoffeeProductsEvent extends CoffeeEvent {
  final String category;

  const FetchCoffeeProductsEvent({this.category = 'All'});

  @override
  List<Object?> get props => [category];
}

class SelectCategoryEvent extends CoffeeEvent {
  final String category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class FetchCoffeeDetailsEvent extends CoffeeEvent {
  final int id;

  const FetchCoffeeDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchCoffeeEvent extends CoffeeEvent {
  final String query;

  const SearchCoffeeEvent(this.query);

  @override
  List<Object?> get props => [query];
}
