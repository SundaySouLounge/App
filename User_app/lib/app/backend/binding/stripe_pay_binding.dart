import 'package:app_user/app/controller/stripe_pay_controller.dart';
import 'package:get/get.dart';

class StripePayBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => StripePayController(parser: Get.find()),
    );
  }
}
