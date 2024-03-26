import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_user/app/backend/api/handler.dart';
// import 'package:app_user/app/backend/models/appointment_model.dart';
import 'package:app_user/app/backend/models/event_contract_model.dart';
import 'package:app_user/app/backend/parse/booking_parse.dart';
import 'package:app_user/app/controller/appointment_detail_controller.dart';
import 'package:app_user/app/controller/chat_controller.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/login_controller.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:app_user/app/util/constant.dart';

class BookingController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final BookingParser parser;

  List<EventContractModel> _appointmentList = <EventContractModel>[];
  List<EventContractModel> get appointmentList => _appointmentList;

  List<EventContractModel> _appointmentListOld = <EventContractModel>[];
  List<EventContractModel> get appointmentListOld => _appointmentListOld;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  EventContractModel? eventContractModel;
  List<String> statusName = [
    'Created',
    'Accepted',
    'Rejected',
    'Ongoing',
    'Completed',
    'Cancelled',
    'Refunded',
    'Delayed',
    'Panding Payment',
  ];
  BookingController({required this.parser});

  bool apiCalled = false;

  late TabController tabController;

  final priceTextEditor = TextEditingController();
  final infoTextEditor = TextEditingController();
  final sharedPref = Get.find<SharedPreferencesManager>();
  
  @override
  void onInit() {
    super.onInit();
    final item = Get.put(NotificationController(parser: Get.find()));
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    String formattedDate = customFormattedDate(DateTime.now());
    tabController = TabController(length: 2, vsync: this);
    if (parser.haveLoggedIn() == true) {
      getMyEventContracts();
    }
  }

  String customFormattedDate(DateTime date) {
  String formattedDate = DateFormat('EEEE d MMMM yyyy').format(date);
  return formattedDate;
}

  Future<void> getMyEventContracts() async {
    Response response = await parser.getMyEventContracts();
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

  Future<void> getAppointmentById() async {
    Response response = await parser.getAppointmentById();

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
      debugPrint(jsonEncode(_appointmentList));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> updateEventContractStatus(
      EventContractModel eventContractData, String status) async {
    eventContractData.status = status;
    Response response = await parser.updateEventContractById(eventContractData);
    if (response.statusCode == 200) {
      apiCalled = true;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      final body = myMap['data'];

      eventContractData = EventContractModel.fromJson(body);
      if (status == 'Declined') {
        await deletePushNotification(eventContractData.id!);
      }

      // var notificationParam = {
      //   "id": eventContractData!.userId,
      //   "title": 'Requested contract updated'.tr,
      //   "message": "Requested contract $status"
      // };
      // await parser.sendNotification(notificationParam);
      await getMyEventContracts();
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> deletePushNotification(int id) async {
    Response response = await parser.deletePushNotification({"id": id});
    if (response.statusCode == 200) {
      await getMyEventContracts();
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

 Future<void> onNegoSubmit(
  EventContractModel eventContractData, double newFee) async {
  double newFee = double.tryParse(priceTextEditor.text) ?? 0.0;
  
  // Format the date from eventContractData
  String formattedEventDate = customFormattedDate(eventContractData.date!);
  
  // Concatenate old data with new data
  String updatedBodys =
      '${eventContractData.bodys} Venue: £ ${priceTextEditor.text} ${infoTextEditor.text} /n';

  var notificationParam1 = {
    "id": eventContractData.userId,
    "title": "${eventContractData.venueName} $formattedEventDate",
    "message": "Negotiating",
  };
  await parser.sendNotification(notificationParam1);

  var notificationParam2 = {
    "id": eventContractData.individualUid ?? eventContractData.salonUid,
    "title":
        "${eventContractData.venueName} has negotiated the contract for $formattedEventDate",
    "message": "Click to reply!",
  };
  await parser.sendNotification(notificationParam2);

  eventContractData.suggester = 'user';
  eventContractData.fee = newFee;

  // Update the bodys property
  eventContractData.bodys = updatedBodys;

  await parser.updateEventContractById(eventContractData);
  update();
}


  Future<void> sendNotificationOnUpdate(
      EventContractModel eventContractData, DateTime updatedDateTime) async {
    if (eventContractData != null) {
      try {
        String formattedDate =
            DateFormat('dd/MM/yyyy HH:mm').format(updatedDateTime);
        String updatedBodys =
            '${eventContractData.bodys} Venue: New Date $formattedDate /n';
        var notificationParam1 = {
          "id": eventContractData!.userId,
          "title": "${eventContractData.musician} Date Change",
          "message":
              "${eventContractData.date} to $formattedDate", // Add a default message or modify as needed
        };
        print("Sending Notification 1: $notificationParam1");
        await parser.sendNotification(notificationParam1);

        var notificationParam2 = {
          "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
          "title": "${eventContractData.venueName} has requested a Date Change",
          "message":
              "${eventContractData.date} to $formattedDate", // Add a default message or modify as needed
        };
        print("Sending Notification 2: $notificationParam2");
        await parser.sendNotification(notificationParam2);

        update();
        eventContractData.bodys = updatedBodys;
        await parser.updateEventContractById(eventContractData);
        eventContractData.suggester = 'user';
      } catch (e) {
        print("Error Sending Notifications: $e");
      }
    }
  }

 Future<void> onWithdrawalSubmit(
    EventContractModel eventContractData, String selectedDate) async {
  // Your existing logic
  String formattedSelectedDate = customFormattedDate(DateTime.parse(selectedDate));

  String updatedBodys =
      '${eventContractData.bodys} Venue: New Deadline $formattedSelectedDate /n';
  if (eventContractData != null) {
    var notificationParam1 = {
      "id": eventContractData.userId,
      "title": "You have set a deadline for ${eventContractData.musician}",
      "message": "This job offer will disappear on $formattedSelectedDate",
    };
    await parser.sendNotification(notificationParam1);
    var notificationParam2 = {
      "id": eventContractData.individualUid ?? eventContractData.salonUid,
      "title": "${eventContractData.venueName} has set a new deadline!",
      "message": "This job offer will disappear on $formattedSelectedDate",
    };
    eventContractData.bodys = updatedBodys;
    await parser.updateEventContractById(eventContractData);
    await parser.sendNotification(notificationParam2);

    update();
  }
}


  void onChat(EventContractModel eventContractData) {
    debugPrint('on chat');
    if (parser.haveLoggedIn() == true) {
      Get.delete<ChatController>(force: true);
      Get.toNamed(AppRouter.getChatRoutes(), arguments: [
        // parser.getUID(),
        eventContractData.userId,
        // '${parser.sharedPreferencesManager.clearKey('first_name')} ${parser.sharedPreferencesManager.clearKey('last_name')}'
         eventContractData.musician,
         eventContractData.individualUid,
      ]);
    } else {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getInitialRoute());
    }
  }

  void onLoginRoutes() {
    Get.delete<LoginController>(force: true);
    Get.toNamed(AppRouter.getLoginRoute());
  }

  Future<bool> updateEventContractDate(
      DateTime newDate, EventContractModel? eventContractData) async {
    if (eventContractData == null) {
      print('EventContractData is null');
      return false;
    }
    eventContractData.date = newDate;
    print('EventContractData is null333 ${eventContractData.id}');
    int? eventId = eventContractData.id;
    if (eventId != null) {
      print('EventContractData is null2');
      Response response =
          await parser.updateEventContractById(eventContractData);
      if (response.statusCode == 200) {
        apiCalled = true;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        final body = myMap['data'];
        print('Updated Event Contract Data: ${body}');

        // Update the local data with the response from the server
        eventContractData = EventContractModel.fromJson(body);

        // Trigger a UI update
        update();
        return true;
      } else {
        // Handle API error
        ApiChecker.checkApi(response);
      }
    }

    return false;
  }
   Future<void> onCancelSubmit(EventContractModel? eventContractData) async {
    if (eventContractData != null) {
      String currentDate = customFormattedDate(DateTime.now());

      var notificationParam1 = {
        "id": eventContractData.userId,
        "title": "$currentDate you withdrawn your contract with ",
        "message": " ${eventContractData!.musician}",
      };
      await parser.sendNotification(notificationParam1);

      var notificationParam2 = {
        "id": eventContractData.individualUid ?? eventContractData.salonUid,
        "title": "${eventContractData!.venueName} has withdrawn your contract for",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam2);

      // Update the bodys property
      await parser.updateEventContractById(eventContractData);

      // Call the update function
      update();
    }
  }

  Future<void> onAcceptSubmit(EventContractModel? eventContractData) async {
    if (eventContractData != null) {
      String updatedBodysss =
          '${eventContractData.bodys} Venue: The contract is Accepted /n';
      String currentDate = customFormattedDate(eventContractData.date!);

      var notificationParam1 = {
        "id": eventContractData.userId,
        "title": "You have accepted your contract! ",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);

      var notificationParam2 = {
        "id": eventContractData.individualUid ?? eventContractData.salonUid,
        "title": "${eventContractData!.venueName} accepted your contract!",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam2);

      // Update the bodys property
      eventContractData.bodys = updatedBodysss;
      await parser.updateEventContractById(eventContractData);

      // Call the update function
      update();
    }
  }

  Future<void> onDeclineSubmit(EventContractModel? eventContractData) async {
    String updatedBodys =
        '${eventContractData?.bodys} Venue: The Contract was Declined /n';
    String currentDate = customFormattedDate(eventContractData!.date!);

    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "You declined a contract from ${eventContractData.musician}",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title":
            "We're sorry but ${eventContractData.venueName} has declined your contract!",
        "message": "$currentDate",
      };
      eventContractData.bodys = updatedBodys;
      await parser.sendNotification(notificationParam2);
      await parser.updateEventContractById(eventContractData);
      update();
    }
  }

   Future<void> onRebook(EventContractModel? eventContractData) async {
    debugPrint(">>>>>>>>>>>>>>>>>>>>>UD ${eventContractData}");
    sharedPref.sharedPreferences?.setInt(
      "key-individualId",
      eventContractData!.individualId!,
    );
    if (eventContractData!.salonId != null) {
      sharedPref.sharedPreferences?.setInt(
        "key-salonId",
        eventContractData.salonId!,
      );
    }
    EventsCreationController eventsCreationController =
        Get.put(EventsCreationController(parser: Get.find()));
    //TO-DO
    //here is call the method
 String currentDate = customFormattedDate(DateTime.now());
    debugPrint(">>>>>>>>>>>>>>>>>>>>>UD ${eventContractData}");

    String updatedBodys =
        '${eventContractData!.bodys} Venue: The contract was Re-Book /n';
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "You sent a contract to ${eventContractData!.musician}",
        "message": "$currentDate ",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "${eventContractData!.venueName} has sent you a contract!",
        "message": "$currentDate",
      };
      print(eventContractData.id);
      print(
          ' heeeewewy  time: ${eventContractData.individualId!.toInt()} bandSize: ${eventContractData.bandSize.toString()} fee: ${eventContractData.fee} extraField: ${eventContractData.extraField} ');
      eventContractData.bodys = updatedBodys;

      eventContractData.suggester = 'user';

      await eventsCreationController.createNewEvent(eventContractData.toJson());
      await parser.sendNotification(notificationParam2);
      //await parser.updateEventContractById(eventContractData);
      update();
    }
  }
}
