import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/packages_specialist_controller.dart';

class PackagesSpecialistBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => PackagesSpecialistController(parser: Get.find()),
    );
  }
}
