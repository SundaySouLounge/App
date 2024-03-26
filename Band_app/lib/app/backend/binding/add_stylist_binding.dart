import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/add_stylist_controller.dart';

class AddStylistBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AddStylistController(parser: Get.find()),
    );
  }
}
