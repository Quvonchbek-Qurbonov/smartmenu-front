import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/orders/orderDetails.dart';
import 'package:my_flutter_app/widgets/orders/orderCard.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedIndex = 0; // 0: Current, 1: Paid, 2: Cancelled

  final List<Map<String, String>> _orders = [
    {
      'id': 'Order #0943983',
      'title': 'Zen Bowl Premium',
      'date': '07.06.2025, 10:30',
      'status': 'Current'
    },
    {
      'id': 'Order #0943984',
      'title': 'Flavoria',
      'date': '07.06.2025, 10:30',
      'status': 'Current'
    },
    // Added Paid/Cancelled orders to test filtering
    {
      'id': 'Order #0943001',
      'title': 'Sushi Platter',
      'date': '05.06.2025, 12:00',
      'status': 'Paid'
    },
    {
      'id': 'Order #0942999',
      'title': 'Burger King',
      'date': '01.06.2025, 18:45',
      'status': 'Cancelled'
    },
  ];

  List<Map<String, String>> get _filteredOrders {
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

  @override
  Widget build(BuildContext context) {
    final displayOrders = _filteredOrders;

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

              // List
              Expanded(
                child: displayOrders.isEmpty
                    ? Center(
                        child: Text(
                          "No ${_selectedIndex == 0 ? 'current' : _selectedIndex == 1 ? 'paid' : 'cancelled'} orders",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayOrders.length,
                        itemBuilder: (context, index) {
                          final order = displayOrders[index];
                          return OrderCard(
                            orderId: order['id']!,
                            title: order['title']!,
                            dateTime: order['date']!,
                            status: order['status']!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(
                                    orderId: order['id']!,
                                    title: order['title']!,
                                    status: order['status']!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
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
                color: isSelected ? Colors.black : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }
}