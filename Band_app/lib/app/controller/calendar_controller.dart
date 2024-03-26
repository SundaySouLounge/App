// import 'dart:math';
import 'dart:collection';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/appointment_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/calendar_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/calendar_parse.dart';
import 'package:ultimate_band_owner_flutter/app/controller/order_details_controller.dart';
import 'package:ultimate_band_owner_flutter/app/helper/router.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';
import 'package:ultimate_band_owner_flutter/app/util/table_calendar_utils.dart';

class CalendarsController extends GetxController implements GetxService {
  final CalendarsParser parser;
  bool apiCalled = false;
  List<EventContractModel> savedEventContractsList = [];
  List<DateTime> unavailableDatesList = [];

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  bool calendarListCalled = true;

  List<AppointmentModel> _appointmentList = <AppointmentModel>[];
  List<AppointmentModel> get appointmentList => _appointmentList;

  CalendarsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    // getCalendarView();
    // getSavedEventContractsByUid();
    // getUnavailableDatesByUid();
  }

  Future<void> getSavedEventContractsByUid() async {
    Response response = await parser.getSavedEventContractsByUid();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      savedEventContractsList = myMap['data']
          .map<EventContractModel>((item) => EventContractModel.fromJson(item))
          .toList();
    }
    apiCalled = true;
    calendarListCalled = true;

    update();
  }

  // Future<void> getCalendarView() async {
  //   Response response = await parser.getCalendarView();
  //   apiCalled = true;
  //   _list = [];
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
  //     dynamic body = myMap["data"];
  //     body.forEach((element) {
  //       CalendarModel data = CalendarModel.fromJson(element);
  //       _list.add(data);
  //     });
  //     final List<Color> colorCollection = <Color>[];
  //     colorCollection.add(const Color(0xFF0F8644));
  //     colorCollection.add(const Color(0xFF8B1FA9));
  //     colorCollection.add(const Color(0xFFD20100));
  //     colorCollection.add(const Color(0xFFFC571D));
  //     colorCollection.add(const Color(0xFF36B37B));
  //     colorCollection.add(const Color(0xFF01A1EF));
  //     colorCollection.add(const Color(0xFF3D4FB5));
  //     colorCollection.add(const Color(0xFFE47C73));
  //     colorCollection.add(const Color(0xFF636363));
  //     colorCollection.add(const Color(0xFF0A8043));
  //     final List<Meeting> meetings = <Meeting>[];
  //     final Random random = Random();
  //     for (var element in _list) {
  //       debugPrint(element.day);
  //       final DateTime startDate = DateTime.parse(element.day.toString());
  //       int limit = int.parse(element.count.toString());
  //       for (int i = 0; i < limit; i++) {
  //         meetings.add(Meeting(
  //             '',
  //             '',
  //             '',
  //             null,
  //             startDate,
  //             startDate.add(Duration(hours: random.nextInt(3))),
  //             colorCollection[random.nextInt(9)],
  //             false,
  //             '',
  //             '',
  //             ''));
  //       }
  //     }
  //     events = MeetingDataSource(meetings);
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }

  void onOrderDetails() {
    Get.toNamed(AppRouter.getOrderDetailsRoute());
  }

  Future<void> getByDate(var date) async {
    calendarListCalled = false;
    _appointmentList = [];
    update();
    var param = {"id": parser.getUID(), "date": date, "type": parser.getType()};
    Response response = await parser.getByDate(param);
    calendarListCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _appointmentList = [];
      body.forEach((data) {
        AppointmentModel appointment = AppointmentModel.fromJson(data);
        _appointmentList.add(appointment);
      });
      // debugPrint(appointmentList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getUnavailableDatesByUid() async {
    apiCalled = false;
    calendarListCalled = false;

    update();
    Response response = await parser.getUnavailableDatesByUid();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      unavailableDatesList = (myMap['data'] as List<dynamic>)
          .map<DateTime>((item) => DateTime.parse(item.toString()))
          .toList();
    }
    apiCalled = true;
    calendarListCalled = true;

    update();
  }

Future<List<DateTime>> updateUnavailableDatesByUid(DateTime date) async {
    if (!unavailableDatesList.any((unavailableDate) => isSameDay(unavailableDate, date))) {
      unavailableDatesList.add(date);
    } else {
      unavailableDatesList.remove(date);
    }
    print('Requesting unavailable dates for UID: ${parser.getUID()} and type: ${parser.getType()}');
    print('Selected Date: $date');
    Response response = await parser.updateUnavailableDatesByUid(
        unavailableDatesList.map((e) => e.toIso8601String()).toList());
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      unavailableDatesList = (myMap['data'] as List<dynamic>)
          .map<DateTime>((item) => DateTime.parse(item.toString()))
          .toList();
    }
    apiCalled = true;
    calendarListCalled = true;

    update();
    return unavailableDatesList;
}

  void onAppointment(int id) {
    // Get.toNamed(AppRouter.getOrderDetailsRoute());
    Get.delete<OrderDetailsController>(force: true);
    Get.toNamed(AppRouter.getOrderDetailsRoute(), arguments: [id]);
  }
}
