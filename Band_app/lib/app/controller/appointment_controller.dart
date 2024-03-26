import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/appointment_parse.dart';
import 'package:ultimate_band_owner_flutter/app/controller/chat_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/login_controller.dart';
import 'package:ultimate_band_owner_flutter/app/helper/router.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';
import 'package:http/http.dart' as http;

class AppointmentController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final AppointmentParser parser;

  List<EventContractModel> _appointmentList = <EventContractModel>[];
  List<EventContractModel> get appointmentList => _appointmentList;

  List<EventContractModel> _appointmentListOld = <EventContractModel>[];
  List<EventContractModel> get appointmentListOld => _appointmentListOld;

  bool apiCalled = false;
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<String> statusName = [
    'Created'.tr,
    'Accepted'.tr,
    'Rejected'.tr,
    'Ongoing'.tr,
    'Completed'.tr,
    'Cancelled'.tr,
    'Refunded'.tr,
    'Delayed'.tr,
    'Panding Payment'.tr,
  ];
  AppointmentController({required this.parser});

  late TabController tabController;

  final priceTextEditor = TextEditingController();
  final infoTextEditor = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    tabController = TabController(length: 3, vsync: this);
    getSavedEventContractsByUid();
    String formattedDate = customFormattedDate(DateTime.now());

  }

  String customFormattedDate(DateTime date) {
  String formattedDate = DateFormat('EEEE d MMMM yyyy').format(date);
  return formattedDate;
}

  Future<void> getSavedEventContractsByUid() async {
    print("api1");
    Response response = await parser.getSavedEventContractsByUid();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      final body = myMap['data'] as List;

      // notificationList = body
      //     .map<EventContractModel>((item) => EventContractModel.fromJson(item))
      //     .toList();
      _appointmentList = [];
      _appointmentListOld = [];
      for (var data in body) {
        EventContractModel appointment = EventContractModel.fromJson(data);
        if (appointment.date != null &&
            DateTime.now().compareTo(appointment.date!) == 1) {
          _appointmentListOld.add(appointment);
        } else {
          _appointmentList.add(appointment);
        }
      }
      debugPrint(jsonEncode(_appointmentList));
    } else {
      ApiChecker.checkApi(response);
    }
    
    update();
  }

  Future<void> updateEventContractStatus(
      EventContractModel eventContractData, String status) async {
        print("api2");
    eventContractData.status = status;
    Response response = await parser.updateEventContractById(eventContractData);
    if (response.statusCode == 200) {
      apiCalled = true;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      final body = myMap['data'];

      // eventContractData = EventContractModel.fromJson(body);
      // if (status == 'Declined') {
      //   await deletePushNotification(id);
      // }

      // var notificationParam = {
      //   "id": eventContractData!.userId,
      //   "title": 'Requested contract updated'.tr,
      //   "message": "Requested contract $status"
      // };
      // await parser.sendNotification(notificationParam);
      await getSavedEventContractsByUid();
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  
  Future<void> onNegoSubmit(EventContractModel eventContractData, double newFee) async {
     double newFee = double.tryParse(priceTextEditor.text) ?? 0.0;
      String currentDate = customFormattedDate(eventContractData.date!);
     String updatedBodys = ' ${eventContractData.bodys} Artist: £ ${priceTextEditor.text} ${infoTextEditor.text} /n';
    var notificationParam1 = {
      "id": eventContractData.userId,
      "title": "${eventContractData.musician} is negotiating your contact! ",
      "message": "$currentDate",
    };
    await parser.sendNotification(notificationParam1);
    var notificationParam2 = {
      "id": eventContractData.individualUid ?? eventContractData.salonUid,
     "title": "You negotiated a contract with ${eventContractData.nameVenue} for $currentDate",
      "message": "Click to View!",
    };
    await parser.sendNotification(notificationParam2);
    eventContractData.fee = newFee;
    eventContractData.bodys = updatedBodys;
    eventContractData.suggester = 'owner';
    await parser.updateEventContractById(eventContractData);
    update();
  }

  void onChat(EventContractModel eventContractData) {
    debugPrint('on chat');
    Get.delete<ChatController>(force: true);
    Get.toNamed(AppRouter.getChatRoute(), arguments: [
      // parser.getUID(),
      eventContractData.userId,
      // '${parser.sharedPreferencesManager.clearKey('first_name')} ${parser.sharedPreferencesManager.clearKey('last_name')}'
      eventContractData.nameVenue,
      eventContractData.individualUid,
    ]);
  }

  void getList() {
    if (parser.getType() == 'salon') {
      getSalonAppointmentById();
    } else {
      getIndividualAppointmentsById();
    }
  }

  Future<void> getSalonAppointmentById() async {
    Response response = await parser.getSalonList();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _appointmentList = [];
      _appointmentListOld = [];
      // body.forEach((data) {
      //   AppointmentModel appointment = AppointmentModel.fromJson(data);
      //   if (appointment.status == 0) {
      //     _appointmentList.add(appointment);
      //   } else {
      //     _appointmentListOld.add(appointment);
      //   }
      // });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getIndividualAppointmentsById() async {
    Response response = await parser.getIndividualAppointmentsList();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _appointmentList = [];
      _appointmentListOld = [];
      // body.forEach((data) {
      //   AppointmentModel appointment = AppointmentModel.fromJson(data);
      //   if (appointment.status == 0) {
      //     _appointmentList.add(appointment);
      //   } else {
      //     _appointmentListOld.add(appointment);
      //   }
      // });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
   Future<void> onAcceptContract( EventContractModel eventContractData) async {
        String currentDate = customFormattedDate(eventContractData.date!);
    String updatedBodys = ' ${eventContractData.bodys} Artist: Contract Accepted /n';
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "${eventContractData.musician} accepted a contract!",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "You have accepted a contract from ${eventContractData.nameVenue}",
        "message": "$currentDate",
      };
      eventContractData.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      await parser.sendNotification(notificationParam2);
      update();
    }
  }

  Future<void> onDeclineContract (EventContractModel eventContractData) async {
    String currentDate = customFormattedDate(eventContractData.date!);
    String updatedBodys = '${eventContractData.bodys} Artist: Contract Declined /n';
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "We're sorry but ${eventContractData!.musician} is unavailable on ${eventContractData!.date}",
        "message": "Please pick another date...",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "You declined a contract from ${eventContractData!.nameVenue} on ${eventContractData!.date}",
        "message": "$currentDate",
      };
      eventContractData.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      await parser.sendNotification(notificationParam2);
      update();
    }
  }


}
