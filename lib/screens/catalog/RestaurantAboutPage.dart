import 'dart:ui';
import 'package:flutter/material.dart';

class RestaurantAboutModal extends StatelessWidget {
  final String restaurantName;
  final String imageUrl;
  final List<String> tags;
  final String description;

  const RestaurantAboutModal({
    super.key,
    required this.restaurantName,
    required this.imageUrl,
    required this.tags,
    required this.description,
  });

  static Future<void> show(
      BuildContext context, {
        required String restaurantName,
        required String imageUrl,
        required List<String> tags,
        required String description,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors. transparent,
      builder: (context) => RestaurantAboutModal(
        restaurantName: restaurantName,
        imageUrl: imageUrl,
        tags: tags,
        description: description,
      ),
    );
  }

  // Helper method to check if URL is network or asset
  bool _isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  // Helper method to build image widget
  Widget _buildImage() {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    if (_isNetworkUrl(imageUrl)) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.restaurant,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: MediaQuery.of(context).size. height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius. only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            const Text(
              'About',
              style: TextStyle(
                color: Color(0xFF131316),
                fontSize: 20,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildImage(),
                    ),

                    const SizedBox(height: 16),

                    // Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags. map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF875BF7),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }). toList(),
                    ),

                    const SizedBox(height: 20),

                    // About Title
                    Row(
                      children: [
                        const Icon(
                          Icons. edit,
                          size: 20,
                          color: Color(0xFF131316),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About $restaurantName',
                          style: const TextStyle(
                            color: Color(0xFF131316),
                            fontSize: 18,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 14,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Close Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF875BF7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}