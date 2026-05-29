import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();
  RxBool animate = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  Future<void> startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 3500));
    await AuthenticationRepository.instance.checkAuthState();
  }
}
