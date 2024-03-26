import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class VideoParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  VideoParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getAllVideos() async {
    var response = await apiService.getPrivate(AppConstants.getAllVideos,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getMyVideos(var body) async {
    var response = await apiService.postPrivate(AppConstants.getMyVideos,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onCreateVideo(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.createVideo,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onUpdateVideo(dynamic body) async {
    var response = await apiService.postPrivate(AppConstants.updateVideo, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getVideoById(var id) async {
    var response = await apiService.postPrivate(AppConstants.getVideoById,
        {"id": id}, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> removeVideo(var body) async {
    var response = await apiService.postPrivate(AppConstants.removeVideo,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
