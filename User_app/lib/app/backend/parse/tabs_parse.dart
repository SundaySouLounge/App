import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';

class TabsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  TabsParser(
      {required this.apiService, required this.sharedPreferencesManager});

  bool isLogin() {
    return sharedPreferencesManager.getString('uid') != null &&
            sharedPreferencesManager.getString('uid') != ''
        ? true
        : false;
  }
}
