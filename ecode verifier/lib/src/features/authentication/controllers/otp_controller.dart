import 'package:ecode_verifier/src/features/authentication/screens/Home/home.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

class OTPcontroller extends GetxController{
  static OTPcontroller get instance => Get.find();

  void verifyOTP(String otp) async{
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.off(const Home()) : Get.back();
  }
}