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
}

