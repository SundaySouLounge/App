import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/notification_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/notification_parse.dart';
import 'package:ultimate_band_owner_flutter/app/controller/chat_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/login_controller.dart';
import 'package:ultimate_band_owner_flutter/app/helper/router.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController implements GetxService {
  final NotificationsParser parser;

  List<NotificationModel> notificationList = [];
  EventContractModel? eventContractData;
  bool apiCalled = false;

  bool haveData = false;

  String title = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  final priceTextEditor = TextEditingController();
  final infoTextEditor = TextEditingController();
   int get notificationCount => notificationList.length;

  NotificationController({required this.parser});

  // @override
  // void onInit() {
  //   super.onInit();
  //   currencySide = parser.getCurrencySide();
  //   currencySymbol = parser.getCurrencySymbol();
  //   title = parser.getAddressName();
  //   // if (Get.arguments != null) {
  //   //   parser.getEventContractById(Get.arguments['event_contract_id'])
  //   //   eventContractData = EventContractModel.fromJson(Get.arguments);
  //   //   Get.dialog(const NewEventRequestDialog());
  //   // }

  //   if (parser.isLogin() == true) {
  //     getNotificationData();
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    print('onInit called');
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    title = parser.getAddressName();
 String formattedDate = customFormattedDate(DateTime.now());
    // Accessing user_id from arguments
    print('onInit called22');
    // if (arguments != null && arguments.containsKey('user_id')) {
    //   String userId = arguments['user_id'];
    //   // Now you can use userId to update eventContractData
    //   updateEventContractData(userId);
    // }

    // if (parser.isLogin() == true) {
    //   getNotificationData();
    // }
  }

  void updateEventContractData(String userId) async {
    print('Updating eventContractData with userId: $userId');
    EventContractModel? updatedEventContract =
        await getEventContractById(userId);

    // Update eventContractData if data is available
    if (updatedEventContract != null) {
      eventContractData = updatedEventContract;
      update();
    }
  }

  String customFormattedDate(DateTime date) {
  // String formattedDate = DateFormat('EEEE d MMMM yyyy').format(date);
    String formattedDate = Jiffy(date).format('EEEE do MMMM');
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
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onChat() {
    debugPrint('on chat');
    if (parser.isLogin() == true && eventContractData != null) {
      Get.delete<ChatController>(force: true);
      Get.toNamed(AppRouter.getChatRoute(), arguments: [
        // parser.getUID(),
        eventContractData!.userId,
        // '${parser.sharedPreferencesManager.clearKey('first_name')} ${parser.sharedPreferencesManager.clearKey('last_name')}'
         eventContractData!.nameVenue,
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
     double newFee = double.tryParse(priceTextEditor.text) ?? 0.0;
     String updatedBodys = '${eventContractData!.bodys} Artist: £ ${priceTextEditor.text} ${infoTextEditor.text} /n';
      String currentDate = customFormattedDate(eventContractData!.date!);
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "${eventContractData!.musician} is negotiating your contact! ",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "You negotiated a contract with ${eventContractData!.nameVenue} for $currentDate",
        "message": "Click to View!",
      };
      await parser.sendNotification(notificationParam2);
      eventContractData!.suggester = 'owner';
      eventContractData!.fee = newFee;
      eventContractData!.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      update();
    }
  }

  Future<void> onAcceptSubmit() async {
     String updatedBodys = '${eventContractData!.bodys} Artist: Date change Accepted /n';
     String currentDate = customFormattedDate(eventContractData!.date!);
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "${eventContractData!.musician} accepted your Date change!",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "You accepted Date change from ${eventContractData!.nameVenue}",
        "message": "$currentDate",
      };
      eventContractData!.bodys = updatedBodys;
      eventContractData!.suggester = 'owner';
      await parser.updateEventContractById(eventContractData);
      await parser.sendNotification(notificationParam2);
      update();
    }
  }

  Future<void> onDeclineSubmit() async {
    String updatedBodys = '${eventContractData!.bodys} Artist: Date change Declined /n';
   String currentDate = customFormattedDate(eventContractData!.date!);
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "We're sorry but ${eventContractData!.musician} has declined your Date Change",
        "message": "Send him a message?",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        "title": "You declined Date change from ${eventContractData!.nameVenue}",
        "message": "$currentDate",
      };
      eventContractData!.bodys = updatedBodys;
      eventContractData!.suggester = 'owner';
      await parser.updateEventContractById(eventContractData);
      await parser.sendNotification(notificationParam2);
      update();
    }
  }

  Future<void> onAcceptContract() async {
    String updatedBodys = '${eventContractData!.bodys} Artist: Contract Accepted /n';
    String currentDate = customFormattedDate(eventContractData!.date!);
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        "title": "${eventContractData!.musician} accepted your contract!",
        "message": "$currentDate",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
       "title": "You have accepted a contract from ${eventContractData!.nameVenue}",
        "message": "$currentDate",
      };
      eventContractData!.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      await parser.sendNotification(notificationParam2);
      update();
    }
  }

  Future<void> onDeclineContract() async {
    String currentDate = customFormattedDate(eventContractData!.date!);
    String updatedBodys = '${eventContractData!.bodys} Artist: Contract Declined /n';
    if (eventContractData != null) {
      var notificationParam1 = {
        "id": eventContractData!.userId,
        // "title": "We're sorry but ${eventContractData!.musician} is unavailable on ${eventContractData!.date}!",
        "title": "We're sorry but ${eventContractData!.musician} is unavailable on $currentDate!",
        "message": "Please pick another date...",
      };
      await parser.sendNotification(notificationParam1);
      var notificationParam2 = {
        "id": eventContractData!.individualUid ?? eventContractData!.salonUid,
        // "title": "You declined a contract from ${eventContractData!.nameVenue} on ${eventContractData!.date}",
        "title": "You declined a contract from ${eventContractData!.nameVenue} on $currentDate",
        "message": "$currentDate",
      };
      eventContractData!.bodys = updatedBodys;
      await parser.updateEventContractById(eventContractData);
      await parser.sendNotification(notificationParam2);
      update();
    }
  }
}
