import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_shell.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/categories/screens/categories_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/product_details/screens/product_details_screen.dart';
import '../../models/product.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../auth/auth_state.dart';
import '../../services/mock_data.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  refreshListenable: AuthState.instance,
  redirect: (context, state) {
    final signedIn = AuthState.instance.value;
    final path = state.uri.path;
    const authPaths = ['/sign-in', '/sign-up'];
    const openPaths = ['/splash', '/onboarding', ...authPaths];
    if (!signedIn && !openPaths.contains(path)) return '/sign-in';
    if (signedIn && authPaths.contains(path)) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    // Full-screen order flow (shown above the tab bar).
    GoRoute(
      path: '/cart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/favorites',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/product-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        Product? product =
            state.extra is Product ? state.extra as Product : null;
        final id = state.uri.queryParameters['id'];
        if (product == null && id != null) {
          for (final p in MockData.products) {
            if (p.id == id) product = p;
          }
        }
        if (product == null) return const HomeScreen();
        return ProductDetailsScreen(product: product);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
