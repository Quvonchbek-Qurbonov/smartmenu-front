import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final int quantity;
  final Function(String) onAdd;
  final Function(String)? onRemove;
  final VoidCallback?  onTap;

  const MenuItemCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 0,
    required this.onAdd,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius. circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // IMAGE
              Container(
                width: double.infinity,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF9F9F9),
                ),
                child: _buildImage(),
              ),

              const SizedBox(height: 8),

              // NAME (max 2 lines, clipped)
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF131316),
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // PRICE
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF875BF7),
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Check if it's a network URL or asset path
    if (_isNetworkUrl(imageUrl)) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.restaurant, size: 40, color: Colors. grey),
      );
    } else {
      // It's an asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit. cover,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.restaurant, size: 40, color: Colors.grey),
      );
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
}