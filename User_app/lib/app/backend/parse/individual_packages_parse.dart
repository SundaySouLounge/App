import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class IndividualPackagesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  IndividualPackagesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getPackagesById(var body) async {
    return await apiService.postPublic(AppConstants.getPackagesById, body);
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ??
        AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ??
        AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ??
        AppConstants.defaultCurrencySymbol;
  }
}
