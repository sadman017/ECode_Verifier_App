import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/constants/text_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckboxController extends GetxController{
  RxBool isChecked = false.obs;
}

class SignupForm extends StatelessWidget{
   SignupForm({super.key});

  final CheckboxController controller = Get.put(CheckboxController());

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
                label: Text(user),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: formHeight - 20,),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: email,
                hintText: email,
              ),
            ),
            const SizedBox(height: formHeight - 20,),
            TextFormField(
               decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key_outlined),
                labelText: pass,
                hintText: pass,
                suffixIcon: IconButton(
                  onPressed: null, 
                  icon: Icon(Icons.remove_red_eye_sharp),

                )
              ),
            ),
            const SizedBox(height: formHeight - 20,),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_android),
                labelText: number,
                hintText: number,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: formHeight - 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(
        () => CheckboxListTile(
          title:const Text(rememberMe),
          value: controller.isChecked.value,
          onChanged: (value) {
            controller.isChecked.value = value!;
          },
        ),
      ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, 
              child: Text(signup.toUpperCase()),
              ),
            )
          ],
        ),
    )
    );
  }

}