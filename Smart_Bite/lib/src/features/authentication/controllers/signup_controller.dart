import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/exception/signup_failure.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  final mobileNo = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    userName.dispose();
    mobileNo.dispose();
    super.onClose();
  }

  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      return await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.message,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ));
      return null;
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ));
      return null;
    }
  }

  Future<void> createUser(String uid, UserModal user) async {
    await UserRepository.instance.createUser(uid, user);
  }

  void phoneAuthentication(String mobileNo) {
    AuthenticationRepository.instance.phoneAuthentication(mobileNo);
  }
}
