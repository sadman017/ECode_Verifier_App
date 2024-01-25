import 'package:dio/dio.dart';
import 'package:ecode_verifier/src/constants/colors.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/preference_controller.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/qr_scanned.dart';
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
  String productDetails = '';
  String result = "5449000214911";

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
        backgroundColor: Colors.blue,
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
  

}
class ApiCallWidget extends StatefulWidget {
  const ApiCallWidget({super.key, required this.code});
  final String code;
  @override
  State<ApiCallWidget> createState() => _ApiCallWidgetState();
}
class _ApiCallWidgetState extends State<ApiCallWidget>{
bool isButtonVisible =true;
Future<FoodResponse?> getOpenFoodFactData(String code) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://world.openfoodfacts.org/api/v2/product/$code.json?lc=en',
      );
      return  FoodResponse.fromJson(response.data);
    } catch (e) {
      debugPrint(':: ${e.toString()}');
      return null;
    }
  }

  FoodResponse? openFoodFactResult ;
  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Text(
          openFoodFactResult == null
              ? 'No Data'
              : (openFoodFactResult?.statusVerbose ?? ''),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: isButtonVisible,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: ElevatedButton(
            onPressed: () async {
              isButtonVisible = false;
              setState(() {});
              openFoodFactResult = await getOpenFoodFactData(widget.code);
              debugPrint(openFoodFactResult?.statusVerbose);
              setState(() {});
            },
            child: const Text('Fetch Product Data'),
          ),
        ),
        if (openFoodFactResult != null && openFoodFactResult!.product != null)
            SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.warning, color: Colors.yellow),
                  title: const Text(
                    'Allergen:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    openFoodFactResult!.product!.allergens ?? 'N/A',
                     style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.food_bank, color: Colors.orange),
                  title: const Text(
                    'Additives Original Tags:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    openFoodFactResult!.product!.additivesOriginalTags?.join(', ') ?? 'N/A',
                     style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                // const SizedBox(height: 10),
                // ListTile(
                //   leading: const Icon(Icons.rice_bowl, color: Colors.red),
                //   title: const Text(
                //     'Ingredients:',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: Text(
                //     openFoodFactResult!.product!.ingredientsTextEn ?? 'N/A',
                //   ),
                // ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.fastfood, color: Colors.green),
                  title: const Text(
                    'Labels:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    openFoodFactResult!.product!.labelsTags?.join(', ') ?? 'N/A', 
                     style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                 const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text(
                    'Halal-Haram:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Halal", style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}