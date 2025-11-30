import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';
import 'package:my_flutter_app/screens/catalog/Menu.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  final String title;
  final String status;
  final int?  tableNumber;
  final List<Map<String, dynamic>>? items;
  final double? total;
  final String? restaurantAvatar;
  final String? restaurantId;

  const OrderDetailPage({
    Key? key,
    required this.orderId,
    required this.title,
    required this.status,
    this. tableNumber,
    this.items,
    this.total,
    this.restaurantAvatar,
    this.restaurantId,
  }) : super(key: key);

  double _calculateTotal() {
    if (total != null) return total!;
    if (items != null) {
      double sum = 0;
      for (var item in items!) {
        double price = 0;
        if (item['price'] is double) {
          price = item['price'];
        } else if (item['price'] is int) {
          price = item['price']. toDouble();
        } else if (item['price'] is String) {
          price = double.tryParse(item['price']. replaceAll('\$', '')) ?? 0;
        }
        sum += price * (item['quantity'] ?? 1);
      }
      return sum;
    }
    return 67.0;
  }

  List<Map<String, dynamic>> _getOrderItems() {
    if (items != null) return items!;
    return [
    {'name': 'Sushi Rainbow Roll', 'price': 45.0, 'quantity': 1},
    {'name': 'Green Salad', 'price': 10.0, 'quantity': 1},
    {'name': 'Carrot Juice', 'price': 10.0, 'quantity': 1},
    {'name': 'Water', 'price': 2.0, 'quantity': 1},
    ];
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
    final String appBarTitle =
    (status == 'Paid' || status == 'Cancelled') ? orderId : "Order detail";
    final orderItems = _getOrderItems();
    final orderTotal = _calculateTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (status == 'Current') {
              context.go(RouteNames.home);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
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
                            child: _buildRestaurantImage(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _buildTag("Grill Expert", Colors.orange),
                                    const SizedBox(width: 8),
                                    _buildTag("Premium Beef", Colors.purple),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Order Details Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow("Order", orderId),
                          _buildDetailRow("Table", "#${tableNumber ?? 12}"),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // Order items
                          ...orderItems.map((item) {
                            final quantity = item['quantity'] ?? 1;
                            final name = item['name'];
                            final price = item['price'];
                            return _buildDetailRow(
                              '$name ${quantity}x',
                              _formatPrice(price),
                            );
                          }). toList(),

                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatPrice(orderTotal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getStatusText(),
                                  style: TextStyle(
                                    color: _getStatusTextColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Payment Info - Only for Paid status
                    if (status == 'Paid') ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE7FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.credit_card,
                                color: Color(0xFF8B5CF6),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Recharged With Card",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "4624 **** **** **55",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Section - Only for Current status
            if (status == 'Current')
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Use 'payment' (route name) instead of RouteNames.payment (route path)
                            context.pushNamed(
                              'payment',
                              extra: {
                                'orderId': orderId,
                                'totalAmount': orderTotal,
                                'orderDetails': {
                                  'restaurantName': title,
                                  'items': orderItems,
                                  'table': '#${tableNumber ?? 12}',
                                },
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Pay Now - ${_formatPrice(orderTotal)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailPage(
                                restaurantId: restaurantId ??  '1',
                                restaurantName: title,
                                restaurantAvatar: restaurantAvatar,
                                showCartButtons: true,
                                tableNumber: tableNumber,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Add something else",
                          style: TextStyle(color: Color(0xFF8B5CF6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantImage() {
    if (restaurantAvatar != null && restaurantAvatar!.isNotEmpty) {
      return Image.asset(
        'assets/restaurant/$restaurantAvatar',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.restaurant,
          color: Colors.grey,
        ),
      );
    }
    return const Icon(Icons.restaurant, color: Colors.grey);
  }

  Color _getStatusColor() {
    switch (status) {
      case 'Current':
        return const Color(0xFFF3F0FF);
      case 'Paid':
        return Colors.green. withOpacity(0.1);
      case 'Cancelled':
        return Colors.red. withOpacity(0.1);
      default:
        return const Color(0xFFF3F0FF);
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 'Current':
        return const Color(0xFF8B5CF6);
      case 'Paid':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'Current':
        return "Waiting Payment";
      case 'Paid':
        return "Paid";
      case 'Cancelled':
        return "Cancelled";
      default:
        return status;
    }
  }

  Widget _buildTag(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}