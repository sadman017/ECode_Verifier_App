import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal{
   final String? id;
   final String user;
   final String email;
   final String password;
   final String mobileNo;

  const UserModal({
  this.id,
  required this.email,
  required this.user,
  required this.password,
  required this.mobileNo
});

toJson(){
  return{
    "UserName": user,
    "Email": email,
    "Password": password,
    "MobileNo": mobileNo
    };
  }
  factory UserModal.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data =document.data()!;
    return UserModal(id: document.id, email: data['Email'], user: data['UserName'], password: data["Password"], mobileNo: data['MobileNo']);
  }

}

