import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';
import 'package:my_flutter_app/screens/catalog/Menu.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  final String title;
  final String status;

  const OrderDetailPage({
    Key? key,
    required this.orderId,
    required this.title,
    required this.status,
  }) : super(key: key);

  // Calculate total amount
  double _calculateTotal() {
    // In a real app, this would sum up actual cart items
    return 67.0;
  }

  // Get order items
  List<Map<String, dynamic>> _getOrderItems() {
    return [
      {'name': 'Sushi Rainbow Roll 1x', 'price': 45.0},
      {'name': 'Green Salad 1x', 'price': 10.0},
      {'name': 'Carrot Juice', 'price': 10.0},
      {'name': 'Water', 'price': 2.0},
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Logic for AppBar Title: 'Paid'/'Cancelled' -> Order ID, 'Current' -> "Order detail"
    final String appBarTitle =
        (status == 'Paid' || status == 'Cancelled') ? orderId : "Order detail";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appBarTitle,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    // Restaurant Card - Separated Container
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
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://via.placeholder.com/150'),
                                fit: BoxFit.cover,
                              ),
                            ),
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

                    // Order Details Container - Separated
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow("Order", orderId),
                          _buildDetailRow("Table", "#12"),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          _buildDetailRow("Sushi Rainbow Roll 1x", "\$45"),
                          _buildDetailRow("Green Salad 1x", "\$10"),
                          _buildDetailRow("Carrot Juice", "\$10"),
                          _buildDetailRow("Water", "\$2"),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("\$67",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Status",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: status == 'Current'
                                      ? const Color(0xFFF3F0FF)
                                      : (status == 'Paid'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status == 'Current'
                                      ? "Waiting Payment"
                                      : status,
                                  style: TextStyle(
                                      color: status == 'Current'
                                          ? const Color(0xFF8B5CF6)
                                          : (status == 'Paid'
                                              ? Colors.green
                                              : Colors.red),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Payment Info Container - Only for Paid status
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
                              child: const Icon(Icons.credit_card,
                                  color: Color(0xFF8B5CF6), size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Recharged With Card",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                SizedBox(height: 2),
                                Text("4624 **** **** **55",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
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

            // DYNAMIC BOTTOM SECTION - Only for Current status
            if (status == 'Current')
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -4),
                        blurRadius: 10),
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
                            context.pushNamed(
                              RouteNames.payment,
                              extra: {
                                'orderId': orderId,
                                'totalAmount': _calculateTotal(),
                                'orderDetails': {
                                  'restaurantName': title,
                                  'items': _getOrderItems(),
                                  'table': '#12',
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
                          child: const Text(
                            "Pay Now",
                            style: TextStyle(
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
                                restaurantId: '1',
                                restaurantName: title,
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
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }
}