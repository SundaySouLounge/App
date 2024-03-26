import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/packages_categories_controller.dart';

class PackagesCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => PackagesCategoriesController(parser: Get.find()),
    );
  }
}
