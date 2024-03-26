import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class HistoryParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HistoryParser(
      {required this.sharedPreferencesManager, required this.apiService});

  String getType() {
    return sharedPreferencesManager.getString('type') ?? '';
  }

  Future<Response> getSalonList() async {
    var response = await apiService.postPrivate(
        AppConstants.getSalonOrdersList,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getIndividualOrdersList() async {
    var response = await apiService.postPrivate(
        AppConstants.getIndividualOrdersList,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
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
