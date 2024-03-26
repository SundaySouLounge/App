// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

int convertTimeToHour(String timeString) {
  final parts =
      timeString.split(RegExp('[ap]m')); // Split the string at 'am' or 'pm'
  final timeComponents =
      parts[0].trim().split(':'); // Split the hour and minute parts

  int hour = int.parse(
      timeComponents[0]); // Extract the hour part and convert it to an integer

  if (timeString.toLowerCase().contains('pm') && hour != 12) {
    // Convert to 24-hour format for 'pm' times (except 12pm)
    hour += 12;
  } else if (timeString.toLowerCase().contains('am') && hour == 12) {
    // Convert 12am to 0 (midnight)
    hour = 0;
  }

  return hour;
}

int convertTimeToMin(String timeString) {
  final parts =
      timeString.split(RegExp('[ap]m')); // Split the string at 'am' or 'pm'
  final timeComponents =
      parts[0].trim().split(':'); // Split the hour and minute parts
  if (timeComponents.length > 1) {
    int min = int.parse(timeComponents[1]);
    // Extract the min part and convert it to an integer
    return min;
  } else {
    return 00;
  }
}

/// Example event class.
class Event {
  final String title;
  final DateTime time;
  final String venueName;

  const Event(this.title, this.time, this.venueName);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1,
        (index) => Event('Event $item | ${index + 1}', DateTime.now(), 'venueOne'))
}..addAll({
    kToday: [
      Event('Today\'s Event 1', DateTime.now(), 'venueOne'),
      Event('Today\'s Event 2', DateTime.now(), 'venueOne'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
