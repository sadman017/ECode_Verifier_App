import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget{
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: user,
                hintText: user,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: formHeight - 20,),
            TextFormField(
               decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key_outlined),
                labelText: pass,
                hintText: pass,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null, 
                  icon: Icon(Icons.remove_red_eye_sharp),

                )
              ),
            ),
            const SizedBox(
              height: formHeight - 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, 
              child: const Text(forgetPass)
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, 
              child: Text(login.toUpperCase()),
              ),
            )
          ],
        ),
    )
    );
  }

}