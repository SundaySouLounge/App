import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class BookingParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  BookingParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getAppointmentById() async {
    return await apiService.postPrivate(
        AppConstants.getAppoimentById,
        {'id': sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
  }

  void saveUID(String id) {
    sharedPreferencesManager.putString('uid', id);
  }

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' &&
            sharedPreferencesManager.getString('uid') != null
        ? true
        : false;
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

  Future<Response> getMyEventContracts() async {
    var response = await apiService.getPrivate(
        AppConstants.getMyEventContracts,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
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
    var response = await apiService.postPrivate(AppConstants.deletePushNotification,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
