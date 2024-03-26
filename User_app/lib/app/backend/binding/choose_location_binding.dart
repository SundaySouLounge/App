import 'package:get/get.dart';
import 'package:app_user/app/controller/choose_location_controller.dart';

class ChooseLocationBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ChooseLocationController(parser: Get.find()),
    );
  }
}
