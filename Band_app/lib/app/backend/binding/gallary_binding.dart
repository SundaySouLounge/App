import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/gallary_controller.dart';

class GallaryBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => GallaryController(parser: Get.find()),
    );
  }
}
