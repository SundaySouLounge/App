import 'package:image_picker/image_picker.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class CreateProductsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CreateProductsParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> onCreateProducts(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.createProducts,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> uploadImage(XFile data) async {
    return await apiService
        .uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  String getFreelancerId() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getProductById(String id) async {
    var response = await apiService.postPrivate(AppConstants.getProductById,
        {"id": id}, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateProducts(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateProduct,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
