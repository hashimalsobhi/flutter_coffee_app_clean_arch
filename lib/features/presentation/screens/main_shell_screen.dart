import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../cart/presentation/bloc/cart_bloc.dart';
import '../../cart/presentation/bloc/cart_state.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // /home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.coffee_rounded),
              activeIcon: Icon(Icons.coffee_rounded, color: AppColors.primary),
              label: 'Lounge',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search_rounded, color: AppColors.primary),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartLoaded) {
                    count = state.totalItemCount;
                  }
                  if (count > 0) {
                    return Badge(
                      label: Text('$count'),
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.background,
                      child: const Icon(Icons.shopping_bag_outlined),
                    );
                  }
                  return const Icon(Icons.shopping_bag_outlined);
                },
              ),
              activeIcon: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartLoaded) {
                    count = state.totalItemCount;
                  }
                  if (count > 0) {
                    return Badge(
                      label: Text('$count'),
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.background,
                      child: const Icon(Icons.shopping_bag_rounded, color: AppColors.primary),
                    );
                  }
                  return const Icon(Icons.shopping_bag_rounded, color: AppColors.primary);
                },
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'VIP Pass',
            ),
          ],
        ),
      ),
    );
  }
}
