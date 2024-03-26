import 'package:get/get.dart';
import 'package:app_user/app/controller/favorite_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => FavoriteController(parser: Get.find()),
    );
  }
}
