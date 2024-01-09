import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    await usersCollection.doc(userId).set(userData);
  }
}
