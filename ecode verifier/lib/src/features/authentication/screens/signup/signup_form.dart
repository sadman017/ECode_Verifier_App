import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/signup_controller.dart';
import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupForm extends StatelessWidget{
  final String userId;
  const SignupForm({required this.userId, Key? key}) : super(key: key);



  
  @override
  Widget build(BuildContext context) {
final SignupController controller ;
    if(!Get.isRegistered<SignupController>()) {
         controller = Get.put(SignupController());
    } else {
controller = Get.find<SignupController>();
    }
    return Container(
       padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child:Form(
        key: SignupController.instance.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller:  controller.userName,
              decoration: const InputDecoration(
                label: Text(user),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: formHeight - 20,),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: email,
                hintText: email,
              ),
            ),
            const SizedBox(height: formHeight - 20,),
             TextFormField(
               controller: controller.password,
               obscureText: !controller.isPasswordVisible.value,
               decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.key_outlined),
                labelText: pass,
                hintText: pass,
                suffixIcon: Obx(() => IconButton(
                  onPressed: () {
                     controller.togglePasswordVisibility();
                  }, 
                  icon: Icon(  controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,),

                )),
              ),
            ),
            const SizedBox(height: formHeight - 20,),
            TextFormField(
              controller: controller.mobileNo,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                 if(SignupController.instance.formkey.currentState!.validate()){
                  // SignupController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                   final user = UserModal(
                     id: userId,
                     email: controller.email.text.trim(),
                     user: controller.userName.text.trim(),
                     password: controller.password.text.trim(),
                     mobileNo: controller.mobileNo.text.trim(),
                   );
                   SignupController.instance.createUser(user);
                }
              }, 
              child: Text(signup.toUpperCase()),
              ),
            )
          ],
        ),
    )
    );
  }

}