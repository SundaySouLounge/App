import 'package:image_picker/image_picker.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class ProfileCategoriesParse {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProfileCategoriesParse(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getCateById() async {
    var response = await apiService.postPrivate(
        AppConstants.getSalonByUID,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getAllCities() async {
    var response = await apiService.getPrivate(AppConstants.getAllCities,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  void saveId(var id) {
    sharedPreferencesManager.putString('id', id);
  }

  Future<Response> uploadImage(XFile data) async {
    return await apiService
        .uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  Future<Response> updateSalon(var body) async {
    var response = await apiService.postPrivate(AppConstants.salonUpdate, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
