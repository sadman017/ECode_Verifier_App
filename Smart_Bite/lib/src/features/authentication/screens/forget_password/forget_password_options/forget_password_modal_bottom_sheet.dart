import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/screens/forget_password/forget_password_email/forget_password_email.dart';
import 'package:ecode_verifier/src/features/authentication/screens/forget_password/forget_password_options/forget_passwoord_widget.dart';
import 'package:ecode_verifier/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen{
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(context: context, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                builder: (context) => Container(padding: const EdgeInsets.all(defaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(forgetPassTitle, style: Theme.of(context).textTheme.headlineLarge,),
                    Text(forgetPassSubTitle, style: Theme.of(context).textTheme.bodyMedium,),
                    const SizedBox(height: 30.0,),
                    ForgetPasswordWidget(buttonIcon: Icons.mail_outline_rounded, title: email, subtitle: resetViaEmail, onTap: () {
                    Navigator.pop(context); 
                    Get.to(() => const ForgetPasswordMail());
                    },
                    ),
                    const SizedBox(height: 20.0,),
                    ForgetPasswordWidget(buttonIcon: Icons.mobile_friendly_rounded, title: number, subtitle: resetViaMoile, onTap: () {Get.to(() => const OTPScreen());
                    },
                    ),
                  ],
                ),
                )
                );
  }

}
