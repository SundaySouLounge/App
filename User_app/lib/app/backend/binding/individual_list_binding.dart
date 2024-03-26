import 'package:get/get.dart';
import 'package:app_user/app/controller/individual_list_controller.dart';

class IndividualListBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => IndividualListController(parser: Get.find()),
    );
  }
}
