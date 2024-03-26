import 'package:get/get.dart';
import 'package:app_user/app/controller/web_product_payment_controller.dart';

class WebProductPaymentBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => WebProductPaymentController(parser: Get.find()),
    );
  }
}
