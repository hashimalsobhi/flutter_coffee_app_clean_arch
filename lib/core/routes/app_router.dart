import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/presentation/screens/cart_screen.dart';
import '../../features/presentation/screens/home_screen.dart';
import '../../features/presentation/screens/main_shell_screen.dart';
import '../../features/presentation/screens/product_details_screen.dart';
import '../../features/presentation/screens/profile_screen.dart';
import '../../features/presentation/screens/search_favorites_screen.dart';
import '../../features/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Splash / Welcome
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchFavoritesScreen(),
            ),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CartScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Product Details Route (Pushed on top of Root Navigator)
      GoRoute(
        path: '/details/:id',
        name: 'product_details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idParam = state.pathParameters['id'] ?? '101';
          final id = int.tryParse(idParam) ?? 101;
          return ProductDetailsScreen(productId: id);
        },
      ),
    ],
  );
}
