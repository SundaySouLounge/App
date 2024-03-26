import 'package:get/get.dart';
import 'package:app_user/app/controller/product_order_controller.dart';

class ProductOrderBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ProductOrderController(parser: Get.find()),
    );
  }
}
