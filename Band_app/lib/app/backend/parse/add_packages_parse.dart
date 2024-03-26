import 'package:image_picker/image_picker.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class AddPackagesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddPackagesParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> onCreateProducts(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.createPackages,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> uploadImage(XFile data) async {
    return await apiService
        .uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  Future<Response> getByID(var body) async {
    var response = await apiService.postPrivate(AppConstants.getPackagesById,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  bool getType() {
    return sharedPreferencesManager.getString('type') == 'salon' ? true : false;
  }

  String getUId() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> updatePackages(var body) async {
    var response = await apiService.postPrivate(AppConstants.packagesUpdate,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
