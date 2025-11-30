import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/orders/orderDetails.dart';
import 'package:my_flutter_app/services/auth_service.dart';
import 'package:my_flutter_app/widgets/orders/orderCard.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedIndex = 0; // 0: Current, 1: Paid, 2: Cancelled
  List<Map<String, dynamic>> _orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      debugPrint('Fetching orders for user: $userId');

      final response = await AuthService.authenticatedGet('/orders/user/$userId');

      debugPrint('Orders response status: ${response.statusCode}');
      debugPrint('Orders response body: ${response.body}');

      if (response. statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _orders = data.map((order) {
            // Map backend status to app status
            String status = _mapStatus(order['status']);

            // Format date
            String createdAt = order['created_at'] ??  '';
            String formattedDate = _formatDate(createdAt);

            // Extract restaurant info
            final restaurant = order['restaurant'] ?? {};

            return {
              'id': order['id']. toString(),
              'orderId': 'Order #${order['id']}',
              'title': restaurant['name'] ?? 'Unknown Restaurant',
              'date': formattedDate,
              'status': status,
              'tableNumber': order['table_number'],
              'items': (order['items'] as List<dynamic>?)?. map((item) => {
                'id': item['meal_id'].toString(),
                'meal_id': item['meal_id'],
                'name': 'Item #${item['meal_id']}', // You might want to fetch meal names
                'price': item['price'],
                'quantity': item['quantity'],
              }).toList() ?? [],
              'restaurant': restaurant,
              'restaurantAvatar': restaurant['avatar'],
              'restaurantId': restaurant['id']?. toString(),
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load orders.  Please try again.';
      });
    }
  }

  String _mapStatus(String?  backendStatus) {
    switch (backendStatus?. toLowerCase()) {
      case 'preparing':
      case 'pending':
        return 'Current';
      case 'paid':
      case 'ready':
      case 'completed':
        return 'Paid';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Current';
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day. toString().padLeft(2, '0')}. ${date.month.toString().padLeft(2, '0')}.${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString(). padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  List<Map<String, dynamic>> get _filteredOrders {
    String statusFilter;
    switch (_selectedIndex) {
      case 0:
        statusFilter = 'Current';
        break;
      case 1:
        statusFilter = 'Paid';
        break;
      case 2:
        statusFilter = 'Cancelled';
        break;
      default:
        statusFilter = 'Current';
    }
    return _orders.where((order) => order['status'] == statusFilter).toList();
  }

  double _calculateTotal(List<dynamic> items) {
    double total = 0;
    for (var item in items) {
      final price = item['price'] is double
          ? item['price']
          : (item['price'] as num).toDouble();
      final quantity = item['quantity'] ??  1;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Orders',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Filter Tabs
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTabItem(0, 'Current'),
                    _buildTabItem(1, 'Paid'),
                    _buildTabItem(2, 'Cancelled'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
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
              onPressed: _loadOrders,
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

    final displayOrders = _filteredOrders;

    if (displayOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No ${_selectedIndex == 0 ?  'current' : _selectedIndex == 1 ? 'paid' : 'cancelled'} orders",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
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
      onRefresh: _loadOrders,
      child: ListView.builder(
        itemCount: displayOrders.length,
        itemBuilder: (context, index) {
          final order = displayOrders[index];
          return OrderCard(
            orderId: order['orderId']!,
            title: order['title']!,
            dateTime: order['date']!,
            status: order['status']!,
            onTap: () {
              Navigator. push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(
                    orderId: order['orderId']!,
                    title: order['title']!,
                    status: order['status']!,
                    tableNumber: order['tableNumber'],
                    items: List<Map<String, dynamic>>.from(order['items'] ?? []),
                    total: _calculateTotal(order['items'] ?? []),
                    restaurantAvatar: order['restaurantAvatar'],
                    restaurantId: order['restaurantId'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ?  Colors.black : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }
}