import 'package:ecode_verifier/src/constants/colors.dart';
import 'package:ecode_verifier/src/constants/image_strings.dart';
import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/screens/login/login.dart';
import 'package:ecode_verifier/src/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatelessWidget{
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? secondaryColor : primaryColor,
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: const AssetImage(welcomeScreen), height: height*0.6,),
            Column(
              children: [
                Text(welcomeTitle,style: Theme.of(context).textTheme.headlineMedium,),
                Text(welcomeSubTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,)
              ],
            ),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                  onPressed: () {Get.to(const Login());},
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    foregroundColor: secondaryColor,
                    side: const BorderSide(color: secondaryColor),
                    padding: const EdgeInsets.symmetric(vertical: buttonHeight),
                  ),
                  child: Text(login.toUpperCase()),
                  )
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(child: ElevatedButton(
                  onPressed: () { Get.to( QuestionPage()); },
                  
                  child: Text(signup.toUpperCase()),
                  )
                  ),
              ],
            )
          ]
          ),
      ),
    );
  }

}