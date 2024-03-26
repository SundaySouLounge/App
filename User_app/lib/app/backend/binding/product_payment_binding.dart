import 'package:get/get.dart';
import 'package:app_user/app/controller/product_payment_controller.dart';

class ProductPaymentBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ProductPaymentController(parser: Get.find()),
    );
  }
}
