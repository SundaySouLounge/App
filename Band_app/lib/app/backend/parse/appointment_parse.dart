import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class AppointmentParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AppointmentParser(
      {required this.sharedPreferencesManager, required this.apiService});

  String getType() {
    return sharedPreferencesManager.getString('type') ?? '';
  }

  Future<Response> getSalonList() async {
    var response = await apiService.postPrivate(
        AppConstants.getSalonAppointmentsList,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getIndividualAppointmentsList() async {
    var response = await apiService.postPrivate(
        AppConstants.getIndividualAppointmentsList,
        {"id": sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ??
        AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ??
        AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ??
        AppConstants.defaultCurrencySymbol;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getMyEventContracts() async {
    var response = await apiService.getPrivate(
        AppConstants.getMyEventContracts,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getSavedEventContractsByUid() async {
    return await apiService.postPrivate(
        AppConstants.getSavedEventContractsByUid,
        {'id': getUID(), "type": getType()},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getEventContractById(var body) async {
    var response =
        await apiService.postPublic(AppConstants.getEventContractById, body);
    return response;
  }

  Future<Response> updateEventContractById(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.updateEventContractById,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> sendNotification(var body) async {
    var response = await apiService.postPrivate(AppConstants.sendNotification,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
