import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/product_order_details_controller.dart';

class ProductOrderDetailsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ProductOrderDetailsController(parser: Get.find()),
    );
  }
}
