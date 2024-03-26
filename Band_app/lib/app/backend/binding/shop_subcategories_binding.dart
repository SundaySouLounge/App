import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/shop_subcategories_controller.dart';

class ShopSubCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ShopSubCategoriesController(parser: Get.find()),
    );
  }
}
