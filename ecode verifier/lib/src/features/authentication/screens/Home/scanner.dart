import 'dart:typed_data';

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
class _ScannerState extends State<Scanner>{
  MobileScannerController cameraController = MobileScannerController(
     returnImage: true,
     facing: CameraFacing.back,
     torchEnabled: false,
  );
  bool screenOpened = false;

  @override
  void initState(){
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Scanner", style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold,
        letterSpacing: 1,
        )
        ),
        elevation: 0.0,
          ),
          body : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Place the QR code in the area",
                        style: TextStyle(color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0),
                      ),
                      const Gap(10),
                      Stack(
                        children: [
                          MobileScanner(
                            fit: BoxFit.contain,
                            controller: cameraController,
                            onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) =>
                  Image(image: MemoryImage(image)),
            );
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pop(context);
            });
          }
        },
                          ),
                          // QRScanneroverlay(overlayColor: Colors.black.withOpacity(0.5)
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
    );
  }
  void screenClosed(){
    screenOpened = false;
  } 
}