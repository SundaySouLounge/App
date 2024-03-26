import 'package:get/get.dart';
import 'package:app_user/app/controller/account_controller.dart';
import 'package:app_user/app/controller/booking_controller.dart';
import 'package:app_user/app/controller/categories_controller.dart';
import 'package:app_user/app/controller/favorite_controller.dart';
import 'package:app_user/app/controller/home_controller.dart';
import 'package:app_user/app/controller/near_controller.dart';
import 'package:app_user/app/controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TabsController(parser: Get.find()));
    Get.lazyPut(() => HomeController(parser: Get.find()));
    Get.lazyPut(() => CategoriesController(parser: Get.find()));
    Get.lazyPut(() => NearController(parser: Get.find()));
    Get.lazyPut(() => BookingController(parser: Get.find()));
    Get.lazyPut(() => AccountController(parser: Get.find()));
    Get.lazyPut(() => FavoriteController(parser: Get.find()));
  }
}
