import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/add_packages_controller.dart';

class AddPackagesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AddPackagesController(parser: Get.find()),
    );
  }
}
