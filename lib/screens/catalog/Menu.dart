import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/catalog/MealDetails.dart';
import 'package:my_flutter_app/screens/catalog/RestaurantAboutPage.dart';
import 'package:my_flutter_app/screens/catalog/SearchPage.dart';
import 'package:my_flutter_app/widgets/catalog/FilterScroll.dart';
import 'package:my_flutter_app/widgets/catalog/MenuItem.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isLoading = true;
  String selectedCategoryId = '';
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> menuItems = [];
  Map<String, int> cart = {}; // itemId: quantity
  String? highlightedMealId; // Track which meal to highlight

  // Restaurant details
  String restaurantImageUrl = '';
  List<String> restaurantTags = [];
  String restaurantDescription = '';

  // ScrollController for GridView
  final ScrollController _scrollController = ScrollController();
  // GlobalKeys for each menu item
  final Map<String, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    _loadRestaurantData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurantData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      categories = _getCategoriesForRestaurant(widget.restaurantId);
      menuItems = _getMenuItemsForRestaurant(widget.restaurantId);

      // Create keys for each menu item
      for (var item in menuItems) {
        _itemKeys[item['id']] = GlobalKey();
      }

      // Get restaurant details
      final restaurantData = _getRestaurantDetails(widget.restaurantId);
      restaurantImageUrl = restaurantData['imageUrl'];
      restaurantTags = List<String>.from(restaurantData['tags']);
      restaurantDescription = restaurantData['description'];

      selectedCategoryId = categories.isNotEmpty ? categories.first['id'] : '';
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> _getCategoriesForRestaurant(String restaurantId) {
    if (restaurantId == '1' || restaurantId == '2') {
      return [
        {'id': 'soups', 'name': 'Soups', 'icon': '🍜'},
        {'id': 'salads', 'name': 'Salads', 'icon': '🥗'},
        {'id': 'sushi', 'name': 'Sushi', 'icon': '🍣'},
        {'id': 'japanese', 'name': 'Japanese Specials', 'icon': '🍱'},
        {'id': 'grilled', 'name': 'Grilled Meats', 'icon': '🥩'},
        {'id': 'chicken', 'name': 'Chicken Dishes', 'icon': '🍗'},
        {'id': 'seafood', 'name': 'Seafood', 'icon': '🐟'},
      ];
    }

    return [
      {'id': 'all', 'name': 'All', 'icon': '🍽️'},
      {'id': 'popular', 'name': 'Popular', 'icon': '⭐'},
      {'id': 'mains', 'name': 'Main Dishes', 'icon': '🍛'},
    ];
  }

  Map<String, dynamic> _getRestaurantDetails(String restaurantId) {
    if (restaurantId == '1') {
      return {
        'imageUrl':
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600',
        'tags': ['🔥 Grill Expert', '🥩 Premium Beef', '🥬 Fresh'],
        'description':
            'Experience authentic Japanese flavors at ${widget.restaurantName}. We pride ourselves on using only the freshest ingredients and traditional cooking methods to bring you the best dining experience. Our expert chefs craft each dish with passion and attention to detail, ensuring every bite is a culinary delight.',
      };
    }

    if (restaurantId == '2') {
      return {
        'imageUrl':
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600',
        'tags': ['🍕 Italian Style', '🌿 Organic', '⚡ Fast Service'],
        'description':
            'Welcome to ${widget.restaurantName}, where Italian tradition meets modern cuisine. Our wood-fired pizzas and handmade pasta are crafted with love using authentic recipes passed down through generations. Every ingredient is carefully selected to ensure the highest quality.',
      };
    }

    return {
      'imageUrl':
          'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=600',
      'tags': ['⭐ Popular', '🍽️ Fine Dining', '👨‍🍳 Expert Chefs'],
      'description':
          'At ${widget.restaurantName}, we believe in creating memorable dining experiences. Our menu features a carefully curated selection of dishes made with the finest ingredients. Whether you\'re here for a quick bite or a leisurely meal, we\'re committed to exceeding your expectations.',
    };
  }

  List<Map<String, dynamic>> _getMenuItemsForRestaurant(String restaurantId) {
    return [
      {
        'id': '1',
        'name': 'Spicy Salmon Roll',
        'price': '\$6.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'categoryId': 'sushi',
      },
      {
        'id': '2',
        'name': 'Philadelphia Roll',
        'price': '\$7.49',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'categoryId': 'sushi',
      },
      {
        'id': '3',
        'name': 'Rainbow Roll asdfghj jhgfd cgyuuhv',
        'price': '\$10.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'categoryId': 'sushi',
      },
      {
        'id': '4',
        'name': 'California Roll',
        'price': '\$6.49',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'categoryId': 'sushi',
      },
      {
        'id': '5',
        'name': 'Dragon Roll',
        'price': '\$12.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'categoryId': 'sushi',
      },
      {
        'id': '6',
        'name': 'Tuna Roll',
        'price': '\$8.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'categoryId': 'sushi',
      },
      {
        'id': '7',
        'name': 'Miso Soup',
        'price': '\$4.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
        'categoryId': 'soups',
      },
      {
        'id': '8',
        'name': 'Caesar Salad',
        'price': '\$8.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        'categoryId': 'salads',
      },
      {
        'id': '9',
        'name': 'Grilled Chicken',
        'price': '\$14.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
        'categoryId': 'chicken',
      },
      {
        'id': '10',
        'name': 'Salmon Teriyaki',
        'price': '\$16.99',
        'imageUrl':
            'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
        'categoryId': 'seafood',
      },
    ];
  }

  List<Map<String, dynamic>> get filteredMenuItems {
    return menuItems
        .where((item) => item['categoryId'] == selectedCategoryId)
        .toList();
  }

  void _addToCart(String itemId) {
    setState(() {
      cart[itemId] = (cart[itemId] ?? 0) + 1;
    });
  }

  void _removeFromCart(String itemId) {
    setState(() {
      if (cart[itemId] != null) {
        if (cart[itemId]! > 1) {
          cart[itemId] = cart[itemId]! - 1;
        } else {
          cart.remove(itemId);
        }
      }
    });
  }

  int get totalCartItems {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _scrollToMeal(String mealId) {
    // Wait for the frame to complete before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[mealId];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.2, // Position the item 20% from the top
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF131316),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF131316),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    searchType: 'meal',
                    searchData: menuItems.map((item) {
                      return {
                        ...item,
                        'restaurantId': widget.restaurantId,
                      };
                    }).toList(),
                  ),
                ),
              );

              // If a meal was selected from search
              if (result != null && result is Map<String, dynamic>) {
                final categoryId = result['categoryId'];
                final mealId = result['mealId'];
                final shouldScroll = result['scrollToMeal'] ?? false;

                if (categoryId != null && categoryId.isNotEmpty) {
                  setState(() {
                    selectedCategoryId = categoryId;
                    if (shouldScroll && mealId != null) {
                      highlightedMealId = mealId;
                      // Scroll to the meal after the category is updated
                      _scrollToMeal(mealId);
                      
                      // Clear highlight after 2 seconds
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            highlightedMealId = null;
                          });
                        }
                      });
                    }
                  });
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Color(0xFF131316),
            ),
            onPressed: () {
              RestaurantAboutModal.show(
                context,
                restaurantName: widget.restaurantName,
                imageUrl: restaurantImageUrl,
                tags: restaurantTags,
                description: restaurantDescription,
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF875BF7),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 8),
                  child: Text(
                    widget.restaurantName,
                    style: const TextStyle(
                      color: Color(0xFF131316),
                      fontSize: 20,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Category badges
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: restaurantTags.map((tag) {
                      Color bgColor = Colors.grey.shade50;
                      if (tag.contains('🔥') || tag.contains('Grill')) {
                        bgColor = Colors.orange.shade50;
                      } else if (tag.contains('🥩') ||
                          tag.contains('Beef') ||
                          tag.contains('Italian')) {
                        bgColor = Colors.red.shade50;
                      } else if (tag.contains('🥬') ||
                          tag.contains('Fresh') ||
                          tag.contains('Organic')) {
                        bgColor = Colors.green.shade50;
                      } else if (tag.contains('⚡') || tag.contains('Fast')) {
                        bgColor = Colors.blue.shade50;
                      }

                      return _buildBadge(tag, bgColor);
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 8),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE0E0E0),
                ),

                // Main content: Filter scroll (left) + Menu items (right)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Side - Category Filter (Vertical)
                      CategoryFilterWidget(
                        categories: categories,
                        selectedCategoryId: selectedCategoryId,
                        onCategorySelected: (categoryId) {
                          setState(() {
                            selectedCategoryId = categoryId;
                            highlightedMealId = null; // Clear highlight when changing category manually
                          });
                        },
                      ),

                      // Right Side - Menu Items Grid
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            controller: _scrollController,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 160,   // max card width (try 130–160)
                              childAspectRatio: 0.5,    // adjust height ratio for your card
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: filteredMenuItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredMenuItems[index];
                              final quantity = cart[item['id']] ?? 0;
                              final isHighlighted = highlightedMealId == item['id'];
                              final itemId = item['id'];
                              
                              // Ensure key exists, create if not
                              if (!_itemKeys.containsKey(itemId)) {
                                _itemKeys[itemId] = GlobalKey();
                              }

                              return Container(
                                key: _itemKeys[itemId],
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: isHighlighted
                                      ? Border.all(
                                          color: const Color(0xFF875BF7),
                                          width: 3,
                                        )
                                      : null,
                                  boxShadow: isHighlighted
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF875BF7)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : null,
                                ),
                                child: MenuItemCard(
                                  id: itemId,
                                  name: item['name'],
                                  price: item['price'],
                                  imageUrl: item['imageUrl'],
                                  quantity: quantity,
                                  onAdd: _addToCart,
                                  onRemove: _removeFromCart,
                                  onTap: () {
                                    MealDetailModal.show(context,
                                        mealId: itemId,
                                        restaurantId: widget.restaurantId);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: totalCartItems > 0
          ? Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  print('Go to cart with $totalCartItems items');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF875BF7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Go To Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBadge(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: backgroundColor.computeLuminance() > 0.5
              ? Colors.black87
              : Colors.white,
          fontSize: 12,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}