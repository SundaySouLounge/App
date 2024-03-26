import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class NotificationsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NotificationsParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getMyNotificationData() async {
    var response = await apiService.getPrivate(
        AppConstants.getMyNotificationData,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getAddressName() {
    return sharedPreferencesManager.getString('address') ?? 'Home';
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
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

  bool isLogin() {
    return sharedPreferencesManager.getString('uid') != null &&
            sharedPreferencesManager.getString('uid') != ''
        ? true
        : false;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getEventContractById(var body) async {
    var response =
        await apiService.postPublic(AppConstants.getEventContractById, body);
    return response;
  }

  Future<Response> updateEventContractById(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.updateEventContractById,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> sendNotification(var body) async {
    var response = await apiService.postPrivate(AppConstants.sendNotification,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> deletePushNotification(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.deletePushNotification,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
