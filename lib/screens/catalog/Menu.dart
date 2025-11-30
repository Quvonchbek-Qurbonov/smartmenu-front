import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/screens/catalog/MealDetails.dart';
import 'package:my_flutter_app/screens/catalog/RestaurantAboutPage.dart';
import 'package:my_flutter_app/screens/catalog/SearchPage.dart';
import 'package:my_flutter_app/widgets/catalog/FilterScroll.dart';
import 'package:my_flutter_app/widgets/catalog/MenuItem.dart';
import 'package:my_flutter_app/widgets/catalog/MenuItemWithButton.dart';
import 'package:my_flutter_app/screens/orders/CartPage.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String?  restaurantDescription;
  final String? restaurantAvatar;
  final String? restaurantLocation;
  final bool showCartButtons;
  final int? tableNumber;

  const RestaurantDetailPage({
    super.key,
    required this. restaurantId,
    required this.restaurantName,
    this.restaurantDescription,
    this.restaurantAvatar,
    this.restaurantLocation,
    this.showCartButtons = false,
    this.tableNumber,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  static const String baseUrl = 'http://167.172.122.176:8000/api';

  bool isLoading = true;
  String? errorMessage;
  String selectedCategoryId = '';
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> menuItems = [];
  Map<String, int> cart = {};
  String?  highlightedMealId;

  List<String> restaurantTags = ['⭐ Popular', '🍽️ Fine Dining', '👨‍🍳 Expert Chefs'];

  final ScrollController _scrollController = ScrollController();
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

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    final url = '$baseUrl/category/restaurant/${widget.restaurantId}';
    debugPrint('Fetching categories from: $url');

    try {
      final response = await http. get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => {
          'id': item['id']. toString(),
          'name': item['name'] ?? 'Unknown',
          'icon': item['icon'] ?? 'default. png',
        }).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMealsForCategory(String categoryId) async {
    final url = '$baseUrl/meals/category/$categoryId';
    debugPrint('Fetching meals from: $url');

    try {
      final response = await http. get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json. decode(response.body);
        return data.map((item) => {
          'id': item['id'].toString(),
          'name': item['name'] ?? 'Unknown',
          'price': item['price']?.toDouble() ?? 0.0,
          'categoryId': item['category_id'].toString(),
          'imageUrl': item['image_url'] ?? 'default.png',
          'description': item['description'] ??  '',
        }).toList();
      } else {
        throw Exception('Failed to load meals: ${response. statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching meals: $e');
      return [];
    }
  }

  Future<void> _loadRestaurantData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      categories = await _fetchCategories();

      if (categories.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'No categories found for this restaurant';
        });
        return;
      }

      selectedCategoryId = categories. first['id'];

      List<Map<String, dynamic>> allMeals = [];
      for (var category in categories) {
        final meals = await _fetchMealsForCategory(category['id']);
        allMeals.addAll(meals);
      }

      menuItems = allMeals;

      for (var item in menuItems) {
        _itemKeys[item['id']] = GlobalKey();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load restaurant data: $e';
      });
    }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[mealId];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves. easeInOut,
          alignment: 0.2,
        );
      }
    });
  }

  String _formatPrice(dynamic price) {
    if (price is double) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price is int) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price is String) {
      return price. startsWith('\$') ? price : '\$$price';
    }
    return '\$0.00';
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
          onPressed: () => Navigator. pop(context),
        ),
        title: widget.tableNumber != null
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green. shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.table_bar,
                size: 16,
                color: Colors. green.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                'Table ${widget.tableNumber}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        )
            : null,
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
                    searchData: menuItems. map((item) {
                      return {
                        ...item,
                        'restaurantId': widget.restaurantId,
                        'price': _formatPrice(item['price']),
                        'imageUrl': 'assets/meals/${item['imageUrl']}',
                      };
                    }). toList(),
                  ),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                final categoryId = result['categoryId'];
                final mealId = result['mealId'];
                final shouldScroll = result['scrollToMeal'] ?? false;

                if (categoryId != null && categoryId. isNotEmpty) {
                  setState(() {
                    selectedCategoryId = categoryId;
                    if (shouldScroll && mealId != null) {
                      highlightedMealId = mealId;
                      _scrollToMeal(mealId);

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
              String imageUrl = '';
              if (widget.restaurantAvatar != null && widget.restaurantAvatar!. isNotEmpty) {
                imageUrl = 'assets/restaurant/${widget.restaurantAvatar}';
              }

              RestaurantAboutModal.show(
                context,
                restaurantName: widget.restaurantName,
                imageUrl: imageUrl,
                tags: restaurantTags,
                description: widget.restaurantDescription ??
                    'Welcome to ${widget.restaurantName}.  We serve delicious food with the finest ingredients.',
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: totalCartItems > 0 && widget.tableNumber != null
          ? Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () async {
            final updatedCart = await Navigator.push<Map<String, int>>(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(
                  restaurantId: widget.restaurantId,
                  restaurantName: widget.restaurantName,
                  restaurantAvatar: widget.restaurantAvatar,
                  tableNumber: widget. tableNumber! ,
                  cart: cart,
                  menuItems: menuItems,
                ),
              ),
            );

            if (updatedCart != null) {
              setState(() {
                cart = updatedCart;
              });
            }
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Go To Order',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors. white. withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalCartItems',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              onPressed: _loadRestaurantData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: restaurantTags.map((tag) {
              Color bgColor = Colors.grey.shade50;
              if (tag. contains('🔥') || tag.contains('Grill')) {
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

        if (widget.restaurantLocation != null && widget.restaurantLocation!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  widget.restaurantLocation!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors. grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 8),

        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFE0E0E0),
        ),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryFilterWidget(
                categories: categories. map((cat) => {
                  'id': cat['id'],
                  'name': cat['name'],
                  'icon': cat['icon'],
                }).toList(),
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: (categoryId) {
                  setState(() {
                    selectedCategoryId = categoryId;
                    highlightedMealId = null;
                  });
                },
              ),

              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: filteredMenuItems.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors. grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items in this category',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                      : GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenuItems[index];
                      final quantity = cart[item['id']] ?? 0;
                      final isHighlighted = highlightedMealId == item['id'];
                      final itemId = item['id'];

                      if (! _itemKeys.containsKey(itemId)) {
                        _itemKeys[itemId] = GlobalKey();
                      }

                      return Container(
                        key: _itemKeys[itemId],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: isHighlighted
                              ?  Border.all(
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
                        child: widget.showCartButtons
                            ? MenuItemCardBtn(
                          id: itemId,
                          name: item['name'],
                          price: _formatPrice(item['price']),
                          imageUrl: 'assets/meals/${item['imageUrl']}',
                          quantity: quantity,
                          onAdd: _addToCart,
                          onRemove: _removeFromCart,
                          onTap: () {
                            MealDetailModal.show(
                              context,
                              mealId: itemId,
                              restaurantId: widget.restaurantId,
                              name: item['name'],
                              description: item['description'],
                              price: _formatPrice(item['price']),
                              imageUrl: 'assets/meals/${item['imageUrl']}',
                            );
                          },
                        )
                            : MenuItemCard(
                          id: itemId,
                          name: item['name'],
                          price: _formatPrice(item['price']),
                          imageUrl: 'assets/meals/${item['imageUrl']}',
                          quantity: quantity,
                          onAdd: _addToCart,
                          onRemove: _removeFromCart,
                          onTap: () {
                            MealDetailModal.show(
                              context,
                              mealId: itemId,
                              restaurantId: widget.restaurantId,
                              name: item['name'],
                              description: item['description'],
                              price: _formatPrice(item['price']),
                              imageUrl: 'assets/meals/${item['imageUrl']}',
                            );
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
          color: backgroundColor. computeLuminance() > 0.5
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