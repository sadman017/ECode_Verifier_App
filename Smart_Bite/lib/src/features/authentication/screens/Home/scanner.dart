import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecode_verifier/src/constants/colors.dart';
import 'package:ecode_verifier/src/features/authentication/models/halal_response.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/qr_scanned.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

/// API base URL for the halal scraper backend.
/// Override at build time with: --dart-define=API_BASE_URL=https://your-app.com
const String _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.24.233.176:8000',
);

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
                final res = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerPage(),
                  ),
                );
                if (res != null && res.isNotEmpty && res != '-1') {
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
            Chip(
              avatar: const Icon(Icons.api, size: 18),
              label: Text('API: $_apiBaseUrl', overflow: TextOverflow.ellipsis),
              backgroundColor: Colors.orange.shade50,
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
  HalalResponse? _halalResponse;

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  @override
  void didUpdateWidget(covariant ApiCallWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      _fetchProductData();
    }
  }

  /// Calls the local FastAPI JAKIM endpoint to check Halal status.
  Future<HalalResponse> checkHalalStatus(String productName) async {
    final uri = Uri.parse('$_apiBaseUrl/api/halal')
        .replace(queryParameters: {'product_name': productName});
    debugPrint('[Halal] Calling $uri');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      debugPrint('[Halal] Response ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        if (data != null) {
          return HalalResponse.fromJson(data);
        }
        return const HalalResponse(status: 'No data returned');
      }
      return HalalResponse(status: 'Error HTTP ${response.statusCode}');
    } on SocketException catch (e) {
      debugPrint('[Halal] SocketException: $e');
      return HalalResponse(
        status: 'Offline',
        detail: 'Cannot reach $_apiBaseUrl.\n'
            '1. Is the server running?\n'
            '2. Are phone and PC on the same Wi-Fi?\n'
            '3. Is Windows Firewall blocking port 8000?',
      );
    } on TimeoutException catch (e) {
      debugPrint('[Halal] TimeoutException: $e');
      return HalalResponse(
        status: 'Timeout',
        detail: 'Server at $_apiBaseUrl timed out. It may be waking up (Render) or overloaded.',
      );
    } on http.ClientException catch (e) {
      debugPrint('[Halal] ClientException: $e');
      return HalalResponse(
        status: 'Connection failed',
        detail: 'Server closed the connection ($_apiBaseUrl).\n'
            'Make sure uvicorn is running: python -m uvicorn main:app --host 0.0.0.0 --port 8000',
      );
    } catch (e) {
      debugPrint('[Halal] Unexpected error: $e');
      return HalalResponse(
        status: 'Error',
        detail: 'Unexpected error: $e',
      );
    }
  }

  /// Fetch product data using the official openfoodfacts Dart package (API v3).
  Future<void> _fetchProductData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _product = null;
      _halalResponse = null;
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
        _product = result.product;
        _halalResponse = await checkHalalStatus(_product!.productName ?? '');
        setState(() {
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
    if (tags.palmOilFreeStatus != null) {
      list.add(tags.palmOilFreeStatus!.offTag);
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductResultCard(
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
              halalStatus: _halalResponse?.status,
              halalCompany: _halalResponse?.company,
            ),
            if (_halalResponse != null && _halalResponse!.detail != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Halal status: ${_halalResponse!.detail}',
                  style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                ),
              ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// A full-screen barcode scanner page using the mobile_scanner package.
/// Returns the scanned barcode string via Navigator.pop.
class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _hasReturned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasReturned) return;
    final barcode = capture.barcodes.firstOrNull;
    final String? rawValue = barcode?.rawValue;
    if (rawValue != null && rawValue.isNotEmpty) {
      _hasReturned = true;
      Navigator.pop(context, rawValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          // Scan window overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Top controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  ValueListenableBuilder<MobileScannerState>(
                    valueListenable: controller,
                    builder: (context, state, child) {
                      return IconButton(
                        onPressed: () => controller.toggleTorch(),
                        icon: Icon(
                          state.torchState == TorchState.on
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom hint
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'Align barcode within the frame',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
