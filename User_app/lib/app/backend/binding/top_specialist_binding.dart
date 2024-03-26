import 'package:get/get.dart';
import 'package:app_user/app/controller/top_specialist_controller.dart';

class TopSpecialistBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => TopSpecialistController(parser: Get.find()),
    );
  }
}
