import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class RegisterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RegisterParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> onRegister(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.createUser, body);
    return response;
  }

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
  }

  void saveInfo(String id, String firstName, String lastName, String cover,
      String email, String mobile, String extraField, String venueName, String venueAddress, String passwordSecond){
    sharedPreferencesManager.putString('uid', id);
    sharedPreferencesManager.putString('first_name', firstName);
    sharedPreferencesManager.putString('last_name', lastName);
    sharedPreferencesManager.putString('email', email);
    sharedPreferencesManager.putString('cover', cover);
    sharedPreferencesManager.putString('phone', mobile);
    sharedPreferencesManager.putString('extra_field', extraField);
    sharedPreferencesManager.putString('venue_name', venueName);
    sharedPreferencesManager.putString('venue_address', venueAddress);
    sharedPreferencesManager.putString('password_second', passwordSecond);
    
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

  int getVerificationMethod() {
    return sharedPreferencesManager.getInt('user_verify_with') ??
        AppConstants.defaultVerificationForSignup;
  }

  String getSMSName() {
    return sharedPreferencesManager.getString('smsName') ??
        AppConstants.defaultSMSGateway;
  }

  Future<Response> saveReferral(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.referralCode, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> sendVerificationMail(dynamic param) async {
    return await apiService.postPublic(
        AppConstants.sendVerificationMail, param);
  }

  Future<Response> verifyOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyOTP, param);
  }

  Future<Response> verifyMobileForeFirebase(dynamic param) async {
    return await apiService.postPublic(
        AppConstants.verifyMobileForeFirebase, param);
  }

  Future<Response> sendRegisterOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.sendVerificationSMS, param);
  }

  String getFcmToken() {
    return sharedPreferencesManager.getString('fcm_token') ?? 'NA';
  }
}
