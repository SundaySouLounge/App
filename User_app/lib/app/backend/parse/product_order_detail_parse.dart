import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class ProductOrderDetailParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProductOrderDetailParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getOrderDetails(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.getProductOrderInfo,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateProductOrder(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateProductOrder,
        body, sharedPreferencesManager.getString('token') ?? '');
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

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? '';
  }

  int getAdminId() {
    return sharedPreferencesManager.getInt('supportUID') ?? 0;
  }

  String getAdminName() {
    return sharedPreferencesManager.getString('supportName') ?? '';
  }
}
