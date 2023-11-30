import 'package:ecode_verrifier/src/constants/image_strings.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget{
  const LoginHeaderWidget({Key? key, required this.size,}): super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: const AssetImage(welcomeScreen),
        height: size.height * 0.2 ,
        ),
        Text(loginTitle, style: Theme.of(context).textTheme.headlineLarge,),
      ],
    );
  }

}