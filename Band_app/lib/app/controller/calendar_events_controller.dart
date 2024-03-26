import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/calendar_event_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/calendar_event_parse.dart';
import 'package:ultimate_band_owner_flutter/app/helper/router.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/util/toast.dart';

class CalendarEventsController extends GetxController implements GetxService {
  final CalendarEventParser parser;

  String title = 'Add Calendar Event'.tr;

  List<CalendarEventModel> _calendarEventList = <CalendarEventModel>[];
  List<CalendarEventModel> get calendarEventList => _calendarEventList;

  final titleTextEditor = TextEditingController();
  final calendarEventLinkTextEditor = TextEditingController();
  DateTime? calendarEventDate;

  bool apiCalled = false;

  int calendarEventId = 0;
  String action = 'Add';

  CalendarEventsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments?[0] == 'Edit') {
      action = 'Edit';
      calendarEventId = Get.arguments[1] as int;
      debugPrint('calendarEvent id --> $calendarEventId');
      getCalendarEventById();
    } else if (Get.arguments?[0] == 'Add') {
      action = 'Add';
      apiCalled = true;
    } else {
      getMyCalendarEvents();
      apiCalled = true;
    }
  }

  Future<void> getMyCalendarEvents() async {
    var response = await parser.getMyCalendarEvents();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _calendarEventList = [];
      body.forEach((element) {
        CalendarEventModel calendarEvent = CalendarEventModel.fromJson(element);
        _calendarEventList.add(calendarEvent);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getCalendarEventById() async {
    var response = await parser.getCalendarEventById({"id": calendarEventId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'][0];
      debugPrint(body.toString());
      titleTextEditor.text = body['title'];
      calendarEventLinkTextEditor.text = body['event_link'];
      calendarEventDate = DateTime.parse(body['event_date'].toString());
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> onSubmit() async {
    if (titleTextEditor.text == '' ||
        titleTextEditor.text.isEmpty ||
        calendarEventLinkTextEditor.text == '' ||
        calendarEventLinkTextEditor.text.isEmpty ||
        calendarEventDate == null) {
      showToast('All fields are required!');
      return;
    }

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
                "Please wait".tr,
                style: const TextStyle(fontFamily: 'bold'),
              )),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var body = {
      "uid": parser.getUID(),
      "title": titleTextEditor.text,
      "event_date": calendarEventDate!.toIso8601String(),
      "event_link": calendarEventLinkTextEditor.text,
    };

    var response = await parser.onCreateCalendarEvent(body);
    Get.back();
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      // onBack();
      // await getMyCalendarEvents();
      Get.delete<CalendarEventsController>(force: true);
      Get.offAndToNamed(AppRouter.getCalendarEventsRoute());
      successToast('CalendarEvent Added !');
      // update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> onUpdateCalendarEvent() async {
    if (titleTextEditor.text == '' ||
        titleTextEditor.text.isEmpty ||
        calendarEventLinkTextEditor.text == '' ||
        calendarEventLinkTextEditor.text.isEmpty ||
        calendarEventDate == null) {
      showToast('All fields are required!');
      return;
    }

    var body = {
      "id": calendarEventId,
      "title": titleTextEditor.text,
      "event_date": calendarEventDate!.toIso8601String(),
      "event_link": calendarEventLinkTextEditor.text,
    };
    var response = await parser.onUpdateCalendarEvent(body);
    // Get.back();
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      Get.delete<CalendarEventsController>(force: true);
      Get.offAndToNamed(AppRouter.getCalendarEventsRoute());
      successToast('calendarEvent update !');
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void onRemoveCalendarEvent(int id) async {
    var param = {"id": id};
    var response = await parser.removeCalendarEvent(param);
    if (response.statusCode == 200) {
      await getMyCalendarEvents();
      showToast('CalendarEvent Remove Successfully');
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onAddNew() {
    Get.delete<CalendarEventsController>(force: true);
    Get.toNamed(AppRouter.getAddCalendarEventRoute(), arguments: ['Add']);
  }

  void onEdit(int id) {
    Get.delete<CalendarEventsController>(force: true);
    Get.toNamed(AppRouter.getAddCalendarEventRoute(), arguments: ['Edit', id]);
  }

  Future<void> openTimePicker() async {
    var context = Get.context as BuildContext;
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: calendarEventDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeProvider.appColor
                  .withOpacity(0.7), // header background color
              onPrimary: ThemeProvider.whiteColor, // header text color
              onSurface: ThemeProvider.blackColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ThemeProvider.appColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    newDate != null ? calendarEventDate = newDate : calendarEventDate;
    debugPrint(Jiffy(calendarEventDate).format('yyyy-MM-dd'));
    update();
  }
}
