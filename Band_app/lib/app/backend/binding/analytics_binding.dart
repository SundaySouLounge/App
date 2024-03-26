import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AnalyticsController(parser: Get.find()),
    );
  }
}
