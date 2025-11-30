import 'dart:ui';
import 'package:flutter/material.dart';

class MealDetailModal {
  static Future<void> show(
      BuildContext context, {
        required String mealId,
        required String restaurantId,
        String? name,
        String? description,
        String? price,
        String? imageUrl,
      }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          children: [
            // 🌫 Background blur (frosted)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator. pop(context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
            ),

            // 🍱 Bottom content
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size. height * 0.65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets. only(top: 16),
                    child: Column(
                      children: [
                        // Drag handle
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4E4E7),
                            borderRadius: BorderRadius. circular(1000),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Details',
                          style: TextStyle(
                            color: Color(0xFF131316),
                            fontSize: 20,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight. w700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Image
                        Container(
                          width: 358,
                          height: 201,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFFF9F9F9),
                          ),
                          child: _buildImage(imageUrl),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                name ?? 'Unknown Meal',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight. w500,
                                  color: Color(0xFF131316),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                description ?? 'No description available',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF70707B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                price ?? '\$0.00',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF875BF7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Close button
                        Container(
                          width: 358,
                          height: 52,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F3FF),
                              foregroundColor: const Color(0xFF875BF7),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: Colors.grey,
        ),
      );
    }

    // Check if it's a network URL or asset path
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit. cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.restaurant,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      // It's an asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.restaurant,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}