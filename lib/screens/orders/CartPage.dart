import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/screens/orders/orderDetails.dart';

class CartPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String?  restaurantAvatar;
  final int tableNumber;
  final Map<String, int> cart;
  final List<Map<String, dynamic>> menuItems;

  const CartPage({
    super.key,
    required this. restaurantId,
    required this.restaurantName,
    this.restaurantAvatar,
    required this.tableNumber,
    required this.cart,
    required this.menuItems,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const String baseUrl = 'http://167.172.122.176:8000/api';

  late Map<String, int> cart;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    cart = Map.from(widget.cart);
  }

  List<Map<String, dynamic>> get cartItems {
    return widget.menuItems
        .where((item) => cart.containsKey(item['id']))
        .map((item) {
      return {
        ... item,
        'quantity': cart[item['id']] ?? 0,
      };
    }). toList();
  }

  double _getItemPrice(dynamic price) {
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      return double.tryParse(price. replaceAll('\$', ''). replaceAll(',', '')) ??  0;
    }
    return 0;
  }

  double get subtotal {
    double total = 0;
    for (var item in cartItems) {
      total += _getItemPrice(item['price']) * (item['quantity'] as int);
    }
    return total;
  }

  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  void _incrementQuantity(String itemId) {
    setState(() {
      cart[itemId] = (cart[itemId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String itemId) {
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

  void _removeItem(String itemId) {
    setState(() {
      cart.remove(itemId);
    });
  }

  String _formatPrice(dynamic price) {
    if (price is double) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price is int) {
      return '\$${price. toStringAsFixed(2)}';
    } else if (price is String) {
      return price. startsWith('\$') ? price : '\$$price';
    }
    return '\$0. 00';
  }

  Future<void> _submitOrder() async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context). showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Prepare order items
      final orderItems = cartItems.map((item) => {
        'meal_id': int.parse(item['id']),
        'quantity': item['quantity'],
        'price': _getItemPrice(item['price']),
      }).toList();

      // TODO: Replace with actual API call when backend is ready
      // final response = await http.post(
      //   Uri.parse('$baseUrl/orders'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'restaurant_id': int.parse(widget.restaurantId),
      //     'table_number': widget.tableNumber,
      //     'items': orderItems,
      //     'total': total,
      //   }),
      // );
      //
      // if (response.statusCode != 200 && response.statusCode != 201) {
      //   throw Exception('Failed to place order');
      // }
      //
      // final orderData = json.decode(response. body);
      // final orderId = orderData['id']. toString();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Generate a mock order ID
      final orderId = 'Order #${DateTime.now().millisecondsSinceEpoch. toString(). substring(7)}';

      if (mounted) {
        // Navigate to order details page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(
              orderId: orderId,
              title: widget.restaurantName,
              status: 'Current',
              // Pass additional data
              tableNumber: widget.tableNumber,
              items: cartItems,
              total: total,
              restaurantAvatar: widget.restaurantAvatar,
              restaurantId: widget.restaurantId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context). showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF131316)),
          onPressed: () => Navigator.pop(context, cart),
        ),
        title: const Text(
          'Your Order',
          style: TextStyle(
            color: Color(0xFF131316),
            fontSize: 20,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: cart.isEmpty ?  _buildEmptyCart() : _buildCartContent(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey. shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF131316),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items from the menu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, cart),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF875BF7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets. symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Browse Menu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Restaurant Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: widget.restaurantAvatar != null
                            ? Image.asset(
                          'assets/restaurant/${widget.restaurantAvatar}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.restaurant,
                            color: Colors.grey,
                          ),
                        )
                            : const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurantName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green. shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.table_bar,
                                    size: 14,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Table #${widget.tableNumber}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order Items
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...cartItems. map((item) => _buildCartItem(item)). toList(),
                      const Divider(height: 24),
                      _buildPriceRow('Subtotal', _formatPrice(subtotal)),
                      const SizedBox(height: 8),
                      _buildPriceRow('Tax (10%)', _formatPrice(tax)),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatPrice(total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF875BF7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Button
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF875BF7),
                  disabledBackgroundColor: Colors. grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors. white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/meals/${item['imageUrl']}',
              width: 60,
              height: 60,
              fit: BoxFit. cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade200,
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatPrice(item['price']),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF875BF7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Quantity controls
          Column(
            children: [
              GestureDetector(
                onTap: () => _removeItem(item['id']),
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _decrementQuantity(item['id']),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.remove, size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item['quantity']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _incrementQuantity(item['id']),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}