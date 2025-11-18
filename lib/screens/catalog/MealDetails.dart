import 'dart:ui';

import 'package:flutter/material.dart';

class MealDetailModal {
  // Fetch meal details based on mealId
  static Map<String, dynamic> _getMealDetails(String mealId) {
    // TODO: Replace with actual API call
    // This is mock data - in production, fetch from your backend
    final Map<String, Map<String, dynamic>> mealsDatabase = {
      '1': {
        'name': 'Spicy Salmon Roll',
        'description':
            'Fresh salmon mixed with spicy mayo, rolled with cucumber and rice, topped with crispy tempura flakes',
        'price': '\$6.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      '2': {
        'name': 'Philadelphia Roll',
        'description':
            'Creamy cream cheese and fresh salmon wrapped in seaweed and rice, garnished with sesame seeds',
        'price': '\$7.49',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      '3': {
        'name': 'Rainbow Roll',
        'description':
            'California roll topped with assorted fresh fish including tuna, salmon, and yellowtail',
        'price': '\$10.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      '4': {
        'name': 'California Roll',
        'description':
            'Classic roll with imitation crab, avocado, and cucumber, wrapped in seaweed and rice',
        'price': '\$6.49',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      '5': {
        'name': 'Dragon Roll',
        'description':
            'Shrimp tempura and cucumber topped with avocado and eel sauce drizzle',
        'price': '\$12.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      '6': {
        'name': 'Tuna Roll',
        'description':
            'Premium bluefin tuna with rice and seaweed, served with wasabi and pickled ginger',
        'price': '\$8.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      '7': {
        'name': 'Miso Soup',
        'description':
            'Traditional Japanese soup with miso paste, tofu, seaweed, and green onions',
        'price': '\$4.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
      },
      '8': {
        'name': 'Caesar Salad',
        'description':
            'Crisp romaine lettuce with parmesan cheese, croutons, and creamy Caesar dressing',
        'price': '\$8.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      },
      '9': {
        'name': 'Grilled Chicken',
        'description':
            'Tender chicken breast marinated in herbs and spices, grilled to perfection',
        'price': '\$14.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
      },
      '10': {
        'name': 'Salmon Teriyaki',
        'description':
            'Grilled salmon fillet glazed with homemade teriyaki sauce, served with steamed vegetables',
        'price': '\$16.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
      },
    };

    return mealsDatabase[mealId] ??
        {
          'name': 'Unknown Meal',
          'description': 'No description available',
          'price': '\$0.00',
          'imageUrl': 'https://placehold.co/358x201',
        };
  }

  static Future<void> show(
    BuildContext context, {
    required String mealId,
    required String restaurantId,
  }) {
    final mealData = _getMealDetails(mealId);

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // needed for full height + blur
      builder: (context) {
        return Stack(
          children: [
            // 🌫 Background blur (frosted)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context), // 👈 CLOSE ON BLUR TAP
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
                height: MediaQuery.of(context).size.height * 0.65, // 88% height
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        // Drag handle (optional)
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4E4E7),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Details',
                          style: TextStyle(
                            color: Color(0xFF131316),
                            fontSize: 20,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w700,
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
                          child: Image.network(mealData['imageUrl'],
                              fit: BoxFit.cover),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                mealData['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF131316),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mealData['description'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF70707B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                mealData['price'],
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
}
