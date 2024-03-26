import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class WalletParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  WalletParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getWallet() async {
    var response = await apiService.postPrivate(
        AppConstants.getWalletAmounts,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
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
