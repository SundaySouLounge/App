import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/add_timing_controller.dart';

class AddTimingBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AddTimingController(parser: Get.find()),
    );
  }
}
