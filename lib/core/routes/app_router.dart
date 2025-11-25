import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/screens/catalog/Menu.dart';
import 'package:my_flutter_app/screens/catalog/catalog_screen.dart';
import 'package:my_flutter_app/screens/home/HomePage.dart';
import 'package:my_flutter_app/screens/qrcode/qrcode_scan.dart';
import '../../screens/all_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import 'route_names.dart';

class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.catalog,
        name: RouteNames.catalog,
        builder: (context, state) => const CatalogPage(),
      ),
      // GoRoute(
      //   path: RouteNames.qrcodeScan,
      //   name: RouteNames.qrcodeScan,
      //   builder: (context, state) => QRCodeScanScreen(),
      // ),
      // Restaurant Detail Route with Path Parameters
      GoRoute(
        path: '${RouteNames.menu}/:restaurantId/:restaurantName',
        name: RouteNames.menu,
        builder: (context, state) {
          final restaurantId = state.pathParameters['restaurantId'] ?? '';
          final restaurantName = state.pathParameters['restaurantName'] ?? '';
          
          return RestaurantDetailPage(
            restaurantId: restaurantId,
            restaurantName: restaurantName,
          );
        },
      ),
      GoRoute(
        path: RouteNames.Home,
        name: RouteNames.Home,
        builder: (context, state) => const MenuSnapHomePage(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Page not found!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Error: ${state.error}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}