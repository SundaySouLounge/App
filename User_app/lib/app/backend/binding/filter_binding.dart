import 'package:get/get.dart';
import 'package:app_user/app/controller/filter_controller.dart';

class FilterBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => FilterController(parser: Get.find()),
    );
  }
}
