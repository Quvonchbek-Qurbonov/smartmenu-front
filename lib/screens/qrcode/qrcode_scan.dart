import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanScreen extends StatefulWidget {
  const QRCodeScanScreen({super.key});  // 👈 CHANGE THIS LINE

  @override
  State<QRCodeScanScreen> createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;
  String? scannedCode;
  bool isTorchOn = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
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
              if (!isScanned) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    setState(() {
                      isScanned = true;
                      scannedCode = barcode.rawValue;
                    });
                    _showScannedResult(barcode.rawValue!);
                    break;
                  }
                }
              }
            },
          ),
          // Scanning overlay
          if (!isScanned)
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
          if (!isScanned)
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
        ],
      ),
    );
  }

  void _showScannedResult(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned'),
        content: SelectableText(
          code,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isScanned = false;
                scannedCode = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Scan Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // You can navigate or pass the scanned code here
              // Example: Navigator.pop(context, code);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}