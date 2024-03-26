import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/app_pages_controller.dart';

class AppPagesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AppPagesController(parser: Get.find()),
    );
  }
}
