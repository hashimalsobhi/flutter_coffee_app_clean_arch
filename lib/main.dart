import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/coffee/presentation/bloc/coffee_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

void main() async {
  // 1. Proper Flutter initialization before any asynchronous setup
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Asynchronously initialize and set up GetIt dependency injection
  await initDependencies();

  // 3. Run application root
  runApp(const CoffeeLoungeApp());
}

class CoffeeLoungeApp extends StatelessWidget {
  const CoffeeLoungeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoffeeBloc>(
          create: (_) => sl<CoffeeBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => sl<CartBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>(),
        ),
        BlocProvider<FavoritesBloc>(
          create: (_) => sl<FavoritesBloc>(),
        ),
      ],
      // 4. Wrap app root with ResponsiveSizer for global responsiveness
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp.router(
            title: 'Coffee Lounge App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
