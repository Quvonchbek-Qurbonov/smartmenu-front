import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List<String> tags;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this. name,
    required this.imageUrl,
    required this.tags,
    this.onTap,
  });

  ImageProvider _getImageProvider() {
    if (imageUrl.isEmpty) {
      // Return a placeholder image when no image is provided
      return const AssetImage('assets/images/placeholder.png');
    } else if (imageUrl.startsWith('http://') || imageUrl. startsWith('https://')) {
      // Use NetworkImage for URLs
      return NetworkImage(imageUrl);
    } else {
      // Use AssetImage for local assets
      return AssetImage(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double. infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              Container(
                width: double.infinity,
                height: 201,
                clipBehavior: Clip. antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Image(
                  image: _getImageProvider(),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 201,
                  errorBuilder: (context, error, stackTrace) {
                    // Show a fallback widget if image fails to load
                    return Container(
                      width: double.infinity,
                      height: 201,
                      decoration: BoxDecoration(
                        color: Colors.grey. shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 48,
                            color: Colors. grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No Image',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Restaurant Name and Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF131316),
                        fontSize: 20,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: Color(0xFF131316),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets. symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF5F3FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Color(0xFF875BF7),
                        fontSize: 14,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                        height: 1.40,
                      ),
                    ),
                  );
                }). toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}