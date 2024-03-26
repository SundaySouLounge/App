import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/view/notification_screen/widgets/date_change_dialog.dart';
import './new_event_request_dialog.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  get eventContractData => null;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) => controller.apiCalled == false
          ? SkeletonListView(
              itemCount: 5,
            )
          : controller.notificationList.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          "assets/images/no-data.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      controller.notificationList.length,
                      (index) {
                        //   ListView.builder(
                        // itemCount: controller.notificationList.length,
                        // itemBuilder: (BuildContext context, int index) {
                          final reversedIndex =
          controller.notificationList.length - 1 - index;
                        final item = controller.notificationList[reversedIndex];
                        print("ID------: ${item.id}, --------: ${item.title}");
                        return GestureDetector(
                          onTap: () async {
                            if (item.title != null &&
                                item.title!.contains('has requested a Date Change') && controller.eventContractData != null) {
                              //Get.dialog(DateChangeDialog(eventContractData: eventContractData));
                              Get.dialog(DateChangeDialog(
                                  eventContractData:
                                      controller.eventContractData!));
                            } else if (item.data != null &&
                                item.data != "null") {
                              Get.dialog(
                                  SimpleDialog(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          const CircularProgressIndicator(
                                            color: ThemeProvider.appColor,
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          SizedBox(
                                              child: Text(
                                            "Fetching contract data"
                                                .tr,
                                            style: const TextStyle(
                                                fontFamily: 'bold'),
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                  barrierDismissible: true);
                              final eventContractData = await controller
                                  .getEventContractById(item.data!);
                              Navigator.of(context).pop(true);
                              if (eventContractData != null) {
                                Get.dialog(NewEventRequestDialog(
                                    notificationData: item));
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: ThemeProvider.whiteColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      ThemeProvider.blackColor.withOpacity(0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                            item.title.toString()),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        getStatusText(item.title.toString()),
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller
                                            .deletePushNotification(item.id!);
                                      },
                                      icon: Icon(Icons.cancel),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title.toString(),
                                        style: const TextStyle(
                                          color: ThemeProvider.appColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item.message.toString(),
                                        style: const TextStyle(
                                          color: ThemeProvider.appColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}

Color getStatusColor(String title) {
  final trimmedTitle = title.trim().toLowerCase();
  print('Trimmed Title: $trimmedTitle');

  if (trimmedTitle.contains('pending')) {
    return Colors.yellow;
  } else if (trimmedTitle.contains('you accepted date change from')) {
    return Colors.green;
  }else if (trimmedTitle.contains('accepted')) {
    return Colors.black;
  } else if (trimmedTitle.contains('declined')) {
    return Colors.black;
  } else if (trimmedTitle.contains('you declined a contract from')) {
    return Colors.black;
  } else if (trimmedTitle.contains('you negotiated a contract')) {
    return Colors.green;
  } else if (trimmedTitle.contains('2023')) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}
String getStatusText(String title) {
  String trimmedTitle = title.toLowerCase().trim();

  if (trimmedTitle.contains('accepted your contract')) {
    return 'Accepted';
  } else if (trimmedTitle.contains('declined your contract')) {
    return 'Declined';
  } else if (trimmedTitle.contains('you declined a contract from')) {
    return 'Declined';
  }else if (trimmedTitle.contains('you have accepted a contract')) {
    return 'Accepted';
  }else if (trimmedTitle.contains('new event request')) {
    return 'Need your attention!';
  } else if (trimmedTitle.contains('negotiated a contract')) {
    return 'Waiting For Venue';
  } else if (trimmedTitle.contains('you accepted date change from')) {
    return 'Waiting For Venue';
  }else {
    return 'Need your attention! ';
  }
}

