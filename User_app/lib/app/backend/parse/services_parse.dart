import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class ServicesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ServicesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> salonDetails(var body) async {
    return await apiService.postPublic(AppConstants.salonDetails, body);
  }

  Future<Response> updateFavoriteSalon(var body) async {
    return await apiService.postPrivate(AppConstants.updateFavoriteSalon, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> deleteFavoriteSalon(var body) async {
    return await apiService.postPrivate(AppConstants.deleteFavoriteSalon, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getOwnerReviewsList(var body) async {
    return await apiService.postPublic(AppConstants.getOwnerReviewsList, body);
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

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' &&
            sharedPreferencesManager.getString('uid') != null
        ? true
        : false;
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }

  bool isLogin() {
    return sharedPreferencesManager.getString('uid') != null &&
            sharedPreferencesManager.getString('uid') != ''
        ? true
        : false;
  }
}
