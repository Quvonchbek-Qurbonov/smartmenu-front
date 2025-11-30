import 'package:flutter/material.dart';

class CategoryFilterItem extends StatelessWidget {
  final String id;
  final String name;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterItem({
    super.key,
    required this. id,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Icon Container with Border
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ?  const Color(0xFF875BF7) : const Color(0xFFE5E5E5),
                  width: 2,
                ),
              ),
              child: Center(
                child: _buildIcon(),
              ),
            ),
            const SizedBox(height: 8),

            // Category Name
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Outfit',
                fontWeight: isSelected ? FontWeight.w600 : FontWeight. w500,
                color: isSelected ? const Color(0xFF875BF7) : const Color(0xFF6B6B6B),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Check if icon is an emoji (single character or emoji pattern) or an image filename
    if (_isEmoji(icon)) {
      // Display as emoji text
      return Text(
        icon,
        style: const TextStyle(
          fontSize: 28,
        ),
      );
    } else {
      // Display as asset image from assets/category/
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/category/$icon',
          width: 40,
          height: 40,
          fit: BoxFit. cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if image not found
            return const Icon(
              Icons.category,
              size: 28,
              color: Colors.grey,
            );
          },
        ),
      );
    }
  }

  bool _isEmoji(String text) {
    // Check if the string is likely an emoji
    // Emojis are usually 1-2 characters and contain special unicode ranges
    if (text.isEmpty) return false;

    // If it contains a file extension, it's an image
    if (text.contains('. png') ||
        text.contains('.jpg') ||
        text.contains('. jpeg') ||
        text. contains('.webp') ||
        text.contains('.svg')) {
      return false;
    }

    // If it's a short string (1-4 chars) without file extension, treat as emoji
    if (text.length <= 4) {
      return true;
    }

    return false;
  }
}