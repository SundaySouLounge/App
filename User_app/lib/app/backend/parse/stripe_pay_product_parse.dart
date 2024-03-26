import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class StripePayProductParse {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  StripePayProductParse(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getProfile() async {
    return await apiService.postPrivate(
        AppConstants.getUserProfile,
        {'id': sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getStripeCards(var id) async {
    return await apiService.postPrivate(AppConstants.getStripeCards, {'id': id},
        sharedPreferencesManager.getString('token') ?? '');
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ??
        AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ??
        AppConstants.defaultCurrencySymbol;
  }

  Future<Response> createAppoinment(var param) async {
    return await apiService.postPrivate(AppConstants.productCreate, param,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> checkout(param) async {
    return await apiService.postPrivate(AppConstants.stripeCheckout, param,
        sharedPreferencesManager.getString('token') ?? '');
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
