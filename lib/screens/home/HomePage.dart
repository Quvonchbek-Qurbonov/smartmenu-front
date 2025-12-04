import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/core/routes/route_names.dart';
import 'package:my_flutter_app/screens/qrcode/qrcode_scan.dart';

class MenuSnapHomePage extends StatefulWidget {
  const MenuSnapHomePage({Key? key}) : super(key: key);

  @override
  State<MenuSnapHomePage> createState() => _MenuSnapHomePageState();
}

class _MenuSnapHomePageState extends State<MenuSnapHomePage> {
  static const String baseUrl = 'http://167.172.122.176:8000/api';

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Restaurant data from API
  List<Map<String, dynamic>> _restaurants = [];
  bool isLoading = true;
  String?  errorMessage;

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
        begin: Alignment. topLeft,
        end: Alignment. bottomRight,
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

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurants() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = '$baseUrl/restaurants/all';
      debugPrint('Fetching restaurants from: $url');

      final response = await http.get(Uri.parse(url));

      if (response. statusCode == 200) {
        final List<dynamic> data = json. decode(response.body);

        debugPrint('Loaded ${data.length} restaurants');

        setState(() {
          _restaurants = data.map((item) {
            debugPrint('Restaurant: ${item['name']}, Avatar: ${item['avatar']}');
            return {
              'id': item['id']. toString(),
              'name': item['name'] ?? 'Unknown Restaurant',
              'description': item['description'] ?? '',
              'avatar': item['avatar'],
              'location': item['location'] ?? '',
              'views': item['views'] ?? 0,
              'scans': item['scans'] ?? 0,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load restaurants. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size. height;

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
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF6C5CE7),
        onRefresh: _loadRestaurants,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ---------------- DISCOUNT ADS CAROUSEL ----------------
              SizedBox(
                height: screenHeight * 0.18,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _discountAds.length,
                  itemBuilder: (context, index) {
                    final ad = _discountAds[index];
                    return _buildDiscountCard(ad);
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildPageIndicator(),
              const SizedBox(height: 24),

              // ---------------- QR CODE CARD ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildQRCard(context),
              ),
              const SizedBox(height: 24),

              // ---------------- POPULAR RESTAURANTS ----------------
              const Padding(
                padding: EdgeInsets. symmetric(horizontal: 16),
                child: Text(
                  "Popular Restaurants",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight. w700,
                    color: Color(0xFF131316),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // LIST OF RESTAURANTS
              _buildRestaurantsList(screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantsList(double screenHeight) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            color: Color(0xFF6C5CE7),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Icon(
                Icons. error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign. center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadRestaurants,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_restaurants.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets. all(32.0),
          child: Text(
            'No restaurants found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
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
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountCard(Map<String, dynamic> ad) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: ad['gradient'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white. withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets. all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ad['title'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight. w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ad['subtitle'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            MaterialPageRoute(builder: (context) => const QRCodeScanScreen()),
          );
        },
        borderRadius: BorderRadius. circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors. white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius. circular(16),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Color(0xFF6C5CE7),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF131316),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Scan to view menu instantly',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons. arrow_forward_ios,
                color: Color(0xFF6C5CE7),
                size: 20,
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
    // Build image from avatar (API data)
    final String? avatar = restaurant["avatar"];
    final bool hasAvatar = avatar != null && avatar. isNotEmpty;

    final Widget imageWidget = hasAvatar
        ? Image.asset(
      'assets/restaurant/$avatar',
      fit: BoxFit.cover,
      width: 120,
      height: cardHeight,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 120,
          height: cardHeight,
          color: Colors.grey[300],
          child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
        );
      },
    )
        : Container(
      width: 120,
      height: cardHeight,
      color: Colors.grey[300],
      child: const Icon(Icons.restaurant, size: 40, color: Colors. grey),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to menu page
            context.pushNamed(
              RouteNames. menuName,
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
          borderRadius: BorderRadius. circular(18),
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black. withOpacity(0.08),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius. circular(18),
                    bottomLeft: Radius. circular(18),
                  ),
                  child: imageWidget,
                ),
                // DETAILS
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
                                fontWeight: FontWeight. w700,
                                color: Color(0xFF131316),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant["description"] ?? "Restaurant",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow. ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.visibility,
                                    size: 14, color: Colors. grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${restaurant["views"]} views',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.qr_code_scanner,
                                    size: 14, color: Colors. grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${restaurant["scans"]} scans',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
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
                                RouteNames.menuName,
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius. circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'View Menu',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight. w600,
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
