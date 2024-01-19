import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  static ProfileController get instance => Get.find();
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    }else {
      Get.snackbar("Error", "Login to continue");
    }
  }
}