import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/conversion_model.dart';
import 'package:app_user/app/backend/parse/account_chat_parse.dart';
import 'package:app_user/app/controller/chat_controller.dart';
import 'package:app_user/app/helper/router.dart';

class AccountChatController extends GetxController implements GetxService {
  final AccountChatParser parser;

  String uid = '';
  bool apiCalled = false;
  List<ChatConversionModel> _chatList = <ChatConversionModel>[];
  List<ChatConversionModel> get chatList => _chatList;
  AccountChatController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    uid = parser.getUID();
    getChatConversion();
  }

  Future<void> getChatConversion() async {
  
    if (parser.haveLoggedIn() == true) {
      Response response = await parser.getChatConversion(uid);
      apiCalled = true;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["data"];
        _chatList = [];
        body.forEach((data) {
          ChatConversionModel datas = ChatConversionModel.fromJson(data);
          _chatList.add(datas);
        });
        debugPrint(chatList.length.toString());
        for (int index = 0; index < _chatList.length; index++) {
          print("Sender Type: ${_chatList[index].receiverType}");
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }
  void onChat(String uid, String name, String senderId) {
    Get.delete<ChatController>(force: true);
    Get.toNamed(AppRouter.getChatRoutes(), arguments: [uid, name, senderId]);
  }

  void onLoginRoutes() {
    Get.toNamed(AppRouter.getLoginRoute(), arguments: ['account']);
  }
}
