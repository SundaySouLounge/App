import 'package:get/get.dart';
import 'package:app_user/app/controller/services_controller.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ServicesController(parser: Get.find()),
    );
  }
}
