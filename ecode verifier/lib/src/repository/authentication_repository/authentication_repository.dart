import 'package:ecode_verifier/src/features/authentication/screens/Home/home.dart';
import 'package:ecode_verifier/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/exception/signup_failure.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady(){
    Future.delayed(const Duration(seconds: 5));
    firebaseUser =Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges as Stream<User?>);
    ever(firebaseUser, _setIntialScreen);
  }

  _setIntialScreen(User? user){
    user == null ? Get.offAll(() => const Welcome()): Get.offAll(()=> const Home() );
  }
  Future<void> createUserWithEmailAndPassword(String email, String password) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => const Home()): Get.to(() => const Welcome());
    }on FirebaseAuthException catch(e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      debugPrint('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
    catch(_){}
  }

   Future<void> loginWithEmailAndPassword(String email, String password) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(_){}
  }

  Future<void> logout() async => await _auth.signOut();
}