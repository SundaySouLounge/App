import 'package:app_user/app/backend/parse/account_parse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/chat_list_model.dart';
import 'package:app_user/app/backend/parse/chat_parse.dart';

class ChatController extends GetxController implements GetxService {
  final ChatParser parser;

  String receiverId = '';
  String uid = '';
  String name = '';
  String getM = '';
  bool apiCalled = false;
  bool yourMessage = false;
  int roomId = 0;
  final message = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<ChatListModel> _chatList = <ChatListModel>[];
  List<ChatListModel> get chatList => _chatList;

  ChatController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    receiverId = Get.arguments[0].toString();
    name = Get.arguments[1].toString();
    uid = parser.getUID();
    getM = Get.arguments[2].toString();
    debugPrint(name);
    getChatRooms();
     print('Arguments:');
   for (var arg in Get.arguments) {
    print(arg.toString());
  }
  }

  Future<void> getChatRooms() async {
    Response response = await parser.getChatRooms(uid, receiverId);

    if (response.statusCode == 200) {
      apiCalled = true;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic data1 = myMap["data"];
      dynamic data2 = myMap["data2"];
      if (data1 != null &&
          data1 != '' &&
          data1['id'] != null &&
          data1['id'] != '') {
        roomId = data1['id'];
      } else if (data2 != null &&
          data2 != '' &&
          data2['id'] != null &&
          data2['id'] != '') {
        roomId = data2['id'];
      }
      getChatList();
    } else if (response.statusCode == 404) {
      createChatRooms();
    } else {
      apiCalled = true;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> createChatRooms() async {
    Response response = await parser.createChatRooms(uid, getM);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body != null && body != '') {
        roomId = body['id'];
        getChatList();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getChatList() async {
    debugPrint('calling API');
    if (roomId != 0) {
      Response response = await parser.getChatList(roomId);
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["data"];
        _chatList = [];
        body.forEach((data) {
          ChatListModel datas = ChatListModel.fromJson(data);
          _chatList.add(datas);
        });
        update();
        scrollDown();
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> sendMessage() async {
    String msg = message.text;
    message.clear();
    yourMessage = true;
    update();
    var param = {
      'room_id': roomId,
      'uid': uid,
      'sender_id': uid,
      'receiver_id': getM,
      'message': msg,
      'message_type': 0,
      'reported': 0,
      'status': 1,
    };
    Response response = await parser.sendMessage(param);
    yourMessage = false;
    update();
    //TO-DO
    // the notification is not coming
    if (response.statusCode == 200) {
      final AccountParser accountParser = Get.find();
      String msgExcerpt = msg;
      if(msg.length > 60) {
        msgExcerpt = "${msg.substring(0, 60)}...";
      }
      var notificationParam1 = {
        "id": getM,
        // "title": 'New message received',
        // "message": message
        "title": "${accountParser.getVenueName()} has sent you a message! \n$msgExcerpt",
        "message": "Click to view and reply!"
      };
      await parser.sendNotification(notificationParam1);
      print("notification  $getM");
      getChatList();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void scrollDown() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    update();
  }
}
