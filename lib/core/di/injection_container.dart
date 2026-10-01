import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import '../constants/api_constants.dart';
import '../network/network_client.dart';

// Coffee Feature
import '../../features/coffee/data/datasources/coffee_remote_data_source.dart';
import '../../features/coffee/data/repositories/coffee_repository_impl.dart';
import '../../features/coffee/domain/repositories/coffee_repository.dart';
import '../../features/coffee/domain/usecases/get_coffee_details_usecase.dart';
import '../../features/coffee/domain/usecases/get_coffee_products_usecase.dart';
import '../../features/coffee/domain/usecases/search_coffee_usecase.dart';
import '../../features/coffee/presentation/bloc/coffee_bloc.dart';

// Cart Feature
import '../../features/cart/presentation/bloc/cart_bloc.dart';

// Profile Feature
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

// Favorites Feature
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External & Core Network Client with Retry
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<RetryOptions>(
    () => const RetryOptions(
      maxAttempts: ApiConstants.maxRetryAttempts,
      delayFactor: ApiConstants.retryInitialDelay,
    ),
  );
  sl.registerLazySingleton<NetworkClient>(
    () => NetworkClient(
      client: sl<http.Client>(),
      retryOptions: sl<RetryOptions>(),
    ),
  );

  // 2. Data Sources
  sl.registerLazySingleton<CoffeeRemoteDataSource>(
    () => CoffeeRemoteDataSourceImpl(networkClient: sl<NetworkClient>()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(networkClient: sl<NetworkClient>()),
  );

  // 3. Repositories
  sl.registerLazySingleton<CoffeeRepository>(
    () => CoffeeRepositoryImpl(remoteDataSource: sl<CoffeeRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );

  // 4. Use Cases
  sl.registerLazySingleton<GetCoffeeProductsUseCase>(
    () => GetCoffeeProductsUseCase(sl<CoffeeRepository>()),
  );
  sl.registerLazySingleton<GetCoffeeDetailsUseCase>(
    () => GetCoffeeDetailsUseCase(sl<CoffeeRepository>()),
  );
  sl.registerLazySingleton<SearchCoffeeUseCase>(
    () => SearchCoffeeUseCase(sl<CoffeeRepository>()),
  );
  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl<ProfileRepository>()),
  );

  // 5. BLoCs
  sl.registerFactory<CoffeeBloc>(
    () => CoffeeBloc(
      getCoffeeProductsUseCase: sl<GetCoffeeProductsUseCase>(),
      getCoffeeDetailsUseCase: sl<GetCoffeeDetailsUseCase>(),
      searchCoffeeUseCase: sl<SearchCoffeeUseCase>(),
    ),
  );

  sl.registerLazySingleton<CartBloc>(() => CartBloc());
  sl.registerLazySingleton<FavoritesBloc>(() => FavoritesBloc());

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getUserProfileUseCase: sl<GetUserProfileUseCase>(),
    ),
  );
}
