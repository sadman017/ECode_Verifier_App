import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final Rx<UserModal?> currentUser = Rx<UserModal?>(null);

  void setUser(UserModal user) {
    currentUser.value = user;
  }

  void clearUser() {
    currentUser.value = null;
  }

  bool get hasUser => currentUser.value != null;
}
