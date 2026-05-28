import 'package:ecode_verifier/src/constants/colors.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/qr_scanned.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String result = "";

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
            ElevatedButton.icon(
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                );
                if (res is String && res.isNotEmpty && res != '-1') {
                  setState(() {
                    result = res;
                  });
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Barcode'),
            ),
            const Gap(12),
            if (result.isNotEmpty)
              Chip(
                avatar: const Icon(Icons.confirmation_number, size: 18),
                label: Text('Barcode: $result'),
                backgroundColor: Colors.blue.shade50,
              ),
            const Gap(12),
            if (result.isNotEmpty)
              Expanded(
                child: ApiCallWidget(code: result),
              ),
            if (result.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Scan a barcode to see product details',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
              ),
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

class _ApiCallWidgetState extends State<ApiCallWidget> {
  bool _isLoading = true;
  String? _errorMessage;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  /// Fetch product data using the official openfoodfacts Dart package (API v3).
  Future<void> _fetchProductData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _product = null;
    });

    try {
      final configuration = ProductQueryConfiguration(
        widget.code,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [ProductField.ALL],
        version: ProductQueryVersion.v3,
      );

      final ProductResultV3 result =
          await OpenFoodAPIClient.getProductV3(configuration);

      if (result.status == ProductResultV3.statusSuccess &&
          result.product != null) {
        setState(() {
          _product = result.product;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Product not found for barcode "${widget.code}". Try another product.';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('OpenFoodFacts error: $e');
      setState(() {
        _errorMessage = 'Failed to fetch product data. Please try again later.';
        _isLoading = false;
      });
    }
  }

  /// Converts IngredientsAnalysisTags enum statuses to a list of string tags
  List<String> _analysisTagsToList(IngredientsAnalysisTags? tags) {
    if (tags == null) return [];
    final list = <String>[];
    if (tags.veganStatus != null) list.add(tags.veganStatus!.offTag);
    if (tags.vegetarianStatus != null) list.add(tags.vegetarianStatus!.offTag);
    if (tags.palmOilFreeStatus != null)
      list.add(tags.palmOilFreeStatus!.offTag);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Gap(12),
            Text('Fetching product data...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const Gap(12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
            const Gap(12),
            ElevatedButton.icon(
              onPressed: _fetchProductData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_product != null) {
      return SingleChildScrollView(
        child: ProductResultCard(
          productName: _product!.productName,
          brands: _product!.brands,
          quantity: _product!.quantity,
          imageUrl: _product!.imageFrontUrl,
          ingredientsText: _product!.ingredientsText,
          nutriments: _product!.nutriments,
          allergens: _product!.allergens?.names.join(', '),
          nutriScore: _product!.nutriscore,
          ecoScoreGrade: _product!.ecoscoreGrade,
          ecoScoreValue: _product!.ecoscoreScore?.toInt(),
          ingredientsAnalysisTags:
              _analysisTagsToList(_product!.ingredientsAnalysisTags),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
