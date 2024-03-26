import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/account_chat_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/view/inbox_screen/widgets/inbox_content.dart';
import 'package:skeletons/skeletons.dart';

class AccountChatScreen extends StatefulWidget {
  const AccountChatScreen({Key? key}) : super(key: key);

  @override
  State<AccountChatScreen> createState() => _AccountChatScreenState();
}

class _AccountChatScreenState extends State<AccountChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeProvider.appColor,
        iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inbox'.tr,
          style: ThemeProvider.titleStyle,
        ),
      ),
      body: const InboxContent(),
    );
  }
}
