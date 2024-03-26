import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class StylistParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  StylistParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getBySalonId(var body) async {
    var response = await apiService.postPrivate(AppConstants.getBySalonId, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> salonDestroy(var body) async {
    var response = await apiService.postPrivate(AppConstants.destroySalon, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUid() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> onUpdateService(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateSalon, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
