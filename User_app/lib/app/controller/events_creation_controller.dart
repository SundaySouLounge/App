import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:app_user/app/backend/models/profile_model.dart';
import 'package:app_user/app/controller/booking_controller.dart';
import 'package:app_user/app/controller/edit_profile_controller.dart';
import 'package:app_user/app/controller/services_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:app_user/app/util/constant.dart';
import 'package:app_user/app/backend/models/event_contract_model.dart';
import 'package:app_user/app/backend/parse/events_creation_parse.dart';

class EventsCreationController extends GetxController implements GetxService {
  List<EventsCreationController>? notificationList;
  final EventsCreationParser parser;
  EditProfileController editProfileController =
      Get.put(EditProfileController(parser: Get.find()));
final sharedPrefs = Get.find<SharedPreferencesManager>();
  //IMPORTANT
  SpecialistController specialistController =
      Get.put(SpecialistController(parser: Get.find()));
  ServicesController saloonController =
      Get.put(ServicesController(parser: Get.find()));
  BookingController bookingController =
      Get.put(BookingController(parser: Get.find()));
  ProfileModel _profileInfo = ProfileModel();
  ProfileModel get profileInfo => _profileInfo;
  bool apiCalled = false;

  bool haveData = false;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  Map<int, dynamic> stepData = {}; // Map to store step data

  int currentStep = 1; // To keep track of the current step

  List<EventContractModel> savedEventContractsList = [];
  List<DateTime> unavailableDatesList = [];

  DateTime? selectedDay;
  String selectedTime = '';
  String selectedPaymentMethod = '';
  String venueName = '';
  bool get isSpecialist => arguments.length > 3 ? arguments[3] : false;
  String venueAddress = '';
  String venueMobile = '';
  String musician = '';
  String feeControllerNew = '';
  String selectedBrandSizeNew = '';
  String payment = '';
  List<String> setTimeList = [
    "2 x 45-minute sets",
    "2 x 1-hour sets",
    "3 x 45-minute sets",
  ];
  List<String> paymentsM = [
    "Cash",
    "BACS",
    "Event UK/Just Pay",
    "c247",
    "SAP Concur",
  ];
  String selectedBrandSize = '';
  List<String> brandSizeList = [];
  TextEditingController feeController = TextEditingController(text: '');
  TextEditingController extraFieldController = TextEditingController(text: '');
  EventContractModel? eventContractData;
  EventsCreationController({required this.parser});
  final arguments = Get.arguments;

  @override
   void onInit() async {
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    
    brandSizeList = arguments.length > 2 ? arguments[2] : [];
    selectedBrandSize = arguments.length > 2 && brandSizeList.isNotEmpty
        ? brandSizeList[0]
        : "solo";
    // getSalonLists();
     update();
  print('isSpecialist: $isSpecialist');
    getSavedEventContracts();
    getUnavailableDatesById();
   // bool hasStylist = Get.find<SpecialistController>().userInfo.id == null;
     _profileInfo = ProfileModel();
    print('style ${Get.find<SpecialistController>().userInfo.id}');
    venueName = Get.find<EditProfileController>().getVenueName();
    venueAddress = Get.find<EditProfileController>().getVenueAddress();
    venueMobile = Get.find<EditProfileController>().getMobile();
    payment = Get.find<EditProfileController>().getPayment();
    String firstName = specialistController.userInfo.firstName.toString();
    String lastName = specialistController.userInfo.lastName.toString();
    String specialName = saloonController.salonDetails.name.toString();
    print("LASTNAME: $firstName ${specialistController.brandSizeList}");
    setTimeList = isSpecialist
     ? ["1 x 4-hour (DJ gig)", "1 x 5-hour (DJ gig)"]
     : ["2 x 45-minute sets", "2 x 1-hour sets", "3 x 45-minute sets"];
    
    musician = isSpecialist ? '$specialName' : '$firstName $lastName';
   
    super.onInit();
  }

  Future<void> getSavedEventContracts() async {
    final id = sharedPrefs.getInt("key-individualId");
    Response response;
    if (arguments == null) {
      response = await parser.getSavedEventContracts({
        'individual_id': id,
        'salon_id': 0,
      });
    } else {
      response = await parser.getSavedEventContracts({
        'individual_id': arguments[0],
        'salon_id': arguments[1],
      });
    }
    debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${response.body}");
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      savedEventContractsList = myMap['data']
          .map<EventContractModel>((item) => EventContractModel.fromJson(item))
          .toList();
    }
    update();
  }


  EditProfileController getEditProfileController() {
    return Get.find<EditProfileController>();
  }

  Future<void> getUnavailableDatesById() async {
    apiCalled = false;
    update();
    // debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>${arguments[1]}");
    final id = sharedPrefs.getInt("key-individualId");
    Response response;
/*
    if (arguments == null) {
      response = await parser.getSavedEventContracts({
        'individual_id': id,
        'salon_id': 0,
      });
    } else {
      response = await parser.getSavedEventContracts({
        'individual_id': arguments[0],
        'salon_id': arguments[1],
      });
    }
 */
    if (arguments == null) {
      response = await parser.getUnavailableDatesById({
        'individual_id': id,
        'salon_id': 0,
      });
    } else {
      response = await parser.getUnavailableDatesById({
        'individual_id': arguments[0],
        'salon_id': arguments[1],
      });
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      //debugPrint("getUnavailableDatesById >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${myMap['data']}");
       try {
         unavailableDatesList = (myMap['data'] as List<dynamic>)
             .map<DateTime>((item) => DateTime.parse(item.toString()))
             .toSet().toList();
        //debugPrint("MMMMMMMMMMMMMMM>>>>>>>>>>>>>>>> ${unavailableDatesList.length} => ${unavailableDatesList}");
       } catch(error) {
         debugPrint(error.toString());
       }
    }
    apiCalled = true;

    update();
  }

  void setVenueDetails(String name, String address, String mobile, String paymentMeths) {
    venueName = name;
    venueAddress = address;
    venueMobile = mobile;
    payment = paymentMeths;
    update(); // Trigger UI update
  }

//TO-DO
//we can pass the values for create a new contract
// the value here are from the old contract we can pass using like eventDataContract.salonID or eventDataContract.fees
// the problem is is not creating a new contract
// should work like this the event details should be the same the only thing to change is the date so when the user click
// the user select a new date and is pass into the contrct creation
  Future<void> createNewEvent(Map<String, dynamic> data) async {
    apiCalled = false;
    update();

    // Check if the data contains an ID
    if (data.containsKey('id')) {
      // Exclude the 'id' field from the data
      data.remove('id');
    }

    Response response = await parser.createEventContract(data);

    if (response.statusCode == 200) {
      successToast('Congratulations! The artist has received your job offer! ');
      await getSavedEventContracts();
    } else {
      return;
    }

    currentStep = 1;
    apiCalled = true;
    update();
  }

  bool _showWaitingToasts = false;
  Future<void> onSubmit() async {
    apiCalled = false;
    update();

    Response response;
    int attemptCounter = 0;
    _showWaitingToasts = true;
    showWaitingToasts();
    do {
      response = await parser.createEventContract({
        'salon_id': arguments[1],
        'individual_id': arguments[0],
        'date': selectedDay != null ? selectedDay!.toIso8601String() : null,
        'time': selectedTime,
        'band_size': selectedBrandSize,
        'fee': feeController.text,
        'extra_field': extraFieldController.text,
        'venue_name': venueName,
        'venue_address': venueAddress,
        'mobile': venueMobile,
        'musician': musician,
        'payment_method': payment,
      });
      attemptCounter++;
    } while(response.statusCode != 200 && attemptCounter < 3);

    debugPrint("createEventContract Response: ${response.body}");

    _showWaitingToasts = false;
    await Future.delayed(const Duration(milliseconds: 2500)); // Wait for the last waiting toasts above to get hidden.

    if (response.statusCode == 200) {
      successToast('Congratulations! The artist has received your job offer! ');
      await getSavedEventContracts();
    } else {
      showToast('Unable to process your request. You are required to try again from start.');
      await Future.delayed(const Duration(milliseconds: 3500)); // Wait for the toast above to get hidden.
    }

    currentStep = 1;
    apiCalled = true;
    update();
  }

  Future<void> showWaitingToasts() async {
    int counter = 0;
    List<String> messages = [
      "Loading",
      "Please wait, we're being awesome!",
      "It's coming, please hold the phone!",
      "Loading",
      "Don't worry, the musicians are being awesome!",
      "Don't worry, the DJs are smashing it!",
    ];
    while(_showWaitingToasts) {
      String message = messages[counter % messages.length];
      Get.showSnackbar(GetSnackBar(
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        message: message.tr,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        isDismissible: false,
        dismissDirection: DismissDirection.horizontal,
      ));

      await Future.delayed(const Duration(milliseconds: 3000)); // Wait for the toast to get hidden.

      counter++;
    }
  }
  
  void selectStep(int step) {
    currentStep = step;
    update();
  }

  void saveDataForStep(int step, dynamic data) {
    stepData[step] = data;
    update();
  }

  void selectdate(DateTime date) {
    selectedDay = date;
    update();
  }

  void selectTime(String text) {
    selectedTime = text;
    update();
  }

  void selectPayment(String text) {
    selectedPaymentMethod = text;
    update();
  }

  void selectBrands(String text) {
    selectedBrandSize = text;
    update();
  }
}
