import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class IndividualSlotParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  IndividualSlotParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getSlots(var body) {
    return apiService.postPrivate(AppConstants.getSlotsForBookings, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getSpecialist(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSpecislistById,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
