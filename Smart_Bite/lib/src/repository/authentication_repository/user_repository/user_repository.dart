import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, UserModal user) async {
    await _db
        .collection("users")
        .doc(uid)
        .set(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            "Success",
            "Your account has been created",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      debugPrint(error.toString());
      throw error;
    });
  }

  Future<UserModal?> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("users").where("Email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) return null;
    return UserModal.fromSnapshot(snapshot.docs.first);
  }

  Future<UserModal?> getUserById(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModal.fromSnapshot(doc);
  }
}
