import 'package:image_picker/image_picker.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class AddStylistParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddStylistParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> onCreateSpecialist(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.createSpecialist,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getByID(var body) async {
    var response = await apiService.postPrivate(AppConstants.getById, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onUpdateService(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateSalon, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> uploadImage(XFile data) async {
    return await apiService
        .uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  String getUid() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
