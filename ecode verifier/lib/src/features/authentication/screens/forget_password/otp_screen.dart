import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatelessWidget{
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(otpTitle, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
            fontSize: 70.0,
             ),
             ),
            Text(otpSubTitle.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              otpMsg, textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0,),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.transparent.withOpacity(0.1),
              filled: true,
              onSubmit: (code){ print("OTP is => $code");},
            ),
            const SizedBox(height: 20.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                
              }, child: const Text("Next"),),
            )
          ],
        ),
      ),
    );
  }

}