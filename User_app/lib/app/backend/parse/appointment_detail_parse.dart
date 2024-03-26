import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class AppointmentDetailParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AppointmentDetailParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getAppointmentDetails(var body) async {
    var response = await apiService.postPrivate(AppConstants.getAppoimentInfo,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onUpdateAppointmentStatus(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.updateAppointmentStatus,
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
