import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:ecode_verifier/src/features/authentication/screens/Home/qr_scanned.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const bgColor = Color(0xfffafafa);

class Scanner extends StatefulWidget{
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController(
    returnImage: true,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  String productDetails = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Scanner",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Stack(
                      children: [
                        MobileScanner(
                          fit: BoxFit.contain,
                          controller: cameraController,
                          onDetect: (capture) async {
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              debugPrint('Barcode found! ${barcode.rawValue}');
                              // Fetch product data from Open Food Facts API
                              await fetchProductData(barcode.rawValue ?? 'defaultBarcode');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  productDetails,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchProductData(String barcode) async {
    final apiUrl = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse and handle the response data
        final productData = json.decode(response.body);
        debugPrint('Product data: $productData');

        // Extract specific information from the productData and update the UI
        final String productName = productData['product']['product_name'] ?? 'Unknown Product';
        final String ingredients = productData['product']['ingredients_text'] ?? 'No ingredients available';

        setState(() {
          productDetails = 'Product Name: $productName\n\nIngredients: $ingredients';
        });
      } else {
        debugPrint('Failed to fetch product data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching product data: $error');
    }
  }

}