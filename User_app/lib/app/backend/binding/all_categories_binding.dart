import 'package:get/get.dart';
import 'package:app_user/app/controller/all_categories_controller.dart';

class AllCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AllCategoriesController(parser: Get.find()),
    );
  }
}
