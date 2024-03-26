import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class OrderDetailsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OrderDetailsParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getAppointmentDetails(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.getAppointmnetsDetails,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateAppointments(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateAppointments,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> sendNotification(var body) async {
    var response = await apiService.postPrivate(AppConstants.sendNotification,
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
