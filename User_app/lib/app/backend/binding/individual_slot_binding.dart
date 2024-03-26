import 'package:get/get.dart';
import 'package:app_user/app/controller/individual_slot_controller.dart';

class IndividualSlotBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => IndividualSlotController(parser: Get.find()),
    );
  }
}
