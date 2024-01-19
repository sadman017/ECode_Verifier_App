import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'General Product Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Text(
              //   result_barcode,
              //   style: const TextStyle(fontSize: 16),
              // ),
              const SizedBox(height: 16),
              const Text(
                'Halal-Haram Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Text(
              //   halalHaramData,
              //   style: const TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
