import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:app_user/app/util/constant.dart';

class LanguagesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LanguagesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  void saveLanguage(String code) {
    sharedPreferencesManager.putString('language', code);
  }

  String getDefault() {
    return sharedPreferencesManager.getString('language') ??
        AppConstants.defaultLanguageApp;
  }
}
