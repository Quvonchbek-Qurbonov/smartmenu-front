import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
              'At Menu Snap, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),

            // Section 1
            const Text(
              '1. Information We Collect',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'Device Information: We may collect device type, operating system, and usage data to improve app performance.',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'QR Scanning Data: When scanning QR codes, we only process data necessary to display the restaurant menu. No images or personal data are stored.',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'Optional Contact Information: If you choose to contact us, we may collect your email address to respond to your inquiries.',
            ),
            const SizedBox(height: 28),

            // Section 2
            const Text(
              '2. How We Use Your Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'To display digital menus from partnered restaurants.',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'To improve user experience and app functionality.',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'To respond to support requests or feedback.',
            ),
            const SizedBox(height: 28),

            // Section 3
            const Text(
              '3. Data Sharing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'We do not sell, rent, or share your personal data with third parties, except when required by law.',
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
