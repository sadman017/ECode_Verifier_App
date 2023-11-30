import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/login/login_header_widget.dart';
import 'package:flutter/material.dart';

class Login extends  StatelessWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeaderWidget(size: size),
                const LoginForm(),
                const LoginFooterWidget(),
              ],
            ),
        )
        ),
    ),

    );
  }

}