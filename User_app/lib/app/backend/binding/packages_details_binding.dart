import 'package:get/get.dart';
import 'package:app_user/app/controller/packages_details_controller.dart';

class PackagesDetailsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => PackagesDetailsController(parser: Get.find()),
    );
  }
}
