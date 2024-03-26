import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class CalendarEventParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CalendarEventParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getAllCalendarEvents() async {
    var response = await apiService.getPrivate(
        AppConstants.getAllCalendarEvents,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getMyCalendarEvents() async {
    var response = await apiService.postPrivate(
        AppConstants.getMyCalendarEvents,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onCreateCalendarEvent(dynamic body) async {
    var response = await apiService.postPrivate(
        AppConstants.createCalendarEvent,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> onUpdateCalendarEvent(dynamic body) async {
    var response = await apiService.postPrivate(
        AppConstants.updateCalendarEvent,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getCalendarEventById(var id) async {
    var response = await apiService.postPrivate(
        AppConstants.getCalendarEventById,
        {"id": id},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> removeCalendarEvent(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.removeCalendarEvent,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
