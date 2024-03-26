import 'package:get/get.dart';
import 'package:app_user/app/controller/stripe_pay_product_controller.dart';

class StripePayProductBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => StripePayProductController(parser: Get.find()),
    );
  }
}
