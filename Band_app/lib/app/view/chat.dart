import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/chat_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/util/toast.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Show the popup when the widget is first loaded
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // _showPopup(context);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text(
              value.name,
              style: ThemeProvider.titleStyle,
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (String choice) {
                  switch (choice) {
                    case 'Report User':
                      successToast("Your request is submitted we will take action in the next 24 hours.");
                      break;
                    case 'Block Account':
                      value.toggleBlockedStatus();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Report User', 'Block Account'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                  color: ThemeProvider.appColor,
                ))
              : value.isBlocked
                  ? Center(
                      child: TextButton(
                        onPressed: () {
                          value.toggleBlockedStatus();
                        },
                        child: Text('Unlock User'),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: value.scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(value.chatList.length,
                              (index) {
                            return value.chatList[index].senderId.toString() !=
                                    value.uid.toString()
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    width: MediaQuery.of(context).size.width -
                                        120,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    horizontal: 15,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    color: ThemeProvider
                                                        .greyColor.shade300,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(30),
                                                            topRight: Radius
                                                                .circular(30),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    30),
                                                            bottomLeft: Radius
                                                                .circular(30))),
                                                child: Text(
                                                  value.chatList[index]
                                                      .message
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 16),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                120,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 10,
                                                          horizontal: 15,
                                                        ),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: ThemeProvider
                                                              .appColor,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    30),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    30),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          value.chatList[index]
                                                              .message
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: ThemeProvider
                                                                .whiteColor,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                          }))),
          bottomNavigationBar: value.isBlocked
              ? null
              : SingleChildScrollView(
                  reverse: true,
                  padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(25)),
                              color: ThemeProvider.greyColor.shade300,
                            ),
                            child: TextField(
                              controller: value.message,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Message...'.tr),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            value.sendMessage();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                color: ThemeProvider.appColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                )),
                            child: const Icon(
                              Icons.near_me,
                              color: ThemeProvider.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
Widget _buildRowWithIcon(String text, IconData icon) {
  return Row(
    children: [
      Icon(icon, color: Colors.black, size: 16), // Icon
      SizedBox(width: 10),
      Text(text,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14)), // Text with black color and smaller size
    ],
  );
}

Widget _buildCubicDesignTextBox(String text) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300], // Background color
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Text(
      text,
      style: TextStyle(color: Colors.black, fontSize: 14),
    ),
  );
}
