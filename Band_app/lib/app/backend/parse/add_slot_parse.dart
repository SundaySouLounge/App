import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class AddSlotParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddSlotParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> onCreateTimeSlot(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.createTimeSlot,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onUpdateSlots(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.updateSlot, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getSlotbyId(var id) async {
    var response = await apiService.postPrivate(AppConstants.getSlotInfoById,
        {"id": id}, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
