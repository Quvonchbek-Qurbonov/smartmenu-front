import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/catalog/catalog_screen.dart';
import 'package:my_flutter_app/screens/home/HomePage.dart';
import 'package:my_flutter_app/screens/orders/OrderPage.dart';
import 'package:my_flutter_app/widgets/common/BottomBar.dart';
import 'package:my_flutter_app/screens/qrcode/qrcode_scan.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // 👈 Important for using const in router

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Pages for each bottom nav item
  final List<Widget> _pages = const [
    Center(child: MenuSnapHomePage()),
    Center(child: CatalogPage()),
    Center(child: Text("Scan Page")),
    Center(child: OrdersPage()),
    Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
          
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
