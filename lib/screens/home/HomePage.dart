import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';
import 'package:my_flutter_app/screens/qrcode/qrcode_scan.dart';

class MenuSnapHomePage extends StatefulWidget {
  const MenuSnapHomePage({Key? key}) : super(key: key);

  @override
  State<MenuSnapHomePage> createState() => _MenuSnapHomePageState();
}

class _MenuSnapHomePageState extends State<MenuSnapHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _discountAds = [
    {
      'title': '50% OFF',
      'subtitle': 'On your first order',
      'gradient': const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF6C5CE7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Free Delivery',
      'subtitle': 'Orders above \$20',
      'gradient': const LinearGradient(
        colors: [Color(0xFFE86C6C), Color(0xFFD85B5B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': '25% Cashback',
      'subtitle': 'Using Visa Cards',
      'gradient': const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  final List<Map<String, dynamic>> _restaurants = [
    {
      "name": "Evos",
      "image": "evos/evos.jpg",
      "rating": 4.8,
      "cuisine": "American",
      "deliveryTime": "25-30 min"
    },
    {
      "name": "Max Way",
      "image": "maxway/maxway.png",
      "rating": 4.7,
      "cuisine": "Italian",
      "deliveryTime": "30-35 min"
    }
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Menu Snap',
              style: TextStyle(
                color: Color(0xFF131316),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF131316)),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // ---------------- CAROUSEL ----------------
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _discountAds.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDiscountCard(_discountAds[i]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildPageIndicator(),
            const SizedBox(height: 24),

            // ---------------- QR BUTTON ----------------
            // ---------------- QR BUTTON ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // ✅ Equal padding
              child: _buildQRCard(context),
            ),
            const SizedBox(height: 24),

            // ---------------- POPULAR RESTAURANTS ----------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Popular Restaurants",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF131316),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // LIST OF RESTAURANTS
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _restaurants.length,
              itemBuilder: (_, index) {
                final restaurant = _restaurants[index];
                return _buildRestaurantCard(
                  restaurant,
                  cardHeight: screenHeight * 0.18,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _discountAds.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF6C5CE7)
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountCard(Map<String, dynamic> ad) {
    return Container(
      decoration: BoxDecoration(
        gradient: ad['gradient'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🎉 Special Offer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              ad['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ad['subtitle'],
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const QRCodeScanScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          //width: 560,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 48,
                  color: Color(0xFF6C5CE7),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Scan QR Code",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF131316),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "View the menu or pay your bill instantly",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(
    Map<String, dynamic> restaurant, {
    required double cardHeight,
  }) {
    final String imagePath = restaurant["image"];
    final bool isNetworkImage = imagePath.startsWith('http');

    final Widget imageWidget = isNetworkImage
        ? Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: 120,
            height: cardHeight,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120,
                height: cardHeight,
                color: Colors.grey[300],
                child:
                    const Icon(Icons.restaurant, size: 40, color: Colors.grey),
              );
            },
          )
        : Image.asset(
            'assets/restaurant/$imagePath',
            fit: BoxFit.cover,
            width: 120,
            height: cardHeight,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120,
                height: cardHeight,
                color: Colors.grey[300],
                child:
                    const Icon(Icons.restaurant, size: 40, color: Colors.grey),
              );
            },
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to restaurant details
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: imageWidget,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant["name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF131316),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant["cuisine"] ?? "Restaurant",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant["rating"].toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  ),
                                const SizedBox(width: 8),
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    restaurant["deliveryTime"] ?? "30 min",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pushNamed(
                                RouteNames.menuName, // Use the name constant
                                pathParameters: {
                                  'restaurantId': restaurant['id'],
                                  'restaurantName': restaurant['name'],
                                },
                                extra: {
                                  'description': restaurant['description'],
                                  'avatar': restaurant['avatar'],
                                  'location': restaurant['location'],
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "View Menu",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
