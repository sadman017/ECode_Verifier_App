import 'package:ecode_verifier/src/features/authentication/screens/Home/profile.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/scanner.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    ProfileScreen(),
    Text('Search', style: TextStyle(fontSize: 40),),
    Scanner(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: IndexedStack(
      index: myIndex,
      children: widgetList,
     ),
    //  appBar: AppBar(
    //   title: const Text("Ecode Verifier"),
    //  ),
     bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      onTap: (index) {
        setState(() {
          myIndex = index;
        });
      },
      currentIndex: myIndex,
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Profile',),
      BottomNavigationBarItem(icon: Icon(Icons.search_sharp), label: 'Search',),
      BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_outlined), label: 'Scanner',),
     ]),
    );
  }
}