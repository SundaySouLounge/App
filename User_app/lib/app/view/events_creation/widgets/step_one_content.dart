import 'dart:collection';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/util/table_calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';

//STEP ONE
class StepOneContent extends StatefulWidget {
  const StepOneContent({super.key});

  @override
  State<StepOneContent> createState() => _StepOneContentState();
}

class _StepOneContentState extends State<StepOneContent> {
  // List<List<Object>> startTimeList = [
  //   ["8am to 9am", 8],
  //   ["9am to 10am", 9],
  //   ["10am to 11am", 10],
  //   ["11am to 12pm", 11],
  //   ["12pm to 1pm", 12],
  //   ["1pm to 2pm", 13],
  //   ["2pm to 3pm", 14],
  //   ["3pm to 4pm", 15],
  //   ["4pm to 5pm", 16],
  //   ["5pm to 6pm", 17],
  //   ["6pm to 7pm", 18],
  //   ["7pm to 8pm", 19],
  // ];
  List<String> availableTimeList = [];
  List<String> startTimeList = [
    // "8am to 9am",
    // "9am to 10am",
    // "10am to 11am",
    // "11am to 12pm",
    // "12pm to 1pm",
    // "1pm to 2pm",
    // "2pm to 3pm",
    // "3pm to 4pm",
    // "4pm to 5pm",
    // "5pm to 6pm",
    // "6pm to 7pm",
    // "7pm to 8pm",
    "11am",
    "11:15am",
    "11:30am",
    "11:45am",
    "12pm",
    "12:15pm",
    "12:30pm",
    "12:45pm",
    "1pm",
    "1:15pm",
    "1:30pm",
    "1:45pm",
    "2pm",
    "2:15pm",
    "2:30pm",
    "2:45pm",
    "3pm",
    "3:15pm",
    "3:30pm",
    "3:45pm",
    "4pm",
    "4:15pm",
    "4:30pm",
    "4:45pm",
    "5pm",
    "5:15pm",
    "5:30pm",
    "5:45pm",
    "6pm",
    "6:15pm",
    "6:30pm",
    "6:45pm",
    "7pm",
    "7:15pm",
    "7:30pm",
    "7:45pm",
    "8pm",
    "8:15pm",
    "8:30pm",
    "8:45pm",
    "9pm",
    "9:15pm",
    "9:30pm",
    "9:45pm",
    "10pm",
    "10:15pm",
    "10:30pm",
    "10:45pm",
    "11pm",
    "11:15pm",
    "11:30pm",
    "11:45pm",
  ];
  late final ValueNotifier<List<Event>> _selectedEvents;
  final List<DateTime> unavailableDates = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? timeSelection;
  LinkedHashMap<DateTime, List<Event>>? eventsList;
  final controller = Get.find<EventsCreationController>();
  Map<DateTime, List<Event>> kEventSource = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    // for (final item in controller.savedEventContractsList) {
    //   if (item.date != null &&
    //       kEventSource.keys.any((date) =>
    //           DateTime(date.year, date.month, date.day) ==
    //           DateTime(item.date!.year, item.date!.month, item.date!.day))) {
    //     kEventSource[item.date]!.add(Event(item.time!, item.date!));
    //   } else {
    //     kEventSource[item.date!] = [Event(item.time!, item.date!)];
    //   }
    // }

    for (final item in controller.savedEventContractsList) {
      if (item.date != null) {
        final itemDate =
            DateTime(item.date!.year, item.date!.month, item.date!.day);

        if (kEventSource.keys.any(
            (date) => DateTime(date.year, date.month, date.day) == itemDate)) {
          kEventSource[itemDate]!.add(Event(item.time!, item.date!, item.venueName!));
        } else {
          kEventSource[itemDate] = [Event(item.time!, item.date!, item.venueName!)];
        }
      }
    }
    // availableTimeList = startTimeList.where((startTime) {
    //   // Extract the start time from the string
    //   final startHour = convertTimeToHour(startTime.split(' ')[0]);

    //   // Get the end hour based on the start hour and duration
    //   final endHour = startHour + 1;

    //   // Check if any event overlaps with the time range
    //   final eventExists = controller.savedEventContractsList
    //       // .expand((eventMap) => eventMap[DateTime.now()] ?? [])
    //       .any((event) {
    //     final eventStartHour = int.parse(DateFormat.H().format(event.date!));
    //         // int.parse(event.date.toString().split(' ')[1].split(':')[0]);
    //     // final eventDuration =
    //     //     int.parse(event.time!.split(' ')[0].split('x')[0]);
    //     final eventDuration = int.parse(event.time!.split(' ')[0]);
    //     final eventEndHour = eventStartHour + eventDuration;
    //     return (startHour >= eventStartHour && startHour < eventEndHour) ||
    //         (endHour > eventStartHour && endHour <= eventEndHour);
    //   });
    //   return !eventExists;
    // }).toList();

    // if (controller.selectedDay != null) {
    //   kEventSource.addAll({
    //     controller.selectedDay!: [
    //       "Data Selection (${DateFormat.yMMMMEEEEd().format(controller.selectedDay!)} ${controller.selectedTime})"
    //     ],
    //   });
    // }

    eventsList = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);

    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation
    return eventsList![day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Calendar Widget
            Text(
              "Select Date ".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeProvider.appColor,
              ),
            ),

            Container(
              margin: const EdgeInsets.all(10), // Padding of 10
              decoration: BoxDecoration(
                color: Colors.grey[800], // Dark gray background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(DateTime.now().year,
                    DateTime.now().month - 2, 1), // Adjusted firstDay
                lastDay: DateTime(DateTime.now().year, DateTime.now().month + 9,
                    31), // Adjusted lastDay
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  // CalendarFormat.week: 'Week',
                },
                headerStyle: const HeaderStyle(
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white, // Set the color for the left arrow
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white, // Set the color for the right arrow
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                calendarStyle: const CalendarStyle(
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // White background for days' numbers
                  ),
                  canMarkersOverflow: false,
                  markersAnchor: -0.3,
                ),
                rowHeight: 60,
                enabledDayPredicate: (day) {
                  if (controller.unavailableDatesList.any(
                      (unavailableDate) => isSameDay(unavailableDate, day))) {
                    return false;
                  }
                  return true;
                },
                calendarBuilders: CalendarBuilders(
                  // defaultBuilder:
                  defaultBuilder: (context, day, focusedDay) {
                    final text = '${day.day}';
                    if (eventsList != null &&
                        eventsList![day] != null &&
                        eventsList![day]!.isNotEmpty) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.all(6.0),
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeProvider.orangeColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(text,
                            style: const TextStyle(
                                color: ThemeProvider.whiteColor)),
                      );
                    }
                    return Center(
                      child: Text(
                        text,
                        style: const TextStyle(color: Color(0xFFBFBFBF)),
                      ),
                    );
                  },
                  prioritizedBuilder: (context, day, focusedDay) {
                    final text = '${day.day}';
                    if (controller.unavailableDatesList.any(
                        (unavailableDate) => isSameDay(unavailableDate, day))) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.all(6.0),
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeProvider.redColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(text,
                            style: const TextStyle(
                                color: ThemeProvider.whiteColor)),
                      );
                    }
                  },
                  singleMarkerBuilder: (context, date, event) {
                    return Container(
                      height: 8.0,
                      width: 8.0,
                      margin: const EdgeInsets.all(0.5),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        // provide your own condition here
                        // color: (event as String).contains('B10')
                        //     ? Colors.red
                        //     : Colors.black,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  // markerBuilder: (context, day, events) {
                  // },
                  // dowBuilder: (context, day) {
                  //   if (day.weekday == DateTime.sunday) {
                  //     final text = DateFormat.E().format(day);

                  //     return Center(
                  //       child: Text(
                  //         text,
                  //         style: TextStyle(color: Colors.red),
                  //       ),
                  //     );
                  //   }
                  //   return null;
                  // },
                ),
                rangeSelectionMode: RangeSelectionMode.toggledOff,
                onFormatChanged: (format) {},
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                onDaySelected: _onDaySelected,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Choose Start Time ".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeProvider.appColor,
              ),
            ),
            ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                availableTimeList = startTimeList.where((startTime) {
                  final startHour = convertTimeToHour(startTime.split(' ')[0]);
                  final endHour = startHour;
                  final eventExists = value.any((event) {
                    final eventStartHour =
                        int.parse(DateFormat.H().format(event.time));
                    final eventDuration = int.parse(event.title.split(' ')[0]);
                    final eventEndHour = eventStartHour + eventDuration;
                    return (startHour >= eventStartHour &&
                            startHour < eventEndHour) ||
                        (endHour > eventStartHour && endHour <= eventEndHour);
                  });
                  return !eventExists;
                }).toList();

                return Column(
                  children: [
                    SizedBox(
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      height: 820,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          mainAxisExtent: 50,
                          childAspectRatio: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 7,
                        ),
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                        scrollDirection: Axis.vertical,
                        itemCount: startTimeList.length,
                        itemBuilder: (_, index) {
                          final itemStartTimeHr =
                              convertTimeToHour(startTimeList[index]);
                          final itemStartTimeMin =
                              convertTimeToMin(startTimeList[index]);
                          return GestureDetector(
                            onTap: () {
                              if (!(availableTimeList
                                      .contains(startTimeList[index])) ||
                                  _selectedDay?.hour == itemStartTimeHr &&
                                      _selectedDay?.minute ==
                                          itemStartTimeMin) {
                              } else {
                                setState(() {
                                  timeSelection =
                                      DateFormat("hh:mm").format(_selectedDay!);
                                  _selectedDay = _selectedDay!.copyWith(
                                      hour: itemStartTimeHr,
                                      minute: itemStartTimeMin);
                                });
                                print(startTimeList[index]);
                                print("Hour: ${startTimeList[index]}");
                                print("Minute: ${_selectedDay?.hour}");
                                print(itemStartTimeHr);
                              }
                            },
                            child: Container(
                              // margin: EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: (!(availableTimeList.contains(
                                                startTimeList[index])) ||
                                            _selectedDay?.hour ==
                                                    itemStartTimeHr &&
                                                _selectedDay?.minute ==
                                                    itemStartTimeMin)
                                        ? Colors.red
                                        : Colors.green),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  // "Data Selection (Hours from 8am to 8am of the next day)",
                                  startTimeList[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        // ),
                        // children: List.generate(
                        //   value.length,
                        //   (index) {
                        //     return Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 10, horizontal: 10),
                        //       child: Container(
                        //         // margin: EdgeInsets.symmetric(vertical: 10),
                        //         padding: const EdgeInsets.symmetric(
                        //             vertical: 10, horizontal: 10),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.grey),
                        //           borderRadius: BorderRadius.circular(10.0),
                        //         ),
                        //         child: Center(
                        //           child: Text(
                        //             // "Data Selection (Hours from 8am to 8am of the next day)",
                        //             value[index],
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ),
                    ),
                    // 4. Next Button (to move to the next step)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: _selectedDay != null &&
                                // eventsList![_selectedDay] == null &&
                                23 >= _selectedDay!.hour &&
                                _selectedDay!.hour >= 8
                            ? () {
                                controller.selectdate(_selectedDay!);
                                controller.selectStep(2);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeProvider.appColor,
                          foregroundColor: ThemeProvider.whiteColor,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded button
                          ),
                          elevation: 5, // Shadow
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Next".tr),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
