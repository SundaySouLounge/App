import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/create_products_controller.dart';

class CretaeProductsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CreateProductsController(parser: Get.find()),
    );
  }
}
