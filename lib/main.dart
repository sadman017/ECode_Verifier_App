
import 'package:ecode_verrifier/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:ecode_verrifier/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class AppHome extends StatelessWidget{
  const AppHome({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
    title: const Text("E-Code Verrifier"),
    leading: const Icon(Icons.menu),
    
    ),
   );
  }

}