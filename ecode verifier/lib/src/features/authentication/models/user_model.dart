import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  final String? id;
  final String user;
  final String email;
  final String mobileNo;
  final String dietType;
  final String allergyResponse;
  final String allergen;
  final String nutritionFactResponse;

  const UserModal({
    this.id,
    required this.email,
    required this.user,
    required this.mobileNo,
    required this.dietType,
    required this.allergyResponse,
    required this.allergen,
    required this.nutritionFactResponse,
  });

  Map<String, dynamic> toJson() {
    return {
      "UserName": user,
      "Email": email,
      "MobileNo": mobileNo,
      "DietType": dietType,
      "AllergyResponse": allergyResponse,
      "Allergen": allergen,
      "Nutrition": nutritionFactResponse,
    };
  }

  factory UserModal.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModal(
      id: document.id,
      email: data['Email'] ?? '',
      user: data['UserName'] ?? '',
      mobileNo: data['MobileNo'] ?? '',
      dietType: data['DietType'] ?? '',
      allergyResponse: data['AllergyResponse'] ?? '',
      allergen: data['Allergen'] ?? '',
      nutritionFactResponse: data['Nutrition'] ?? '',
    );
  }
}
