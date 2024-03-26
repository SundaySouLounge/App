import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/controller/calendar_controller.dart';
import 'package:ultimate_band_owner_flutter/app/helper/router.dart';
import 'package:ultimate_band_owner_flutter/app/util/table_calendar_utils.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/env.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final List<DateTime> unavailableDates = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<Event>>? eventsList;
  Map<DateTime, List<Event>> kEventSource = {};
  DateTime selectedUnavailableDate = DateTime.now();
  

  @override
  void initState() {
    super.initState();
    final controller = Get.find<CalendarsController>();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.getSavedEventContractsByUid();
      controller.getUnavailableDatesByUid();

      for (final item in controller.savedEventContractsList) {
        if (item.date != null) {
          final itemDate =
              DateTime(item.date!.year, item.date!.month, item.date!.day);

          if (kEventSource.keys.any((date) =>
              DateTime(date.year, date.month, date.day) == itemDate)) {
            kEventSource[itemDate]!.add(Event(item.time!, item.date!));
          } else {
            kEventSource[itemDate] = [Event(item.time!, item.date!)];
          }
        }
      }
      eventsList = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(kEventSource);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  List<Event> _getEventsForDay(DateTime day) {
    if (eventsList != null && eventsList![day] != null) {
      return eventsList![day] ?? [];
    }
    return [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  if (!isSameDay(_selectedDay, selectedDay)) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(selectedDay);

    // Log selected date to console
    print('Selected Date: $_selectedDay');
  }
}


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.blackColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            toolbarHeight: 50,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            automaticallyImplyLeading: false,
            title: Text(
              'Calendar'.tr,
              style: const TextStyle(
                  fontFamily: 'bold',
                  fontSize: 14,
                  color: ThemeProvider.whiteColor),
            ),
            bottom: value.apiCalled == true
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(350),
                    child: Container(
                      color: ThemeProvider.whiteColor,
                      child: TableCalendar(
                        focusedDay: _focusedDay,
                        firstDay: DateTime(DateTime.now().year,
                            DateTime.now().month - 2, 1), // Adjusted firstDay
                        lastDay: DateTime(DateTime.now().year,
                            DateTime.now().month + 12, 31), // Adjusted lastDay
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        eventLoader: _getEventsForDay,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.week: 'Week',
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonTextStyle: TextStyle(color: Colors.black),
                          titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(color: Colors.black),
                          weekendStyle: TextStyle(color: Colors.red),
                        ),
                        calendarStyle: const CalendarStyle(
                          // defaultDecoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: Colors
                          //       .white, // White background for days' numbers
                          // ),
                          defaultTextStyle: TextStyle(color: Colors.black),
                          canMarkersOverflow: false,
                          markersAnchor: -0.3,
                          markerDecoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        rowHeight: 50,
                        enabledDayPredicate: (day) {
                          if (value.unavailableDatesList.any(
                              (unavailableDate) =>
                                  isSameDay(unavailableDate, day))) {
                            return true;
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
                        }, prioritizedBuilder: (context, day, focusedDay) {
                          final text = '${day.day}';
                          if (value.unavailableDatesList.any(
                              (unavailableDate) =>
                                  isSameDay(unavailableDate, day))) {
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
                        }
                         
                            ),
                        rangeSelectionMode: RangeSelectionMode.toggledOff,
                        onFormatChanged: (format) {},
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        onDaySelected: _onDaySelected,
                      ),
                    ),
                  )
                : null,
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ThemeProvider.whiteColor,
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedUnavailableDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2029),
    helpText: 'Select unavailable date',
    cancelText: 'Not now',
    confirmText: 'Select',
  );

  if (picked != null) {
  String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  DateTime parsedDate = DateTime.parse(formattedDate);
  await value.updateUnavailableDatesByUid(parsedDate);
  setState(() {
    selectedUnavailableDate = picked;
  });
}
},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Set unavailable Dates".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                       //   Get.toNamed(AppRouter.getNotificationRoutes());
                       _openCustomDialog();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 48),
                        ),
                        child: Text(
                          "Calendar List View".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
         
        );
      },
    );
  }
 
void _openCustomDialog() {
  CalendarsController controller = Get.find<CalendarsController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(events: controller.savedEventContractsList);
    },
  );
}

}

class CustomDialog extends StatefulWidget {
  final List<EventContractModel> events;

  CustomDialog({required this.events});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(
                'Calendar List',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            _buildMonthNavigation(),
           // _buildMonthName(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Events:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildEventsList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigation() {
  if (widget.events.isNotEmpty) {
    String monthName =
        DateFormat('MMMM').format(widget.events[_currentPage].date!);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          icon: Icon(Icons.arrow_left),
          color: Colors.white,
        ),
        Text(
          monthName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            if (_currentPage < widget.events.length - 1) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          icon: Icon(Icons.arrow_right),
          color: Colors.white,
        ),
      ],
    );
  } else {
    return Container(); // You can customize this part based on your needs
  }
}


  // Widget _buildMonthName() {
  //   if (widget.events.isNotEmpty) {
  //     String monthName =
  //         DateFormat('MMMM').format(widget.events[_currentPage].date!);
  //     return Container(
  //       padding: EdgeInsets.symmetric(vertical: 10),
  //       child: Text(
  //         monthName,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 20,
  //           color: Colors.white,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Container(); // You can customize this part based on your needs
  //   }
  // }

  Widget _buildEventsList(BuildContext context) {
    if (widget.events.isEmpty) {
      return Text('No events available');
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.events.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildMonthView(widget.events[index]);
        },
      ),
    );
  }

  Widget _buildMonthView(EventContractModel event) {
    // Logic to filter events by month
    List<EventContractModel> eventsInMonth = widget.events
        .where((e) =>
            e.date?.month == event.date?.month &&
            e.date?.year == event.date?.year)
        .toList();

    return ListView.builder(
      itemCount: eventsInMonth.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            // Divider above each event
            Divider(),
            _buildEventRow(eventsInMonth[index]),
            // Divider below each event except the last one
            if (index < eventsInMonth.length - 1) Divider(),
          ],
        );
      },
    );
  }

  Widget _buildEventRow(EventContractModel event) {
    return Column(
      children: [
        // Divider above each event
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Venue Name and Event Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Venue Name: ${event.nameVenue}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                SizedBox(height: 20),
                _buildDateText(event.date),
              ],
            ),
            // Time and Action Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Time: ${DateFormat('HH:mm').format(event.date!)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                SizedBox(height: 1),
                _buildActionButton('View'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateText(DateTime? date) {
    if (date != null) {
      return Text(
        'Date: ${DateFormat('MMMM d, y').format(date)}',
        style: TextStyle(fontSize: 14, color: Colors.white),
      );
    } else {
      return Text('No date available',
          style: TextStyle(fontSize: 14, color: Colors.white));
    }
  }

  Widget _buildActionButton(String label) {
    // Replace this with your actual button implementation
    return ElevatedButton(
      onPressed: () {
        // Handle button action
      },
      child: Text(label),
    );
  }
}
