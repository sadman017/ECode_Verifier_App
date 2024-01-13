import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/preference_controller.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/qr_scanned.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const bgColor = Color(0xfffafafa);

class Scanner extends StatefulWidget{
  Scanner({super.key});
  final QuestionController controller = Get.find();
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
                              await fetchProductData(barcode.rawValue ?? 'defaultBarcode', QuestionController());
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
  Future<void> fetchHalalHaramInfo(List<String>? ingredientsTags) async {
    if (ingredientsTags == null) {
      return;
    }

    bool matchFound = false;
    try {
      final halalHaramDoc = await FirebaseFirestore.instance.collection('Halal-Haram').doc('1').get();

      if (halalHaramDoc.exists) {
        final Map<String, dynamic> halalHaramData = halalHaramDoc.data() as Map<String, dynamic>;

        for (String ingredient in ingredientsTags) {
          if (halalHaramData.containsKey(ingredient)) {
            final String halalHaramInfo = halalHaramData[ingredient].toString();
            final String resultMessage =
            halalHaramInfo.isNotEmpty ? 'Halal-Haram Information for $ingredient: $halalHaramInfo' : 'No halal-haram information available.';

            setState(() {
              productDetails += '\n\n$resultMessage';
              matchFound = true;
            });
          }
        }
      }
    } catch (error) {
      debugPrint('Error fetching halal-haram information: $error');
    }

    if (!matchFound) {
      // No match found, show general product details
      setState(() {
        productDetails += '\n\nNo specific halal-haram information available.';
      });
    }
  }
  Future<void> fetchProductData(String barcode, QuestionController controller) async {
    final apiUrl = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse and handle the response data
        final productData = json.decode(response.body);
        debugPrint('Product data: $productData');

        // Extract specific information from the productData
        final Map<String, dynamic> productInfo = productData['product'];

        // Basic Product Information
        final String productName = productInfo['product_name'] ??
            'Unknown Product';
        final String genericName = productInfo['generic_name'] ??
            'Unknown Generic Name';
        final String quantity = productInfo['quantity'] ?? 'Unknown Quantity';
        final String packagingDetails = productInfo['packaging'] ??
            'Unknown Packaging';
        final String brands = productInfo['brands'] ?? 'Unknown Brands';

        // Ingredients
        final String ingredients = productInfo['ingredients_text'] ??
            'No ingredients available';

        // Allergens
        final List<dynamic> allergensList = productInfo['allergens_tags'] ?? [];
        final String allergens = allergensList.isNotEmpty ? allergensList.join(
            ', ') : 'No allergens available';

        // Nutritional Information
        final Map<String, dynamic> nutrients = productInfo['nutriments'] ?? {};
        final String energy = nutrients['energy-kcal'] ?? 'Unknown Energy';
        final String fat = nutrients['fat'] ?? 'Unknown Fat';
        final String carbohydrates = nutrients['carbohydrates'] ??
            'Unknown Carbohydrates';
        final String proteins = nutrients['proteins'] ?? 'Unknown Proteins';
        final String salt = nutrients['salt'] ?? 'Unknown Salt';

        // Labels/Certifications
        final List<dynamic> labels = productInfo['labels_tags'] ?? [];
        final String labelsInfo = labels.isNotEmpty
            ? labels.join(', ')
            : 'No labels/certifications available';

        setState(() {
          productDetails = '''
        Product Name: $productName
        Generic Name: $genericName
        Quantity: $quantity
        Packaging: $packagingDetails
        Brands: $brands

        Ingredients: $ingredients

        Allergens: $allergens

        Nutritional Information:
        - Energy: $energy
        - Fat: $fat
        - Carbohydrates: $carbohydrates
        - Proteins: $proteins
        - Salt: $salt

        Labels/Certifications: $labelsInfo
      ''';
        });
        if (controller.dietType.value == DietType.halalHaram) {
          await fetchHalalHaramInfo(productData['product']['ingredients_tags']);
        }

        // Navigate to ProductDetailsPage with both sets of information
        Get.to(ProductDetailsPage(productDetails: productDetails, halalHaramData: halalHaramData));
      }
    else {
        debugPrint('Failed to fetch product data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching product data: $error');
    }
  }


}