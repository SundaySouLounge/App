import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class ProductsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProductsParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getproductsByIdAndCateId(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.getProductsByIdAndCateId,
        body,
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
