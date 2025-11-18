import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/screens/catalog/SearchPage.dart';
import 'package:my_flutter_app/widgets/catalog/RestaurantCard.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';


class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  int _selectedIndex = 1; // Catalog is selected by default
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // TODO: Replace with actual API call
    // Example:
    // final response = await http.get(Uri.parse('your-api-endpoint/restaurants'));
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body) as List;
    //   setState(() {
    //     restaurants = data;
    //     isLoading = false;
    //   });
    // }
    
    setState(() {
      restaurants = [
        {
          'id': '1',
          'name': 'Zen Bowl Premium',
          'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
          'tags': ['🥩 Grill Expert', '🥩 Premium Beef', '🌿 Fresh'],
        },
        {
          'id': '2',
          'name': 'Flavoria',
          'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
          'tags': ['🍕 Cheesy Crust', '🌱 Vegetarian', '🌿 Fresh'],
        },
        {
          'id': '3',
          'name': 'Urban Feast',
          'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
          'tags': ['✅ Healthy', '🌱 Vegan Friendly', '🏋️ Fitness Meal'],
        },
        {
          'id': '4',
          'name': 'Spice Paradise',
          'imageUrl': 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
          'tags': ['🌶️ Spicy', '🍛 Indian', '🔥 Hot'],
        },
      ];
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Navigate to different pages using GoRouter
    switch (index) {
      case 0:
        // Navigate to Home
        context.go(RouteNames.home);
        break;
      case 1:
        // Already on Catalog
        print('Already on Catalog');
        break;
      case 2:
        // Open Scanner or Cart
        // context.go(RouteNames.scanner);
        print('Open Scanner');
        break;
      case 3:
        // Navigate to Orders
        // context.go(RouteNames.orders);
        print('Navigate to Orders');
        break;
      case 4:
        // Navigate to Profile
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
        surfaceTintColor: Colors.white,
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
              Icons.search,
              color: Color(0xFF131316),
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      searchType: 'restaurant',
                      searchData: restaurants
                    ),
                  ),
              );
              print('Open Search');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF875BF7),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF875BF7),
              onRefresh: _loadRestaurants,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: restaurants.length,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return RestaurantCard(
                    name: restaurant['name'],
                    imageUrl: restaurant['imageUrl'],
                    tags: List<String>.from(restaurant['tags']),
                    onTap: () {
                      // Navigate to restaurant detail page using GoRouter
                      context.pushNamed(
                        RouteNames.menu,
                        pathParameters: {
                          'restaurantId': restaurant['id'],
                          'restaurantName': restaurant['name'],
                        },
                      );
                      
                      // Alternative method using context.push():
                      // context.push(
                      //   '/menu/${restaurant['id']}/${Uri.encodeComponent(restaurant['name'])}',
                      // );
                    },
                  );
                },
              ),
            ),
      
    );
  }
}