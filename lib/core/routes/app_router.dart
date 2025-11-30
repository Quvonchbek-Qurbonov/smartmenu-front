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
import '../../screens/auth/auth_screen.dart';
import '../../screens/auth/create_new_password_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/personal_information_screen.dart';
import '../../screens/auth/select_gender_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/orders/OrderPage.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import 'route_names.dart';
import '../../screens/payment/payment_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // ============ AUTH ROUTES ============
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: RouteNames.signIn,
        name: 'signIn',
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: RouteNames.signUp,
        name: 'signUp',
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.personalInfo,
        name: 'personalInfo',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PersonalInformationScreen(
            email: extra? ['email'],
            password: extra?['password'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.selectGender,
        name: 'selectGender',
        builder: (context, state) {
          final userData = state.extra as Map<String, dynamic>?;
          return SelectGenderScreen(userData: userData);
        },
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OTPScreen(
            email: extra?['email'] ?? '',
            userId: extra?['user_id'],
          );
        },
      ),
      GoRoute(
        path: RouteNames. createNewPassword,
        name: 'createNewPassword',
        builder: (context, state) => CreateNewPasswordScreen(),
      ),

      // ============ MAIN APP ROUTES ============
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.Home,
        name: 'Home',
        builder: (context, state) => const MenuSnapHomePage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.edit_profile,
        name: 'edit_profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.catalog,
        name: 'catalog',
        builder: (context, state) => const CatalogPage(),
      ),
      GoRoute(
        path: RouteNames.about,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: RouteNames.policy,
        name: 'policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RouteNames.terms,
        name: 'terms',
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: RouteNames.orders,
        name: 'orders',
        builder: (context, state) => const OrdersPage(),
      ),

      // Restaurant Menu Route
      GoRoute(
        path: '${RouteNames.menu}/:restaurantId/:restaurantName',
        name: 'menu',
        builder: (context, state) {
          final restaurantId = state.pathParameters['restaurantId'] ?? '';
          final restaurantName = state.pathParameters['restaurantName'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;

          return RestaurantDetailPage(
            restaurantId: restaurantId,
            restaurantName: restaurantName,
            restaurantDescription: extra?['description'],
            restaurantAvatar: extra?['avatar'],
            restaurantLocation: extra?['location'],
          );
        },
      ),

      // Payment Route
      GoRoute(
        path: RouteNames.payment,
        name: 'payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ;
          return PaymentScreen(
            orderId: extra?['orderId'] ?? '',
            totalAmount: extra?['totalAmount'] ?? 0.0,
            orderDetails: extra?['orderDetails'] ??  {},
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
              'Page not found! ',
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