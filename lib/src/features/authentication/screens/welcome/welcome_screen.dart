import 'package:ecode_verrifier/src/constants/colors.dart';
import 'package:ecode_verrifier/src/constants/image_strings.dart';
import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/login/login.dart';
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
                  Expanded(child: OutlinedButton(
                  onPressed: () {  },
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    foregroundColor: secondaryColor,
                    backgroundColor: secondaryColor,
                    side: const BorderSide(color: secondaryColor),
                    padding: const EdgeInsets.symmetric(vertical: buttonHeight),
                  ),
                  child: Text(signup.toUpperCase(), selectionColor: isDarkMode ? Colors.white: Colors.black,),
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