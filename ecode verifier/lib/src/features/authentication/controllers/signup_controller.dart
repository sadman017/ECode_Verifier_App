import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:ecode_verifier/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final mobileNo = TextEditingController();
  final userRepo = Get.put(UserRepository());
    var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void registerUser(String email, String password){
   String? error = AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
   if(error != null){
    Get.showSnackbar(GetSnackBar(message: error.toString(),));
   }
    
  }

  Future<void> createUser(UserModal user) async{
    await userRepo.createUser(user);
    phoneAuthentication(user.mobileNo);
    Get.to(() => const OTPScreen());
  }

  void phoneAuthentication(String mobileNo){
    AuthenticationRepository.instance.phoneAuthentication( mobileNo);
  }
}