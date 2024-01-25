import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal{
   final String? id;
   final String user;
   final String email;
   final String password;
   final String mobileNo;
   final String dietType;
  final String  allergyResponse;
  final String  allergen;
  final String  nutritionFactResponse;

  const UserModal({
  this.id,
  required this.email,
  required this.user,
  required this.password,
  required this.mobileNo,
  required this.dietType,
  required this.allergyResponse,
  required this.allergen,
  required this.nutritionFactResponse,
});

toJson(){
  return{
    "UserName": user,
    "Email": email,
    "Password": password,
    "MobileNo": mobileNo,
    "DietType": dietType,
    "AllergyResponse": allergyResponse,
    "Allergen": allergen,
    "Nutrition": nutritionFactResponse,
    };
  }
  factory UserModal.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data =document.data()!;
    return UserModal(id: document.id, email: data['Email'], user: data['UserName'], password: data["Password"], mobileNo: data['MobileNo'], 
    dietType: data['DietType'],allergyResponse: data['AllergyResponse'],allergen: data['Allergen'],nutritionFactResponse: data['Nutrition']);
  }

}

