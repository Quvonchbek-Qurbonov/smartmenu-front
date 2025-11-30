import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super. initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (! mounted) return;

    debugPrint('');
    debugPrint('╔════════════════════════════════════╗');
    debugPrint('║      SPLASH - AUTH CHECK           ║');
    debugPrint('╚════════════════════════════════════╝');

    // Debug: Show storage contents
    await AuthService.debugStorageContents();

    // Check if user has a token
    final isLoggedIn = await AuthService. isLoggedIn();

    debugPrint('Is Logged In: $isLoggedIn');

    if (isLoggedIn && mounted) {
      debugPrint('→ User is logged in, going to /home');
      context.go('/home');
    } else if (mounted) {
      debugPrint('→ User is NOT logged in, going to /auth');
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7C5CFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment. center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white. withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Menu Snap',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan Order Enjoy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}