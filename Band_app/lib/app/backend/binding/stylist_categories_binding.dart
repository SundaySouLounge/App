import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/stylist_categories_controller.dart';

class StylistCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => StylistCategoriesController(parser: Get.find()),
    );
  }
}
