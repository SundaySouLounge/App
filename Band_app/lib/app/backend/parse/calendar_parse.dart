import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class CalendarsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CalendarsParser(
      {required this.sharedPreferencesManager, required this.apiService});

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getType() {
    return sharedPreferencesManager.getString('type') ?? '';
  }

  Future<Response> getSavedEventContractsByUid() async {
    return await apiService.postPrivate(
        AppConstants.getSavedEventContractsByUid,
        {'id': getUID(), "type": getType()},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getCalendarView() async {
    return await apiService.postPrivate(
        AppConstants.calendarView,
        {'id': getUID(), "type": getType()},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getByDate(var body) async {
    return await apiService.postPrivate(AppConstants.getByDate, body,
        sharedPreferencesManager.getString('token') ?? '');
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

  Future<Response> getUnavailableDatesByUid() async {
    return await apiService.postPrivate(
        AppConstants.getUnavailableDatesByUid,
        {'id': getUID(), "type": getType()},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateUnavailableDatesByUid(dates) async {
    return await apiService.postPrivate(
      AppConstants.updateUnavailableDatesByUid,
      {
        'id': getUID(),
        "type": getType(),
        "dates": dates,
      },
      sharedPreferencesManager.getString('token') ?? '',
    );
  }
}
