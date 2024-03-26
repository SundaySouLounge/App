import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class SpecialistParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SpecialistParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> individualDetails(var body) async {
    return await apiService.postPublic(AppConstants.individualDetails, body);
  }

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' &&
            sharedPreferencesManager.getString('uid') != null
        ? true
        : false;
  }

  Future<Response> updateFavoriteIndividual(var body) async {
    return await apiService.postPrivate(AppConstants.updateFavoriteIndividual,
        body, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> deleteFavoriteIndividual(var body) async {
    return await apiService.postPrivate(AppConstants.deleteFavoriteIndividual,
        body, sharedPreferencesManager.getString('token') ?? '');
  }


  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ??
        AppConstants.defaultCurrencyCode;
  }

  Future<Response> getOwnerReviewsList(var body) async {
    return await apiService.postPublic(AppConstants.getOwnerReviewsList, body);
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ??
        AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ??
        AppConstants.defaultCurrencySymbol;
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
