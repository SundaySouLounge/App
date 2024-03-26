import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ultimate_band_owner_flutter/app/controller/calendar_events_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';

class AddCalendarEventScreen extends StatefulWidget {
  const AddCalendarEventScreen({Key? key}) : super(key: key);

  @override
  State<AddCalendarEventScreen> createState() => _AddCalendarEventScreenState();
}

class _AddCalendarEventScreenState extends State<AddCalendarEventScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarEventsController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.whiteColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 50,
          title: Text(
            // value.type == 'create' ? 'Create Service' : 'Update Service',
            '${value.action} Event'.tr,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: ThemeProvider.titleStyle,
          ),
        ),
        body: value.apiCalled == false
            ? SkeletonListView()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.titleTextEditor,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ThemeProvider.whiteColor,
                              hintText: 'CalendarEvent title'.tr,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 8.0, top: 14.0, left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeProvider.appColor),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeProvider.greyColor)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.calendarEventLinkTextEditor,
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeProvider.greyColor)),
                              fillColor: ThemeProvider.whiteColor,
                              hintText: 'CalendarEvent Link'.tr,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 8.0, top: 14.0, left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeProvider.appColor),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeProvider.greyColor)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: () async {
                            value.openTimePicker();
                          },
                          child: Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: ThemeProvider.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: ThemeProvider.greyColor,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Event Date'.tr,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  value.calendarEventDate != null
                                      ? '${value.calendarEventDate!.day}/${value.calendarEventDate!.month}/${value.calendarEventDate!.year}'
                                      : '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: value.action == 'Add'
              ? InkWell(
                  onTap: () {
                    value.onSubmit();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    decoration: contentButtonStyle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Calendar Event'.tr,
                          style: const TextStyle(
                              color: ThemeProvider.whiteColor, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    value.onUpdateCalendarEvent();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                      color: ThemeProvider.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'UPDATE'.tr,
                          style: const TextStyle(
                              color: ThemeProvider.whiteColor, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(100.0),
    ),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(229, 52, 1, 255),
        Color.fromARGB(228, 111, 75, 255),
      ],
    ),
  );
}
