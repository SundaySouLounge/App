import 'package:get/get.dart';
import 'package:app_user/app/controller/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => WalletController(parser: Get.find()),
    );
  }
}
