import 'package:get/get.dart';
import 'package:app_user/app/controller/products_details_controller.dart';

class ProductsDetailsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ProductsDetailsController(parser: Get.find()),
    );
  }
}
