import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/stylist_controller.dart';

class StylistBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => StylistController(parser: Get.find()),
    );
  }
}
