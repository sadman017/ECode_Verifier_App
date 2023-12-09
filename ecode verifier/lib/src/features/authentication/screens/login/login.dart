import 'package:ecode_verifier/src/common_widgets/form/form_header.dart';
import 'package:ecode_verifier/src/constants/image_strings.dart';
import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:ecode_verifier/src/features/authentication/screens/login/login_form_widget.dart';
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
                FormHeaderWidget(size: size,
                image: welcomeScreen,
                title: loginTitle,
                ),
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