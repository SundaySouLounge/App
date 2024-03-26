import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/add_slot_controller.dart';

class AddSlotBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AddSlotController(parser: Get.find()),
    );
  }
}
