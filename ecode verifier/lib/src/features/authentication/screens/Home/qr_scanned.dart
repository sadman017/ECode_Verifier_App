// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class QRScanneroverlay extends StatelessWidget{
//   const QRScanneroverlay({super.key, required this.overlayColor});

//   final Color overlayColor;
  
  
//   @override
//   Widget build(BuildContext context) {
//    double scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height <400) ? 200.0 : 330.0;
//    return Stack(
//     children:[
//       ColorFiltered(colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOut),
//       child: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               backgroundBlendMode: BlendMode.dstOut
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               height: scanArea,
//               width: scanArea,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           )
//         ],
//       ),
//       ),
//       Align(
//         alignment: Alignment.center,
//         child: CustomPaint(
//           foregroundPainter: BorderPainter(),
//           child: SizedBox(
//             width: scanArea * 25,
//             height: scanArea * 25,
//           ),
//         ),
//       )
//     ]
//    );
//   }
  
// }
// class BorderPainter extends CustomPainter{
//   @override
//   void paint(Canvas canvas, Size size) {
//     const width = 4.0;
//     const radius = 20.0;
//     const tRadius = 3 * radius;
//     final rect = Rect.fromLTWH( width, width,
//     size.width - 2 * width,
//     size.height -2 * width,
//     );
//     final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
//     const clippingRect0 = Rect.fromLTWH(0, 0, tRadius, tRadius);
//     final clippingRect1 = Rect.fromLTWH(
//       size.width = tRadius, top,  height)
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
     // TODO: implement shouldRepaint
//     throw UnimplementedError();
//   }

// }