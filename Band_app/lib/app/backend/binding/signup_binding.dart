import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => SignUpController(parser: Get.find()),
    );
  }
}
