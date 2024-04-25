import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ultimate_band_owner_flutter/app/controller/appointment_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/view/notification_screen/notification_screen.dart';
import './widgets/new_event_request_dialog.dart';
import './widgets/new_event_request_pending.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<AppointmentController>();

    controller.getSavedEventContractsByUid();
  }

  @override
  Widget build(BuildContext context) {
    final item = Get.put(NotificationController(parser: Get.find()));
    return GetBuilder<AppointmentController>(
      builder: (value) {
        return Scaffold(
            backgroundColor: ThemeProvider.blackColor,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ThemeProvider.appColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
                title: Text(
                  'Contracts History'.tr,
                  style: ThemeProvider.titleStyle,
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  // Positioned(

                  //           child: GetBuilder<NotificationController>(
                  //             builder: (controller) {
                  //               final notificationCount = controller.notificationCount;

                  //               if (notificationCount > 0) {
                  //                 return Container(
                  //                   width: 14, // Adjust the width as needed
                  //                   height: 14, // Adjust the height as needed
                  //                   decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     color: Colors.red,
                  //                   ),
                  //                   child: Center(
                  //                     child: Text(
                  //                       '$notificationCount',
                  //                       style: TextStyle(
                  //                         color: Colors.white,
                  //                         fontSize: 12,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               } else {
                  //                 return SizedBox(); // This will hide the red dot when notificationCount is 0
                  //               }
                  //             },
                  //           ),
                  //         ),
                ],
                bottom: TabBar(
                  controller: value.tabController,
                  unselectedLabelColor: ThemeProvider.blackColor,
                  labelColor: ThemeProvider.whiteColor,
                  indicatorColor: ThemeProvider.whiteColor,
                  labelStyle: const TextStyle(
                      fontFamily: 'medium',
                      fontSize: 16,
                      color: ThemeProvider.whiteColor),
                  unselectedLabelStyle: const TextStyle(
                      fontFamily: 'medium',
                      fontSize: 16,
                      color: ThemeProvider.whiteColor),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.all(8),
                  tabs: [
                    Text(
                      'Upcoming'.tr,
                      style: const TextStyle(color: ThemeProvider.whiteColor),
                    ),
                    Text(
                      'Pending'.tr,
                      style: const TextStyle(color: ThemeProvider.whiteColor),
                    ),
                    Text(
                      'Archive'.tr,
                      style: const TextStyle(color: ThemeProvider.whiteColor),
                    ),
                  ],
                )),
            body: value.apiCalled == false
                ? SkeletonListView()
                : TabBarView(
                    controller: value.tabController,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: value.appointmentList.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                      value.appointmentList.length, (index) {
                                    if (value.appointmentList[index].status ==
                                        "Accepted") {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.whiteColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: ThemeProvider.blackColor
                                                    .withOpacity(0.2),
                                                offset: const Offset(0, 1),
                                                blurRadius: 3),
                                          ], // Set the border radius to make it rounded
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Get.dialog(
                                                NewEventRequestDialogPending(
                                                    eventContractData:
                                                        value.appointmentList[
                                                            index]));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      value
                                                          .appointmentList[
                                                              index]
                                                          .nameVenue
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        //fontFamily: "bold",
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "£ ${value.appointmentList[index].fee.toString()}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      //fontFamily: "bold",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),

                                              Row(
                                                children: [
                                                  Text(
                                                    value.appointmentList[index]
                                                                .date !=
                                                            null
                                                        ? DateFormat(
                                                                'MMMM dd, yyyy')
                                                            .format(value
                                                                .appointmentList[
                                                                    index]
                                                                .date!)
                                                        : '',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),

                                              const SizedBox(height: 10),

                                              // 2.6 Status
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "STATUS: ".tr,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            // fontFamily: "bold",
                                                          ),
                                                        ),
                                                        Text(
                                                          value
                                                              .appointmentList[
                                                                  index]
                                                              .status
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 18,
                                                            // fontFamily: "bold",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Get.dialog(
                                                          NewEventRequestDialogPending(
                                                              eventContractData:
                                                                  value.appointmentList[
                                                                      index]));
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: ThemeProvider
                                                          .appColor, // Set the background color
                                                    ),
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        // fontFamily: "bold",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else
                                      return Container();
                                  }),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/no-data.png',
                                          width: 60, height: 60),
                                      const SizedBox(height: 30),
                                      Text(
                                        'No New Contracts Found!'.tr,
                                        style: const TextStyle(
                                            fontFamily: 'bold',
                                            color: ThemeProvider.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: value.appointmentList.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                      List.generate(
                                              value.appointmentList.length,
                                              (index) {
                                    final reversedIndex =
                                        value.appointmentList.length -
                                            1 -
                                            index; // Calculate reversed index
                                    if (value.appointmentList[reversedIndex]
                                            .status ==
                                        "pending") {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.whiteColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ThemeProvider.blackColor
                                                  .withOpacity(0.2),
                                              offset: const Offset(0, 1),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Get.dialog(
                                                NewEventRequestDialogPending(
                                                    eventContractData:
                                                        value.appointmentList[
                                                            reversedIndex]));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      value
                                                          .appointmentList[
                                                              reversedIndex]
                                                          .nameVenue
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        //  fontFamily: "bold",
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "£ ${value.appointmentList[reversedIndex].fee.toString()}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      // fontFamily: "bold",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Text(
                                                    value
                                                                .appointmentList[
                                                                    reversedIndex]
                                                                .date !=
                                                            null
                                                        ? DateFormat(
                                                                'MMMM dd, yyyy')
                                                            .format(value
                                                                .appointmentList[
                                                                    reversedIndex]
                                                                .date!)
                                                        : '',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "STATUS: ".tr,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            //  fontFamily: "bold",
                                                          ),
                                                        ),
                                                        Text(
                                                          value
                                                              .appointmentList[
                                                                  reversedIndex]
                                                              .status
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 18,
                                                            // fontFamily: "bold",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Get.dialog(NewEventRequestDialogPending(
                                                          eventContractData: value
                                                                  .appointmentList[
                                                              reversedIndex]));
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: ThemeProvider
                                                          .appColor, // Set the background color
                                                    ),
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        //  fontFamily: "bold",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else
                                      return Container();
                                  })
                                          .toList()
                                          .reversed
                                          .toList(), // Reverse the list order
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/no-data.png',
                                          width: 60, height: 60),
                                      const SizedBox(height: 30),
                                      Text(
                                        'No New Contracts Found!'.tr,
                                        style: const TextStyle(
                                            fontFamily: 'bold',
                                            color: ThemeProvider.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: value.appointmentListOld.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                    value.appointmentListOld.length,
                                    (index) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: ThemeProvider.whiteColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: ThemeProvider.blackColor
                                                  .withOpacity(0.2),
                                              offset: const Offset(0, 1),
                                              blurRadius: 3),
                                        ], // Set the border radius to make it rounded
                                      ),
                                      child: InkWell(
                                        // onTap: () async {
                                        //   Get.dialog(NewEventRequestDialog(
                                        //       eventContractData: value
                                        //           .appointmentListOld[index]));
                                        // },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    value
                                                        .appointmentListOld[
                                                            index]
                                                        .nameVenue
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      //  fontFamily: "bold",
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "£ ${value.appointmentListOld[index].fee.toString()}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    // fontFamily: "bold",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),

                                            Row(
                                              children: [
                                                Text(
                                                  value
                                                              .appointmentListOld[
                                                                  index]
                                                              .date !=
                                                          null
                                                      ? DateFormat(
                                                              'MMMM dd, yyyy')
                                                          .format(value
                                                              .appointmentListOld[
                                                                  index]
                                                              .date!)
                                                      : '',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),

                                            const SizedBox(height: 10),

                                            // 2.6 Status
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "STATUS: ".tr,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          // fontFamily: "bold",
                                                        ),
                                                      ),
                                                      Text(
                                                        value
                                                            .appointmentListOld[
                                                                index]
                                                            .status
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                          //  fontFamily: "bold",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // ElevatedButton(
                                                //   onPressed: () async {
                                                //     Get.dialog(NewEventRequestDialog(
                                                //   eventContractData: value
                                                //       .appointmentListOld[index]));
                                                //    },
                                                //   style: ElevatedButton.styleFrom(
                                                //     primary: ThemeProvider.appColor, // Set the background color
                                                //   ),
                                                //   child: Text(
                                                //     "View",
                                                //     style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontSize: 18,
                                                //       fontFamily: "bold",
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/no-data.png',
                                          width: 60, height: 60),
                                      const SizedBox(height: 30),
                                      Text(
                                        'No Past Contracts Found!'.tr,
                                        style: const TextStyle(
                                            fontFamily: 'bold',
                                            color: ThemeProvider.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ));
      },
    );
  }
}
