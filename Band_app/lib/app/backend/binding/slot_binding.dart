import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/slot_controller.dart';

class SlotBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => SlotController(parser: Get.find()),
    );
  }
}
