import 'package:ecode_verifier/src/constants/colors.dart';
import 'package:ecode_verifier/src/constants/image_strings.dart';
import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget{
   SplashScreen({Key? key}) : super(key : key);

  final splashController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    return  Scaffold(
      body: SafeArea(
      child: Stack(
        children: [
           Obx( () => AnimatedPositioned(
            top: splashController.animate.value ? 0 : -30,
            left: splashController.animate.value ? 0 : -30,
            duration: const Duration(milliseconds: 2000),
            child: const Image(
              image: AssetImage(splashIcon),)
              ),
           ),
              Obx( () => AnimatedPositioned(
                top: 80,
                left: splashController.animate.value ? defaultSize: -80,
                duration: const Duration(milliseconds: 2500),
                child: AnimatedOpacity(
                  opacity: splashController.animate.value ? 1:0,
                  duration: const Duration(milliseconds: 2500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appName, style: Theme.of(context).textTheme.headlineLarge,),
                    ],
                    ),
                )
                  ),
              ),
                  Obx(
                    () => AnimatedPositioned(
                    bottom: splashController.animate.value ? 100:0,
                    duration: const Duration(milliseconds: 2800),
                    child: AnimatedOpacity(opacity: splashController.animate.value ? 1:0, duration: const Duration(microseconds: 2000),
                    child: const Image(image: AssetImage(splashImage)
                    ),
                    ),
                    ),
                    ),
                    Obx( () => AnimatedPositioned( duration: const Duration(milliseconds: 2800),
                      bottom: splashController.animate.value ? 60: 0,
                      right: defaultSize,
                      child: AnimatedOpacity(opacity: splashController.animate.value ? 1:0, duration: const Duration(milliseconds: 2500),
                      child: Container(
                        width: defaultContainerSize,
                        height: defaultContainerSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor,
                         ),
                      ),
                      ),
                    ),
                      ),
        ],
      )
      )
    );
  }
  
}