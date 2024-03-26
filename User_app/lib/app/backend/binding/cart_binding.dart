import 'package:get/get.dart';
import 'package:app_user/app/controller/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CartController(parser: Get.find()),
    );
  }
}
