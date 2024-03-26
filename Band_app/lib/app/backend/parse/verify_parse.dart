import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class VerifyParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  VerifyParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> resetWithOTPMail(dynamic param) async {
    return await apiService.postPublic(AppConstants.resetWithEmail, param);
  }

  Future<Response> verifyOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyOTPForReset, param);
  }

  Future<Response> updatePassword(var param, String token) async {
    return await apiService.postPrivate(
        AppConstants.updatePasswordWithToken, param, token);
  }
}
