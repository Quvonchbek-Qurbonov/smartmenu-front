import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

import '../catalog/Menu.dart';

class QRCodeScanScreen extends StatefulWidget {
  const QRCodeScanScreen({super.key});
  @override
  State<QRCodeScanScreen> createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;
  String? scannedCode;
  bool isTorchOn = false;
  bool isLoading = false;

  static const String baseUrl = 'http://167.172.122.176:8000/api';

  @override
  void dispose() {
    cameraController. dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchRestaurantData(int restaurantId) async {
    final url = '$baseUrl/restaurants/$restaurantId';
    debugPrint('Fetching from URL: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load restaurant data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching restaurant: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                isTorchOn = !isTorchOn;
              });
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (! isScanned && ! isLoading) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    setState(() {
                      isScanned = true;
                      scannedCode = barcode. rawValue;
                    });
                    _processScannedCode(barcode.rawValue!);
                    break;
                  }
                }
              }
            },
          ),
          // Scanning overlay
          if (! isScanned)
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          // Instructions
          if (! isScanned)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Align QR code within the frame',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          // Loading indicator
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading restaurant info...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _processScannedCode(String code) async {
    Map<String, dynamic>? qrData;
    try {
      qrData = json.decode(code);
    } catch (e) {
      _showErrorDialog('Invalid QR code format');
      return;
    }

    if (qrData == null || qrData['restaurant_id'] == null) {
      _showErrorDialog('Invalid QR code: missing restaurant_id');
      return;
    }

    final int restaurantId = qrData['restaurant_id'];
    final int?  tableNumber = qrData['table_number'];

    setState(() {
      isLoading = true;
    });

    final restaurantData = await fetchRestaurantData(restaurantId);

    setState(() {
      isLoading = false;
    });

    if (restaurantData != null) {
      _showRestaurantDialog(restaurantData, tableNumber);
    } else {
      _showErrorDialog('Failed to load restaurant information');
    }
  }

  void _showRestaurantDialog(Map<String, dynamic> restaurant, int?  tableNumber) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: RestaurantCard(
            name: restaurant['name'] ?? 'Restaurant',
            avatar: restaurant['avatar'],
            tableNumber: tableNumber,
            onTap: () {
              Navigator.pop(context);
              _navigateToRestaurantDetail(restaurant, tableNumber);
            },
          ),
        ),
      ),
    ). then((_) {
      setState(() {
        isScanned = false;
        scannedCode = null;
      });
    });
  }

  void _navigateToRestaurantDetail(Map<String, dynamic> restaurant, int? tableNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantDetailPage(
          restaurantId: restaurant['id']. toString(),
          restaurantName: restaurant['name'] ??  'Restaurant',
          restaurantDescription: restaurant['description'],
          restaurantAvatar: restaurant['avatar'],
          restaurantLocation: restaurant['location'],
          showCartButtons: true,
          tableNumber: tableNumber,
        ),
      ),
    ). then((_) {
      setState(() {
        isScanned = false;
        scannedCode = null;
      });
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isScanned = false;
                scannedCode = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String?  avatar;
  final int? tableNumber;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this. name,
    this.avatar,
    this.tableNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/restaurant/${avatar ?? 'default. png'}',
                width: 120,
                height: 120,
                fit: BoxFit. cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Colors. grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (tableNumber != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green. shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.table_bar,
                      size: 18,
                      color: Colors. green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Table $tableNumber',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors. green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  'Tap to view menu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}