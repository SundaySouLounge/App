import 'package:get/get.dart';
import 'package:app_user/app/controller/product_order_detail_controller.dart';

class ProductOrderDetailBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ProductOrderDetailController(parser: Get.find()),
    );
  }
}
