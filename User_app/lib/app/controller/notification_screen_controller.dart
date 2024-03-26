import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/event_contract_model.dart';
import 'package:app_user/app/backend/models/notification_model.dart';
import 'package:app_user/app/backend/parse/notification_parse.dart';
import 'package:app_user/app/controller/chat_controller.dart';
import 'package:app_user/app/controller/login_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/constant.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationsParser parser;

  List<NotificationModel> notificationList = [];
  EventContractModel? eventContractData;
  bool apiCalled = false;
  Map<int, List<NotificationModel>> groupedNotifications = {};

  bool haveData = false;

  String title = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  final priceTextEditor = TextEditingController();
  final infoTextEditor = TextEditingController();
  final deadlineTextEditor = TextEditingController();
  final dateChangeTextEditor = TextEditingController();
  final dateChangeMessageTextEditor = TextEditingController();
  
   int get notificationCount => notificationList.length;

  NotificationController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    title = parser.getAddressName();
    String formattedDate = customFormattedDate(DateTime.now());

    // if (Get.arguments != null) {
    //   parser.getEventContractById(Get.arguments['event_contract_id'])
    //   eventContractData = EventContractModel.fromJson(Get.arguments);
    //   Get.dialog(const NewEventRequestDialog());
    // }
  }
String customFormattedDate(DateTime date) {
  String formattedDate = DateFormat('EEEE d MMMM yyyy').format(date);
  return formattedDate;
}
  Future<void> getNotificationData() async {
    Response response = await parser.getMyNotificationData();
    apiCalled = true;
    if (response.statusCode == 200) {
      apiCalled = true;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      final body = myMap['data'] as List;
      notificationList = body
          .map<NotificationModel>((item) => NotificationModel.fromJson(item))
          .toList();
      update();
      print('${body}');
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onChat() {
    debugPrint('on chat');
    if (parser.isLogin() == true && eventContractData != null) {
      Get.delete<ChatController>(force: true);
      Get.toNamed(AppRouter.getChatRoutes(), arguments: [
        // parser.getUID(),
        eventContractData!.userId,
        // '${parser.sharedPreferencesManager.clearKey('first_name')} ${parser.sharedPreferencesManager.clearKey('last_name')}'
        eventContractData!.musician,
        eventContractData!.individualUid,
      ]);
    } else {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getInitialRoute());
    }
  }

  Future<EventContractModel?> getEventContractById(
      String notificationData) async {
    final eventContractId = jsonDecode(notificationData)['event_contract_id'];
    if (eventContractId != null) {
      Response response =
          await parser.getEventContractById({'id': eventContractId});
      if (response.statusCode == 200) {
        apiCalled = true;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        final body = myMap['data'];

        eventContractData = EventContractModel.fromJson(body);
        update();
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
    return eventContractData;
  }

  Future<bool> updateEventContractDate(DateTime newDate) async {
  if (eventContractData != null) {
    // Update the date in the data model
    eventContractData!.date = newDate;

    // Now, you can call the update method to send the updated date to the backend
    int? eventId = eventContractData?.id;
    print("EventID: $eventId");
    if (eventId != null) {
      Response response = await parser.updateEventContractById(eventContractData);
      if (response.statusCode == 200) {
        apiCalled = true;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        final body = myMap['data'];

        eventContractData = EventContractModel.fromJson(body);
        update();
        return true;
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  return false;
}




  Future<void> updateEventContractStatus(String status, int id) async {
    if (eventContractData != null) {
      eventContractData!.status = status;
      Response response =
          await parser.updateEventContractById(eventContractData);
      if (response.statusCode == 200) {
        apiCalled = true;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        final body = myMap['data'];

        eventContractData = EventContractModel.fromJson(body);
        if (status == 'Declined') {
          await deletePushNotification(id);
        }

        // var notificationParam = {
        //   "id": eventContractData!.userId,
        //   "title": 'Requested contract updated'.tr,
        //   "message": "Requested contract $status"
        // };
        // await parser.sendNotification(notificationParam);
        update();
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> onCancelSubmit() async {
    if (eventContractData != null) {
      String currentDate = customFormattedDate(eventContractData!.date!);

      var notificationParam1 = {
        "id": eventContractData?.userId,
        "title": "$currentDate you withdrawn your contract with ",
        "message": " ${eventContractData!.musician}",
      };
      await parser.sendNotification(notificationParam1);

      var notificationParam2 = {
        "id": eventContractData?.individualUid ?? eventContractData?.salonUid,
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

  Future<void> deletePushNotification(int id) async {
    Response response = await parser.deletePushNotification({"id": id});
    if (response.statusCode == 200) {
      await getNotificationData();
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> onNegoSubmit(double newFee) async {
         String currentDate = customFormattedDate(eventContractData!.date!);
    double newFee = double.tryParse(priceTextEditor.text) ?? 0.0;
    String updatedBodys = '${eventContractData?.bodys} Venue: £ ${priceTextEditor.text} ${infoTextEditor.text} /n';
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "${eventContractData!.venueName}, $currentDate",
        "message": "Negotiating",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "${eventContractData!.venueName} has negotiated the contract for $currentDate",
        "message": "Click to reply!",
      };
      await parser.sendNotification(notificationParam2);
      eventContractData!.suggester = 'user';
      eventContractData!.fee = newFee;
      eventContractData!.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      update();
    }
  }

 Future<void> sendNotificationOnUpdate(DateTime updatedDateTime) async {
  if (eventContractData != null) {
    try {
      String formattedDate = DateFormat('MM/dd/yyyy HH:mm').format(updatedDateTime);
      String updatedBodys = '${eventContractData!.bodys} Venue: New Date $formattedDate  /n';
      var notificationParam1 = {
        "id": eventContractData!.userId,
       "title": "${eventContractData!.musician} Date Change",
        "message": "${eventContractData!.date} to $formattedDate", // Add a default message or modify as needed
      };
      print("Sending Notification 1: $notificationParam1");
      await parser.sendNotification(notificationParam1);

      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "${eventContractData!.venueName} has requested a Date Change",
        "message": "${eventContractData!.date} to $formattedDate", // Add a default message or modify as needed
      };
      print("Sending Notification 2: $notificationParam2");
      await parser.sendNotification(notificationParam2);
      eventContractData!.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      eventContractData!.suggester = 'user';
      print("Notifications Sent Successfully");
      update();
    } catch (e) {
      print("Error Sending Notifications: $e");
    }
  }
}


  Future<void> onWithdrawalSubmit(String selectedDate) async {
  // Your existing logic
  String updatedBodys = '${eventContractData!.bodys} Venue: New Deadline $selectedDate  /n';
  if (eventContractData != null) {
    var notificationParam1 = {
      "id": eventContractData!.userId,
      "title": "You have set a deadline for ${eventContractData!.musician}",
      "message": "This job offer will disappear on $selectedDate",
    };
    await parser.sendNotification(notificationParam1);
    var notificationParam2 = {
      "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
      "title": "${eventContractData!.venueName} has set a new deadline!",
      "message": "This job offer will disappear on $selectedDate",
    };
    eventContractData!.bodys = updatedBodys;
    await parser.updateEventContractById(eventContractData);
    await parser.sendNotification(notificationParam2);
    update();
  }
}

Future<void> onAcceptSubmit() async {
   String currentDate = customFormattedDate(eventContractData!.date!);
    String updatedBodysss = '${eventContractData!.bodys} Venue: The contract is Accepted /n';
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "You have accepted your contract!",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
         "title": "${eventContractData!.venueName} accepted your contract!",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam2);
      update();
    }
    eventContractData!.bodys = updatedBodysss;
    await parser.updateEventContractById(eventContractData);
  }

  Future<void> onDeclineSubmit() async {
  if (eventContractData != null) {
     String currentDate = customFormattedDate(eventContractData!.date!);
    String updatedBodys = '${eventContractData!.bodys} Venue: The contract was Declined on $currentDate \n';

    var notificationParam1 = {
      "id": eventContractData!.userId,
      "title": "You declined a contract from ${eventContractData!.musician}",
        "message": "$currentDate",
    };
    await parser.sendNotification(notificationParam1);

    var notificationParam2 = {
      "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
      "title": "We're sorry but ${eventContractData!.venueName} has declined your contract!",
        "message": "$currentDate",
    };
    eventContractData!.bodys = updatedBodys;
    await parser.updateEventContractById(eventContractData);
    await parser.sendNotification(notificationParam2);
    update();
  }
}
}
