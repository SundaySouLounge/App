// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:app_user/app/util/table_calendar_utils.dart';

class TableEvents extends StatefulWidget {
  const TableEvents({Key? key}) : super(key: key);

  @override
  State<TableEvents> createState() => _TableEventsState();
}

class _TableEventsState extends State<TableEvents> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final List<DateTime> unavailableDates = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  LinkedHashMap<DateTime, List<Event>>? eventsList;
  final controller = Get.put(EventsCreationController(parser: Get.find()));
  Map<DateTime, List<Event>> kEventSource = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEvents());
    final item = Get.put(EventsCreationController(parser: Get.find()));

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
    eventsList = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);
    _updateSelectedEvents();
    print('hellossss $kEventSource');
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _updateSelectedEvents() {
    _selectedEvents.value = _getEvents();
  }

  List<Event> _getEvents() {
    List<Event> allItems = [];
    for (var val in kEventSource.values) {
      allItems.addAll(val);
    }
    return allItems;
  }

  List<Event> _getEventsForDay(DateTime day) {
    ///This is the issue. The way you have the map set up
    ///the dates have to match exactly
    ///rename this at will
    var rawDate = DateTime(day.year, day.month, day.day);
    // Implementation
    // TO-DO
    //there is a problem if i change the correct code
    //this is the correct code return eventsList![day] ?? []; is not working
    // but the print is giving me the correct value kEventSource
    print('hellox ${kEventSource.keys}');
    return kEventSource[rawDate] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    print(start);
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TableCalendar<Event>(
        //   firstDay: kFirstDay,
        //   lastDay: kLastDay,
        //   focusedDay: _focusedDay,
        //   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        //   rangeStartDay: _rangeStart,
        //   rangeEndDay: _rangeEnd,
        //   calendarFormat: _calendarFormat,
        //   rangeSelectionMode: _rangeSelectionMode,
        //   eventLoader: _getEventsForDay,
        //   startingDayOfWeek: StartingDayOfWeek.monday,
        //   calendarStyle: CalendarStyle(
        //     // Use `CalendarStyle` to customize the UI
        //     outsideDaysVisible: false,
        //   ),
        //   onDaySelected: _onDaySelected,
        //   onRangeSelected: _onRangeSelected,
        //   onFormatChanged: (format) {
        //     if (_calendarFormat != format) {
        //       setState(() {
        //         _calendarFormat = format;
        //       });
        //     }
        //   },
        //   onPageChanged: (focusedDay) {
        //     _focusedDay = focusedDay;
        //   },
        // ),
        // const SizedBox(height: 8.0),
        ValueListenableBuilder<List<Event>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          final currentDate = DateTime.now();
          final upcomingEvents = value.where((event) => event.time.isAfter(currentDate)).toList();
          
          // Sort the events based on their time
          upcomingEvents.sort((a, b) => a.time.compareTo(b.time));

          return Column(
            children: upcomingEvents.isNotEmpty
                ? List.generate(
                    upcomingEvents.length,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => print('${upcomingEvents[index]}'),
                          title: Text(
                            '${_formatDate(upcomingEvents[index].time)} - ${upcomingEvents[index].venueName}',
                          ),
                        ),
                      );
                    },
                  )
                : [
                    const Center(
                      child: Text(
                        'No Upcoming Events',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
          );
        },
      ),
    ],
  );
  }

  String _formatDate(DateTime date) {
  // Format pattern: EEE (day of the week), dd (day of the month), MMM (month in text), yyyy (year)
  return DateFormat('EEE, dd MMM yyyy').format(date);
}
}
