import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/order_details_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => OrderDetailsController(parser: Get.find()),
    );
  }
}
