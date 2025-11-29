import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/screens/catalog/Menu.dart';
import 'package:my_flutter_app/screens/catalog/catalog_screen.dart';
import 'package:my_flutter_app/screens/home/HomePage.dart';
import 'package:my_flutter_app/screens/profile/about.dart';
import 'package:my_flutter_app/screens/profile/edit_profile.dart';
import 'package:my_flutter_app/screens/profile/policy.dart';
import 'package:my_flutter_app/screens/profile/terms.dart';
import '../../screens/all_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import 'route_names.dart';
import '../../screens/payment/payment_screen.dart';

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
      GoRoute(
        path: RouteNames.about,
        name: RouteNames.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: RouteNames.policy,
        name: RouteNames.policy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RouteNames.terms,
        name: RouteNames.terms,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
       GoRoute(
        path: RouteNames.edit_profile,
        name: RouteNames.edit_profile,
        builder: (context, state) => const EditProfileScreen(),
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
      GoRoute(
        path: RouteNames.payment,
        name: RouteNames.payment,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PaymentScreen(
            orderId: extra?['orderId'] ?? '',
            totalAmount: extra?['totalAmount'] ?? 0.0,
            orderDetails: extra?['orderDetails'] ?? {},
          );
        },
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
