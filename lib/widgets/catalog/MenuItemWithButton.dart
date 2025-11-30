import 'package:flutter/material.dart';

class MenuItemCardBtn extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final int quantity;
  final Function(String) onAdd;
  final Function(String)? onRemove;
  final VoidCallback? onTap;

  const MenuItemCardBtn({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this. quantity = 0,
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
        height: 200, // FIXED HEIGHT
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment. start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            // FIXED IMAGE
            Container(
              width: double.infinity,
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF9F9F9),
              ),
              child: _buildImage(),
            ),

            // NAME (max 2 lines, clipped)
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF131316),
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

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

            Center(child: _buildQuantityControl()),
          ],
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
        const Icon(Icons.restaurant, size: 40, color: Colors.grey),
      );
    } else {
      // It's an asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.restaurant, size: 40, color: Colors.grey),
      );
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  // QUANTITY CONTROL
  Widget _buildQuantityControl() {
    if (quantity > 0) {
      return Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                if (onRemove != null) onRemove!(id);
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.remove, size: 22, color: Color(0xFF6B6B6B)),
              ),
            ),

            const SizedBox(width: 8),

            Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF131316),
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: () => onAdd(id),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 22, color: Color(0xFF6B6B6B)),
              ),
            ),
          ],
        ),
      );
    }

    // ADD BUTTON ONLY
    return GestureDetector(
      onTap: () => onAdd(id),
      child: Container(
        height: 36,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add, size: 24, color: Color(0xFF6B6B6B)),
      ),
    );
  }
}