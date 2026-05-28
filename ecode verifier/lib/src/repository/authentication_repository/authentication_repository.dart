import 'package:ecode_verifier/src/features/authentication/controllers/user_controller.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/home.dart';
import 'package:ecode_verifier/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/exception/signup_failure.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
  }

  Future<void> checkAuthState() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.offAll(() => const Welcome());
    } else {
      await _fetchUserData(user);
      Get.offAll(() => const Home());
    }
  }

  Future<void> _fetchUserData(User user) async {
    try {
      if (user.email != null) {
        final userData =
            await UserRepository.instance.getUserDetails(user.email!);
        if (userData != null) {
          UserController.instance.setUser(userData);
        }
      } else if (user.uid.isNotEmpty) {
        final userData = await UserRepository.instance.getUserById(user.uid);
        if (userData != null) {
          UserController.instance.setUser(userData);
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch user data: $e');
      Get.snackbar(
        "Error",
        "Unable to load your profile data. Please check your connection.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> phoneAuthentication(String mobileNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: mobileNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == "invalid-phone-number") {
            Get.snackbar('Error', 'The number is not valid');
          } else {
            Get.snackbar('Error', 'Something went wrong, Try again');
          }
        },
        codeSent: (verificationId, resendTOken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      debugPrint('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      debugPrint('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = e.message ?? 'Authentication failed.';
      }
      Get.snackbar("Error", message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    } catch (e) {
      Get.snackbar("Error", 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    }
  }

  Future<void> logout() async {
    UserController.instance.clearUser();
    await _auth.signOut();
    Get.offAll(() => const Welcome());
  }
}
