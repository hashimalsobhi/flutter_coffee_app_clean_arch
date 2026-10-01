import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/coffee_product.dart';
import '../../domain/usecases/get_coffee_details_usecase.dart';
import '../../domain/usecases/get_coffee_products_usecase.dart';
import '../../domain/usecases/search_coffee_usecase.dart';
import 'coffee_event.dart';
import 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  final GetCoffeeProductsUseCase getCoffeeProductsUseCase;
  final GetCoffeeDetailsUseCase getCoffeeDetailsUseCase;
  final SearchCoffeeUseCase searchCoffeeUseCase;

  List<CoffeeProduct> _cachedProducts = [];

  CoffeeBloc({
    required this.getCoffeeProductsUseCase,
    required this.getCoffeeDetailsUseCase,
    required this.searchCoffeeUseCase,
  }) : super(CoffeeInitial()) {
    on<FetchCoffeeProductsEvent>(_onFetchProducts);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<FetchCoffeeDetailsEvent>(_onFetchDetails);
    on<SearchCoffeeEvent>(_onSearchCoffee);
  }

  Future<void> _onFetchProducts(
    FetchCoffeeProductsEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(CoffeeLoading());
    try {
      final products = await getCoffeeProductsUseCase();
      _cachedProducts = products;

      if (products.isEmpty) {
        emit(const CoffeeEmpty(message: 'No coffee items currently available.'));
        return;
      }

      final filtered = _filterByCategory(products, event.category);

      emit(CoffeeLoaded(
        allProducts: products,
        filteredProducts: filtered,
        selectedCategory: event.category,
      ));
    } catch (e) {
      emit(CoffeeError('Unable to load menu: ${e.toString()}'));
    }
  }

  void _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<CoffeeState> emit,
  ) {
    if (state is CoffeeLoaded) {
      final current = state as CoffeeLoaded;
      final filtered = _filterByCategory(current.allProducts, event.category);
      emit(current.copyWith(
        selectedCategory: event.category,
        filteredProducts: filtered,
      ));
    } else if (_cachedProducts.isNotEmpty) {
      final filtered = _filterByCategory(_cachedProducts, event.category);
      emit(CoffeeLoaded(
        allProducts: _cachedProducts,
        filteredProducts: filtered,
        selectedCategory: event.category,
      ));
    }
  }

  Future<void> _onFetchDetails(
    FetchCoffeeDetailsEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final product = await getCoffeeDetailsUseCase(event.id);
      if (state is CoffeeLoaded) {
        final current = state as CoffeeLoaded;
        emit(current.copyWith(selectedProduct: product));
      } else {
        emit(CoffeeLoaded(
          allProducts: _cachedProducts,
          filteredProducts: _cachedProducts,
          selectedProduct: product,
        ));
      }
    } catch (e) {
      // Find in cached if remote fails
      final found = _cachedProducts.where((p) => p.id == event.id);
      if (found.isNotEmpty && state is CoffeeLoaded) {
        final current = state as CoffeeLoaded;
        emit(current.copyWith(selectedProduct: found.first));
      } else {
        emit(CoffeeError('Failed to fetch coffee details: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSearchCoffee(
    SearchCoffeeEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      if (_cachedProducts.isNotEmpty) {
        emit(CoffeeLoaded(
          allProducts: _cachedProducts,
          filteredProducts: _cachedProducts,
          selectedCategory: 'All',
        ));
      } else {
        add(const FetchCoffeeProductsEvent());
      }
      return;
    }

    emit(CoffeeLoading());
    try {
      final results = await searchCoffeeUseCase(query);
      if (results.isEmpty) {
        emit(CoffeeEmpty(message: 'No coffees matched "$query". Try another roast or flavor!'));
      } else {
        emit(CoffeeLoaded(
          allProducts: _cachedProducts.isNotEmpty ? _cachedProducts : results,
          filteredProducts: results,
          selectedCategory: 'All',
        ));
      }
    } catch (e) {
      // Local fallback search
      final localResults = _cachedProducts.where((p) {
        return p.title.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase()) ||
            p.category.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (localResults.isEmpty) {
        emit(CoffeeEmpty(message: 'No coffees matched "$query".'));
      } else {
        emit(CoffeeLoaded(
          allProducts: _cachedProducts,
          filteredProducts: localResults,
          selectedCategory: 'All',
        ));
      }
    }
  }

  List<CoffeeProduct> _filterByCategory(List<CoffeeProduct> list, String category) {
    if (category == 'All') return list;
    return list.where((item) {
      return item.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }
}
