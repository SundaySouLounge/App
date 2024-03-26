import 'package:get/get.dart';
import 'package:app_user/app/controller/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AddressController(parser: Get.find()),
    );
  }
}
