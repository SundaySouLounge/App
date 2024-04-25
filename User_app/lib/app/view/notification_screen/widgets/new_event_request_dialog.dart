import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/backend/models/notification_model.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:app_user/app/view/home.dart';
import 'package:app_user/app/view/notification_screen/widgets/notification_list_widget.dart';
import 'package:app_user/app/util/theme.dart';
import './nego_dialog.dart';

class NewEventRequestDialog extends StatelessWidget {
  final NotificationModel notificationData;
  const NewEventRequestDialog({super.key, required this.notificationData});

  // @override
  // void initState() {
  //   super.initState();

  //   _selectedDay = _focusedDay;
  //   final kEventSource = {
  //     for (final item in controller.savedEventContractsList)
  //       item.date!: [
  //         "Data Selection (${DateFormat.yMMMMEEEEd().format(item.date!)}, ${item.time})"
  //       ]
  //   };
  //   // if (controller.selectedDay != null) {
  //   //   kEventSource.addAll({
  //   //     controller.selectedDay!: [
  //   //       "Data Selection (${DateFormat.yMMMMEEEEd().format(controller.selectedDay!)} ${controller.selectedTime})"
  //   //     ],
  //   //   });
  //   // }

  //   eventsList = LinkedHashMap<DateTime, List<String>>(
  //     equals: isSameDay,
  //     hashCode: getHashCode,
  //   )..addAll(kEventSource);

  //   _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  // }

  void _selectDate(
      BuildContext context, NotificationController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.eventContractData!.date ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2027),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.inputOnly,
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the date and time to create a DateTime object
        DateTime updatedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Call the update method to send the updated date and time to the backend
        bool updateSuccess =
            await controller.updateEventContractDate(updatedDateTime);

        if (updateSuccess) {
          // Send notification upon successful update
          controller.sendNotificationOnUpdate(updatedDateTime);

          // Show success Snackbar
          successToast('Event updated successfully');
        } else {
          // Show error Snackbar
          showToast('Failed to update event');
        }
      }
    }
  }

  void _showConfirmationDialog(BuildContext context,
      NotificationController controller, NotificationModel notificationData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Withdraw Offer"),
          content: const Text(
              "Are you sure you want to withdraw the offer? This action is permanent."),
          actions: [
            TextButton(
              onPressed: () {
                controller.updateEventContractStatus(
                    'Deleted', notificationData.id!);
                controller.onCancelSubmit();
                Navigator.of(context).pop();
                // navigate to'
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeScreen()),
                // );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Perform the action when 'No' is clicked
                Navigator.of(context).pop();
                // Add your logic here for 'No'
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showWithdrawDialog(BuildContext context,
      NotificationController controller, NotificationModel notificationData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Extend Deadline"),
          content:
              const Text("Do you want to extend the deadline for the artist ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Remove this line
                _showExtendDialog(context, controller, notificationData);
                // Add your logic here for 'Yes'
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showConfirmationDialog(context, controller, notificationData);
                // Add your logic here for 'No'
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showExtendDialog(BuildContext context,
      NotificationController controller, NotificationModel notificationData) {
    TextEditingController dateController = TextEditingController();
    DateTime selectedDate = DateTime.now(); // Initial date value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Extend Deadline"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select the new date"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Show date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101), // Adjust the end date as needed
                  );

                  // Update selectedDate if a date is picked
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: const Text('Pick Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String selectedDates = dateController.text;
                print('Selected Date: $selectedDate');
                controller.onWithdrawalSubmit(selectedDates);
                controller.updateEventContractDate(selectedDate);
                Navigator.of(context).pop();
                successToast('Request Sent ');
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        String timeoneString = controller.eventContractData!.date != null
            ? DateFormat('HH:mm').format(controller.eventContractData!.date!)
            : '';
        List<String> names = [
          "Artist",
          "Venue",
          "Artist",
          "Venue",
          "Artist",
          "Venue",
          "Artist",
          "Venue",
          "Artist",
          "Venue",
          "Artist",
          "Venue",
        ];

        double timeone = timeoneString.isNotEmpty
            ? double.parse(timeoneString.split(':')[0]) +
                double.parse(timeoneString.split(':')[1]) / 60
            : 0.0;

// Ensure the resulting time doesn't go below 0:00
        timeone = timeone - 1.00 < 0.0 ? 0.0 : timeone - 1.00;

// Convert the result back to HH:mm format using only floating-point division
        String resultTime =
            '${(timeone.floor()).toString().padLeft(2, '0')}:${((timeone % 1) * 60).toInt().toString().padLeft(2, '0')}';

        return Dialog.fullscreen(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width *
                  .85, // Adjust the width as needed
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 0, 0, 0), // Background color of the popup
                // borderRadius: BorderRadius.circular(10),
                // image: DecorationImage(
                //   image: AssetImage('your_image_path.png'), // Background image
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                      ),
                    ],
                  ),

                  const Text(
                    "Contract", // Title at the center
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       child: Container(
                  //         padding: const EdgeInsets.all(
                  //             8), // Adjust padding as needed
                  //         decoration: BoxDecoration(
                  //           color:
                  //               Colors.grey[800], // Dark gray background color
                  //           borderRadius: BorderRadius.circular(
                  //               10), // Adjust the radius as needed
                  //         ),
                  //         child: const Text(
                  //           "Soulaunge is happy to announce your contract creation, in this section you can see the information about your new booking.",
                  //           style: TextStyle(
                  //               color: Color.fromARGB(255, 255, 255, 255),
                  //               fontSize: 16, // Adjust the font size as needed
                  //               decoration: TextDecoration.none,
                  //               height: 1.5),
                  //         ),
                  //       ),
                  //     ),
                  //     // Add other widgets if needed
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  // 2.0 Venue Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.supervised_user_circle,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Venue", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.eventContractData!.venueName.toString(),
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),
                  // 1.0 Venue Contact
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.contact_page,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Venue Contact", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.eventContractData!.mobile.toString(),
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),
                  // 1.0 Venue Contact
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.edit_road_sharp,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Venue Address", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              controller.eventContractData!.venueAddress
                                  .toString(),
                              style: const TextStyle(
                                color: ThemeProvider.appColor,
                                fontFamily: 'bold',
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                              textAlign:
                                  TextAlign.right, // Align text to the right
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),
                  // 2.1 Date and Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.calendar_today,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Performance Date", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.eventContractData!.date != null
                                ? DateFormat('MMMM d, y')
                                    .format(controller.eventContractData!.date!)
                                : '',
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),
                  // 1.0 Musician Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.contact_page,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Musician", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.eventContractData!.musician.toString(),
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),
                  // 2.2 Minutes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.timer,
                              //   color: Colors.white,
                              //   size: 16,
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Set Time(s)",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${timeoneString}  /",
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            controller.eventContractData!.time.toString(),
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.volume_up,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Sound Check", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            resultTime, // Convert the result back to String for Text widget
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  //   SizedBox(height: 20),
                  //   // 2.3 Band Size
                  //   Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Icon(
                  //               Icons.people,
                  //               color: Colors.white,
                  //               size: 16, // White icon
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text(
                  //               "Event Size Requested", // Add your bigger title here
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 20, // Adjust the font size as needed
                  //                 fontWeight: FontWeight.bold,
                  //                 decoration: TextDecoration.none,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(width: 10),
                  //         Text(
                  //           controller.eventContractData!.bandSize.toString(),
                  //           overflow: TextOverflow.ellipsis,
                  //           style: TextStyle(
                  //             color: ThemeProvider.appColor,
                  //             fontFamily: 'bold',
                  //             fontSize: 14,
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: 10), // Adjust the height as needed
                  //     // Other widgets...
                  //   ],
                  // ),

                  const SizedBox(height: 20),
                  // 2.4 Fees
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.attach_money,
                              //   color: Colors.white,
                              //   size: 16, // White icon
                              // ),
                              SizedBox(width: 10),
                              Text(
                                "Price", // Add your bigger title here
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '£ ${controller.eventContractData!.fee.toString()}',
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Adjust the height as needed
                      // Other widgets...
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2.5 Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(), // Divider on top
                      const Row(
                        children: [
                          // Icon(
                          //   Icons.description,
                          //   color: Colors.white,
                          //   size: 16, // White icon
                          // ),
                          SizedBox(width: 10),
                          Text(
                            "Notes", // Add your bigger title here
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Adjust the height as needed

                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "Info: ".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * .85 - 100,
                            child: Text(
                              controller.eventContractData!.extraField
                                  .toString(),
                              style: const TextStyle(
                                color: ThemeProvider.appColor,
                                fontFamily: 'bold',
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Adjust the height as needed
                      const Divider(), // Divider on bottom
                    ],
                  ),

                  const SizedBox(height: 10),
                  // 2.6 Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          // Icon(
                          //   Icons.policy,
                          //   color: Colors.white,
                          //   size: 16, // White icon
                          // ),
                          SizedBox(width: 10),
                          Text(
                            "Status", // Add your bigger title here
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Adjust the height as needed

                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "Status: ".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            controller.eventContractData!.status.toString(),
                            style: const TextStyle(
                              color: ThemeProvider.appColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      // Icon(
                      //   Icons.history,
                      //   color: Colors.white,
                      //   size: 16, // White icon
                      // ),
                      SizedBox(width: 10),
                      Text(
                        "HISTORY", // Add your bigger title here
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Add here
                  SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 25.0,
                        runSpacing: 50.0,
                        children: controller.eventContractData!.bodys!
                            .split("/n")
                            .map((body) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //   width: 20,
                              //   height: 20,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              const SizedBox(width: 50),
                              Container(
                                constraints: const BoxConstraints(
                                    maxWidth:
                                        200), // Adjust the maxWidth as needed
                                child: Text(
                                  body.trim(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const Row(
                    children: [
                      // Icon(
                      //   Icons.manage_accounts,
                      //   color: Colors.white,
                      //   size: 16, // White icon
                      // ),
                      SizedBox(width: 10),
                      Text(
                        "Manage", // Add your bigger title here
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                        top: 10), // Adjust margins as needed
                    height: 2, // Adjust the height of the line
                    color: Colors.white, // Color of the line
                  ),
                  Visibility(
                    visible: controller.eventContractData!.status != 'Deleted',
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 8, top: 0), // Adjust margins as needed
                            child: ElevatedButton(
                              onPressed: () {
                                _showWithdrawDialog(
                                    context, controller, notificationData);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .red, // Set the background color to red
                                foregroundColor:
                                    Colors.white, // Set the text color to white
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                      fontSize: 10,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 8, top: 0), // Adjust margins as needed
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.onChat();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .white, // Set the background color to white
                                foregroundColor:
                                    Colors.black, // Set the text color to black
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Message',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 0, top: 0), // Adjust margins as needed
                            child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, controller);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .white, // Set the background color to white
                                foregroundColor:
                                    Colors.black, // Set the text color to black
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Change Date',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  Visibility(
                    visible: controller.eventContractData?.status !=
                            'Deleted' &&
                        controller.eventContractData?.suggester ==
                            'owner', // Show the row if status is not 'Deleted'
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            // Icon(
                            //   Icons.toll_outlined,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "ACTIONS", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 8,
                              top: 10), // Adjust margins as needed
                          height: 2, // Adjust the height of the line
                          color: Colors.white, // Color of the line
                        ),
                        Visibility(
                          visible: controller.eventContractData!.status !=
                              'Deleted', // Show the row if status is not 'Deleted'
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: controller.eventContractData!.status ==
                                    'pending',
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    controller.updateEventContractStatus(
                                        'Accepted', notificationData.id!);

                                    controller.onAcceptSubmit();
                                    controller.onChat();
                                  },
                                  child: const Text("Accept",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 14)),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.eventContractData!.status !=
                                        'Deleted' &&
                                    (controller.eventContractData!.status ==
                                            'pending' ||
                                        controller.eventContractData!.status !=
                                            'Accepted'),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.dialog(const NegoDialog());
                                  },
                                  child: const Text("Negotiate",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 14)),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.eventContractData!.status !=
                                    'pending',
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    controller.updateEventContractStatus(
                                        'Declined', notificationData.id!);
                                    controller.onDeclineSubmit();
                                    controller.onChat();
                                  },
                                  child: const Text("Decline",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 14)),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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

  void setState(Null Function() param0) {}
}
