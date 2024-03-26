import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/backend/models/event_contract_model.dart';
import 'package:app_user/app/controller/booking_controller.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import './nego_dialog.dart';

class NewEventRequestDialog extends StatelessWidget {
  final EventContractModel eventContractData;
  const NewEventRequestDialog({super.key, required this.eventContractData});

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      builder: (controller) {

        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width *
                .85, // Adjust the width as needed
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the popup
              borderRadius: BorderRadius.circular(10),
              // image: DecorationImage(
              //   image: AssetImage('your_image_path.png'), // Background image
              //   fit: BoxFit.cover,
              // ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.event, // Icon at the center
                  size: 34,
                  color: Colors.black, // Icon color
                ),
                const Text(
                  "Request Again", // Title at the center
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.label, color: Colors.black, size: 16), // Icon
                    SizedBox(width: 10),
                    Text("Title: New request",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                14)), // Text with black color and smaller size
                  ],
                ),
                // 2.1 Date and Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Date and Time: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      eventContractData!.date != null
                          ? DateFormat.yMd().format(eventContractData!.date!)
                          : '',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),

                // 2.2 Minutes
                Row(
                  children: [
                    const Icon(Icons.timer,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Minutes: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      eventContractData!.time.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),

                // 2.3 Band Size
                Row(
                  children: [
                    const Icon(Icons.people,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Band Size: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      eventContractData!.bandSize.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),

                // 2.4 Fees
                Row(
                  children: [
                    const Icon(Icons.attach_money,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Fees: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      eventContractData!.fee.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),

                // 2.5 Info
                Row(
                  children: [
                    const Icon(Icons.description,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Info: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .85 - 100,
                      child: Text(
                        eventContractData.extraField.toString(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                // 2.6 Status
                Row(
                  children: [
                    const Icon(Icons.description,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Status: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      eventContractData!.status.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Add space between buttons
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).pop(); // Close the popup
                    //     controller.onChat(eventContractData);
                    //   },
                    //   child: Text("Acc"),
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(20), // Rounded buttons
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the popup
                        //Get.dialog(NegoDialog(eventContractData: eventContractData));
                        //TO-DO: This was added, replace with the logic of changing the date and the docid
                        eventContractData.date = await _selectDate(context);

                        controller.onRebook(eventContractData);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded buttons
                        ),
                      ),
                      child: const Text("Re-Book "),
                    ),
                    // ElevatedButton(
                    //   onPressed: eventContractData!.status != 'Declined'
                    //       ? () {
                    //           Navigator.of(context).pop();
                    //           controller.updateEventContractStatus(
                    //               eventContractData, 'Declined', 4);
                    //           // controller.updateEventContractStatusById('accepted');
                    //           // Perform your desired action
                    //           // For example, you can navigate to another screen.
                    //           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnotherScreen()));
                    //         }
                    //       : null,
                    //   child: Text("Decline"),
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(20), // Rounded buttons
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
            context: context,
            initialDate: next(DateTime.monday),
            firstDate: DateTime.now(),
            lastDate: DateTime(2101)) ??
        DateTime.now();
    return DateTime(picked.year, picked.month, picked.day);
  }

  DateTime next(int day) {
    var date = DateTime.now();
    return date.add(
      Duration(
        days: (day - date.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}
