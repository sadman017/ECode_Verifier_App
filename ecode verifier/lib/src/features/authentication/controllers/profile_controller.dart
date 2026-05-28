import 'package:ecode_verifier/src/features/authentication/controllers/user_controller.dart';
import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  UserModal? get userData => UserController.instance.currentUser.value;

  Future<void> refreshUserData() async {
    // User data is automatically managed by AuthenticationRepository
    // and kept in sync via UserController. This method exists for
    // manual refresh if needed in the future.
  }
}
