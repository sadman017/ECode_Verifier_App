import 'package:ecode_verifier/firebase_options.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/user_controller.dart';
import 'package:ecode_verifier/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'package:ecode_verifier/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'ecode_verifier',
    version: '1.0.0',
  );

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthenticationRepository());
    Get.put(UserRepository());
    Get.put(UserController());
  });

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.system,
    defaultTransition: Transition.leftToRightWithFade,
    transitionDuration: const Duration(milliseconds: 500),
    home: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}
