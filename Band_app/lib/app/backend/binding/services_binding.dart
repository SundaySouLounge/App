import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/services_controller.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ServicesController(parser: Get.find()),
    );
  }
}
