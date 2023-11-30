import 'package:ecode_verrifier/src/constants/image_strings.dart';
import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key : key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool animate = false;

  @override
  void initState(){
    super.initState();
    startAnimation();
    
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
      child: Stack(
        children: [
           AnimatedPositioned(
            top: animate ? 0 : -30,
            left: animate ? 0 : -30,
            duration: const Duration(microseconds: 1600),
            child: const Image(
              image: AssetImage(splashIcon),)
              ),
              AnimatedPositioned(
                top: animate ? defaultSize: -80,
                left: defaultSize,
                duration: const Duration(milliseconds: 1600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appName, style: Theme.of(context).textTheme.headlineLarge,),
                  ],
                  )
                  ),
                  const Positioned(
                    bottom: 100,
                    child: Image(image: AssetImage(splashImage)
                    ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: defaultSize,
                      child: Container(
                        width: defaultContainerSize,
                        height: defaultContainerSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                         ),
                      )
                      )
        ],
      )
      )
    );
  }
  
   Future startAnimation() async{
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => animate = true);
    await Future.delayed(const Duration(milliseconds: 5000));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Welcome())
    );
   }
}