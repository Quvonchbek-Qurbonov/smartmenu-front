import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/screens/catalog/SearchPage.dart';
import 'package:my_flutter_app/widgets/catalog/RestaurantCard.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  static const String baseUrl = 'http://167.172.122.176:8000/api';

  int _selectedIndex = 1;
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
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

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        debugPrint('Loaded ${data.length} restaurants');

        setState(() {
          restaurants = data.map((item) {
            debugPrint('Restaurant: ${item['name']}, Avatar: ${item['avatar']}');
            return {
              'id': item['id']. toString(),
              'name': item['name'] ?? 'Unknown Restaurant',
              'description': item['description'] ?? '',
              'avatar': item['avatar'],
              'location': item['location'] ?? '',
              'views': item['views'] ?? 0,
              'scans': item['scans'] ?? 0,
              'tags': _getTagsForRestaurant(item['name'] ?? ''),
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
        errorMessage = 'Failed to load restaurants.  Please try again.';
      });
    }
  }

  List<String> _getTagsForRestaurant(String name) {
    List<String> tags = ['⭐ Popular', '🍽️ Fine Dining'];

    if (name.toLowerCase().contains('lavash')) {
      tags = ['🔥 Fast Service', '🥙 Lavash', '⭐ Popular'];
    } else if (name.toLowerCase().contains('pizza')) {
      tags = ['🍕 Pizza', '🧀 Cheesy', '⚡ Fast'];
    } else if (name. toLowerCase().contains('sushi')) {
      tags = ['🍣 Sushi', '🇯🇵 Japanese', '🥢 Fresh'];
    } else if (name.toLowerCase().contains('burger')) {
      tags = ['🍔 Burgers', '🍟 Fast Food', '🔥 Grilled'];
    }

    return tags;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        debugPrint('Already on Catalog');
        break;
      case 2:
        debugPrint('Open Scanner');
        break;
      case 3:
        debugPrint('Navigate to Orders');
        break;
      case 4:
        context.go(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors. white,
        title: const Text(
          'Catalog',
          style: TextStyle(
            color: Color(0xFF131316),
            fontSize: 24,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons. search,
              color: Color(0xFF131316),
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    searchType: 'restaurant',
                    searchData: restaurants,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF875BF7),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRestaurants,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF875BF7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (restaurants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 64,
              color: Colors.grey. shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No restaurants found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRestaurants,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF875BF7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF875BF7),
      onRefresh: _loadRestaurants,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          final avatar = restaurant['avatar'];

          // Build the image path
          String imagePath = '';
          if (avatar != null && avatar.toString().isNotEmpty) {
            imagePath = 'assets/restaurant/$avatar';
          }

          debugPrint('Restaurant ${restaurant['name']} image path: $imagePath');

          return RestaurantCard(
            name: restaurant['name'],
            imageUrl: imagePath,
            tags: List<String>.from(restaurant['tags']),
            onTap: () {
              context.pushNamed(
                RouteNames.menu,
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
          );
        },
      ),
    );
  }
}