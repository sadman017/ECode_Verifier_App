import 'package:ecode_verrifier/src/constants/image_strings.dart';
import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:flutter/material.dart';

class SignupFooterWidget extends StatelessWidget {
  const SignupFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
   return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text("OR"),
      const SizedBox(height: formHeight - 20,),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(onPressed: () {}, icon: const Image(image: AssetImage(googleLogo), width: 20,), 
        label: const Text(signupWithGoogle)),
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(onPressed: () {}, icon: const Image(image: AssetImage(facebookLogo), width: 20,), 
        label: const Text(signinWithFacebook)),
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(onPressed: () {}, icon: const Image(image: AssetImage(twitterLogo), width: 20,), 
        label: const Text(signupWithTwittterr)),
      ),
      const SizedBox(height: formHeight - 20,),
      TextButton(
        onPressed: () {},
        child: Text.rich(
          TextSpan(
            text: haveAnAccount,
            style : Theme.of(context).textTheme.bodyMedium,
            children: const[
              TextSpan(text: login, style: TextStyle(color: Colors.blue))
        ],
        ),
        )
        )
    ],
   );
  }
}