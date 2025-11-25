import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'About',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // App Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 40,
                color: Color(0xFF7C4DFF),
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'Menu Snap',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            // About Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Menu Snap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Menu Snap is a simple and elegant way to view digital menus — anytime, anywhere.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Designed for ease and speed, the app allows users to instantly access restaurant menus by simply scanning a QR code at participating locations.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No more paper menus or confusion — just a clean, digital experience.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Features List
            _buildFeatureItem(
              icon: '📱',
              text:
                  'Scan QR codes at partnered restaurants to view their menus instantly',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: '🍽️',
              text:
                  'Explore menus from a growing list of registered restaurants',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: '🔍',
              text:
                  'View details about dishes including names, categories, and prices',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: '✨',
              text: 'Seamless design that makes browsing fast and intuitive',
            ),
            const SizedBox(height: 32),
            // Footer Text
            const Text(
              'Menu Snap is built for modern dining — clean, contactless, and convenient.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Skip the wait. Scan. Browse. Enjoy.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required String icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B6B6B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
