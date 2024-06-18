
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/controller/calendar_controller.dart';

class TableCalendar extends StatefulWidget {
  const TableCalendar({Key? key}) : super(key: key);

  @override
  State<TableCalendar> createState() => _TableCalendarState();
}

class _TableCalendarState extends State<TableCalendar> {
    final CalendarsController calendarsController = Get.find<CalendarsController>();

  List<EventContractModel> events = []; // Initialize this list with your events

 @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          FutureBuilder(
            future: calendarsController.getSavedEventContractsByUid(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CustomEventList(events: calendarsController.savedEventContractsList);
              } else {
                return CircularProgressIndicator(); // or any other loading indicator
              }
            },
          ),
        ],
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  final List<EventContractModel> events;

  CalendarScreen({required this.events});

  @override
  Widget build(BuildContext context) {
    print("Number of events: ${events.length}");
    return Column(
      children: [
        // Your existing Calendar content goes here

        // Include the CustomEventList directly
        CustomEventList(events: events),
      ],
    );
  }
}

class CustomEventList extends StatelessWidget {
  final List<EventContractModel> events;

  CustomEventList({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        SizedBox(height: 8),
        _buildEventsList(context),
      ],
    );
  }

  Widget _buildEventsList(BuildContext context) {
      print("Number of events: ${events.length}");

    if (events.isEmpty) {
      return Text('No events available');
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return _buildEventRow(events[index]);
        },
      ),
    );
  }

 Widget _buildEventRow(EventContractModel event) {
  final currentDate = DateTime.now();
  if(event.status == 'Declined' || event.status == 'Deleted') { return Container(); }
  // Check if the event date is after today's date
  if (event.date != null && event.date!.isBefore(currentDate)) {
    // If the event date is older than today, return an empty container
    return Container();
  }
  // If the event date is today or in the future, build the event row
  return Column(
    children: [
      // Padding for separation
      SizedBox(height: 8),
      // Container with rounded borders
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date, Time, and Venue Name
            Text(
              '${DateFormat('EEE, d MMM y').format(event.date!)}',
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,),
            ),
            // Venue Name
            Text(
              ' ${event.nameVenue}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            // Action Button
            // _buildActionButton('View'),
          ],
        ),
      ),
    ],
  );
}


 Widget _buildDateText(DateTime? date) {
  if (date != null) {
    return Text(
      '${DateFormat('EEE, d MMM y').format(date)}',
      style: TextStyle(fontSize: 14, color: Colors.black),
    );
  } else {
    return Text('No date available',
        style: TextStyle(fontSize: 14, color: Colors.black));
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
