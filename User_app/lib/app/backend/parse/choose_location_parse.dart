import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/controller/login_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/helper/shared_pref.dart';

class ChooseLocationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ChooseLocationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  void saveLatLng(var lat, var lng, var address) {
    sharedPreferencesManager.putDouble('lat', lat);
    sharedPreferencesManager.putDouble('lng', lng);
    sharedPreferencesManager.putString('address', address);
  }

  void saveLanguage(String code) {
    sharedPreferencesManager.putString('language', code);
  }

  bool isLogin() {
    return sharedPreferencesManager.getString('uid') != null &&
            sharedPreferencesManager.getString('uid') != ''
        ? true
        : false;
  }

  void onLogin() {
    Get.delete<LoginController>(force: true);
    Get.toNamed(AppRouter.getLoginRoute());
  }
}
