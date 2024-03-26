import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class EventsCreationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  EventsCreationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> salonDetails(var body) async {
    return await apiService.postPrivate(AppConstants.salonDetails, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> createEventContract(var body) async {
    return await apiService.postPrivate(AppConstants.createEventContract, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getSavedEventContracts(var body) async {
    return await apiService.postPublic(
        AppConstants.getSavedEventContracts, body);
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

  String getVenueNumber() {
    return sharedPreferencesManager.getString('mobile') ?? '';
  }

  String getVenueName() {
    return sharedPreferencesManager.getString('venue_name') ?? '';
  }

  String getVenueAddress() {
    return sharedPreferencesManager.getString('venue_address') ?? '';
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

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> sendNotification(var body) async {
    var response = await apiService.postPrivate(AppConstants.sendNotification,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getUnavailableDatesById(data) async {
    return await apiService.postPublic(
        AppConstants.getUnavailableDatesById,
        data);
  }
}
