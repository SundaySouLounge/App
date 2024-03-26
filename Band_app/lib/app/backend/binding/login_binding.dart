import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => LoginController(parser: Get.find()),
    );
  }
}
