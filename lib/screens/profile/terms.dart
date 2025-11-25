import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          'Terms & Conditions',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Text(
              'Last updated: 04.06.2025',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // Introduction
            const Text(
              'Please read these Terms and Conditions ("Terms") carefully before using the Menu Snap app.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'By using the app, you agree to be bound by these Terms. If you do not agree, please do not use the app.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),

            // Section 1
            const Text(
              '1. Use of the App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Menu Snap is intended to allow users to scan QR codes and view menus from participating restaurants only. Misuse of the app or its content is prohibited.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),

            // Section 2
            const Text(
              '2. User Responsibilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You agree:',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'Not to misuse the QR code scanning feature.',
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'Not to reproduce, duplicate, or sell any part of the app.',
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'To use the app only for lawful purposes.',
            ),
            const SizedBox(height: 28),

            // Section 3
            const Text(
              '3. Intellectual Property',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'All content within the app, including logos, menu designs, and layout, is the property of Menu Snap or its partners. Unauthorized use is strictly prohibited.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),

            // Section 4
            const Text(
              '4. Changes to the App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We reserve the right to modify or discontinue the app at any time without notice.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF6B6B6B),
            height: 1.6,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B6B6B),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
