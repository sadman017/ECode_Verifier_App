import 'package:dio/dio.dart';
import 'package:ecode_verifier/src/constants/colors.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/preference_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';


class Scanner extends StatefulWidget{
  Scanner({super.key});
  final QuestionController controller = Get.find();
  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  // MobileScannerController cameraController = MobileScannerController(
  //   returnImage: true,
  //   facing: CameraFacing.back,
  //   torchEnabled: false,
  // );
  String productDetails = '';
  String result = "891030740398";
  // Future<void> scanBarcodeNormal()async{
  //   String barcodeScanRes;
  //   try{
  //      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     getProduct(barcodeScanRes);
      
  //   }on PlatformException{
  //     barcodeScanRes = "Fail to read Barcode";
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }
  
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
     var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? secondaryColor : primaryColor,
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
                    child: Column(
                      children: [
                        // MobileScanner(
                        //   fit: BoxFit.contain,
                        //   controller: cameraController,
                        //   onDetect: (capture) async {
                        //     final List<Barcode> barcodes = capture.barcodes;
                        //     for (final barcode in barcodes) {
                        //       debugPrint('Barcode found! ${barcode.rawValue}');
                        //       // Fetch product data from Open Food Facts API
                        //       await fetchProductData(barcode.rawValue ?? 'defaultBarcode', QuestionController());
                        //     }
                        //   },
                        // ),
                        // ElevatedButton(onPressed: () async{
                        //   var res = await Get.to( const ProductDetailsPage());
                        //   setState(() {
                        //     if (res is String){
                        //       result_barcode =res;
                        //     }
                        //   });
                        // }, child: const Text('Open Scanner'),
                        // ),
                        // Text("Barcode Result: $result_barcode"),
                       
                         ElevatedButton(
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              setState(() {
                if (res is String) {
                  result = res;
                }
              });
            },
            child: const Text('Open Scanner'),
          ),
          const SizedBox(
            width: double.maxFinite,
            height: 20,
          ),
          Text('Barcode result: $result'),
          const SizedBox(
            height: 30,
          ),
          if (result != '')
            ApiCallWidget(
              code: result,
            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // const Gap(16),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Text(
            //       productDetails,
            //       style: const TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  // Future<void> fetchHalalHaramInfo(List<String>? ingredientsTags) async {
  //   if (ingredientsTags == null) {
  //     return;
  //   }

  //   bool matchFound = false;
  //   try {
  //     final halalHaramDoc = await FirebaseFirestore.instance.collection('Halal-Haram').doc('1').get();

  //     if (halalHaramDoc.exists) {
  //       final Map<String, dynamic> halalHaramData = halalHaramDoc.data() as Map<String, dynamic>;

  //       for (String ingredient in ingredientsTags) {
  //         if (halalHaramData.containsKey(ingredient)) {
  //           final String halalHaramInfo = halalHaramData[ingredient].toString();
  //           final String resultMessage =
  //           halalHaramInfo.isNotEmpty ? 'Halal-Haram Information for $ingredient: $halalHaramInfo' : 'No halal-haram information available.';

  //           setState(() {
  //             productDetails += '\n\n$resultMessage';
  //             matchFound = true;
  //           });
  //         }
  //       }
  //     }
  //   } catch (error) {
  //     debugPrint('Error fetching halal-haram information: $error');
  //   }

  //   if (!matchFound) {
  //     // No match found, show general product details
  //     setState(() {
  //       productDetails += '\n\nNo specific halal-haram information available.';
  //     });
  //   }
  // }

  // Future<Product?> getProduct(resultBarcode) async {
  // var barcode = resultBarcode;
  //  final ProductQueryConfiguration configuration = ProductQueryConfiguration(
  //   barcode,
  //   language: OpenFoodFactsLanguage.ENGLISH,
  //   fields: [ProductField.ALL],
  //   version: ProductQueryVersion.v3,
  // );
  // final ProductResultV3 result =
  //     await OpenFoodAPIClient.getProductV3(configuration);

  // if (result.status == ProductResultV3.statusSuccess) {
  //   return result.product;
  // } else {
  //   throw Exception('product not found, please insert data for $barcode');
  // }
// }
  // Future<void> fetchProductData(String barcode, QuestionController controller) async {
  //   final apiUrl = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));

  //     if (response.statusCode == 200) {
  //       // Parse and handle the response data
  //       final productData = json.decode(response.body);
  //       debugPrint('Product data: $productData');

  //       // Extract specific information from the productData
  //       final Map<String, dynamic> productInfo = productData['product'];

  //       // Basic Product Information
  //       final String productName = productInfo['product_name'] ??
  //           'Unknown Product';
  //       final String genericName = productInfo['generic_name'] ??
  //           'Unknown Generic Name';
  //       final String quantity = productInfo['quantity'] ?? 'Unknown Quantity';
  //       final String packagingDetails = productInfo['packaging'] ??
  //           'Unknown Packaging';
  //       final String brands = productInfo['brands'] ?? 'Unknown Brands';

  //       // Ingredients
  //       final String ingredients = productInfo['ingredients_text'] ??
  //           'No ingredients available';

  //       // Allergens
  //       final List<dynamic> allergensList = productInfo['allergens_tags'] ?? [];
  //       final String allergens = allergensList.isNotEmpty ? allergensList.join(
  //           ', ') : 'No allergens available';

  //       // Nutritional Information
  //       final Map<String, dynamic> nutrients = productInfo['nutriments'] ?? {};
  //       final String energy = nutrients['energy-kcal'] ?? 'Unknown Energy';
  //       final String fat = nutrients['fat'] ?? 'Unknown Fat';
  //       final String carbohydrates = nutrients['carbohydrates'] ??
  //           'Unknown Carbohydrates';
  //       final String proteins = nutrients['proteins'] ?? 'Unknown Proteins';
  //       final String salt = nutrients['salt'] ?? 'Unknown Salt';

  //       // Labels/Certifications
  //       final List<dynamic> labels = productInfo['labels_tags'] ?? [];
  //       final String labelsInfo = labels.isNotEmpty
  //           ? labels.join(', ')
  //           : 'No labels/certifications available';

  //       setState(() {
  //         productDetails = '''
  //       Product Name: $productName
  //       Generic Name: $genericName
  //       Quantity: $quantity
  //       Packaging: $packagingDetails
  //       Brands: $brands

  //       Ingredients: $ingredients

  //       Allergens: $allergens

  //       Nutritional Information:
  //       - Energy: $energy
  //       - Fat: $fat
  //       - Carbohydrates: $carbohydrates
  //       - Proteins: $proteins
  //       - Salt: $salt

  //       Labels/Certifications: $labelsInfo
  //     ''';
  //       });
  //       if (controller.dietType.value == DietType.halalHaram) {
  //         await fetchHalalHaramInfo(productData['product']['ingredients_tags']);
  //       }

  //       // Navigate to ProductDetailsPage with both sets of information
  //       Get.to(ProductDetailsPage(productDetails: productDetails, halalHaramData: " "));
  //     }
  //   else {
  //       debugPrint('Failed to fetch product data. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     debugPrint('Error fetching product data: $error');
  //   }
  // }


}
class ApiCallWidget extends StatefulWidget {
  const ApiCallWidget({super.key, required this.code});
  final String code;
  @override
  State<ApiCallWidget> createState() => _ApiCallWidgetState();
}
class _ApiCallWidgetState extends State<ApiCallWidget>{

Future<String> getOpenFoodFactData(String code) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://world.openfoodfacts.org/api/v2/product/$code.json',
      );
      return response.data.toString();
    } catch (e) {
      debugPrint(':: ${e.toString()}');
      return e.toString();
    }
  }

  String openFoodFactResult = 'NO Data';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          'Open Food Fact result: $openFoodFactResult',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            openFoodFactResult = 'Loading';
            setState(() {});
            openFoodFactResult = await getOpenFoodFactData(widget.code);
            setState(() {});
          },
          child: const Text('Fetch Product Data'),
        )
      ],
    );
  }

}