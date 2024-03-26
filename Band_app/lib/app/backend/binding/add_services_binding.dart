import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/add_services_controller.dart';

class AddServicesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AddServicesController(parser: Get.find()),
    );
  }
}
