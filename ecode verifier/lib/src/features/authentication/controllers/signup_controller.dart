import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final mobileNo = TextEditingController();

  void registerUser(String email, String password){
    AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
    
  }
}