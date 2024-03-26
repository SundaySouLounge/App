import 'package:get/get.dart';
import 'package:app_user/app/controller/top_packages_controller.dart';

class TopPackagesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => TopPackagesController(parser: Get.find()),
    );
  }
}
