import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/verify_controller.dart';

class VerifyBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => VerifyController(parser: Get.find()),
    );
  }
}
