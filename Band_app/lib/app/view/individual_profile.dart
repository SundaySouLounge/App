import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/individual_profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/env.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';

class IndividualProfileScreen extends StatefulWidget {
  const IndividualProfileScreen({Key? key}) : super(key: key);

  @override
  State<IndividualProfileScreen> createState() =>
      _IndividualProfileScreenState();
}

class _IndividualProfileScreenState extends State<IndividualProfileScreen> {
  String travelEditor = 'YES'; // Use nullable type for selectedValue

   String selectedAcusticSoloValue = '£150-£300';
   String selectedAcusticDuoValue = '£150-£300';
   String selectedAcusticTrioValue = '£300-£400';
   String selectedAcusticQuarterValue = '£300-£400';
   String weddingEditor = '£300-£600';

   bool showDropdown = false;
   bool showDropdownOne = false;
   bool showDropdownTwo = false;
   bool showDropdownThree = false;
   bool showDropdownFour = false;
   bool showDropdownFive = false;

   bool instrumentOne = false;
   bool instrumentTwo = false;
   bool instrumentThree = false;
   bool instrumentFour = false;
   bool instrumentFive = false;

   String selectedAcusticDuoValueInstrument = 'Vocals';
   String selectedAcusticQuarterValueInstrument = 'Vocals';
   String selectedAcusticTrioValueInstrument = 'Vocals';
   String selectedAcusticSoloValueInstrument = 'Vocals'; // or any other valid initial value
   String weddingEditorInstrument = 'Vocals';

   List<String> dropdownItems = [
  'Vocals',
  'Keys/Piano',
  'Jazz Piano',
  'Acoustic Guitar',
  'Electric Guitar',
  'Jazz Guitar',
  'Bass Guitar',
  'Double Bass',
  'Drums/Cajon',
  'Percussion',
  'Saxophone',
  'Trumpet',
  'Harmonica',
  'Loop Pedal',
  'Stomp Box',
];
Set<String> selectedAcusticSoloValues = {}; 
Set<String> selectedAcusticDuoValues = {}; 
Set<String> selectedAcusticTrioValues = {}; 
Set<String> selectedAcusticQuarterValues = {}; 
Set<String> selectedAcusticWeddingValues = {}; 

    @override
  void initState() {
    super.initState();
    // You can set the default value here
    
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualProfileController>(
      builder: (value) {
        final item = Get.put(ProfileController(parser: Get.find()));
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          body: value.apiCalled == false
              ? const Center(
                  child:
                      CircularProgressIndicator(color: ThemeProvider.appColor),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: FadeInImage(
                              image: NetworkImage(
                                  '${Environments.apiBaseURL}storage/images/${value.backgroundCover}'),
                              placeholder: const AssetImage(
                                  "assets/images/placeholder.jpeg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/notfound.png',
                                  fit: BoxFit.cover,
                                  height: 300,
                                  width: double.infinity,
                                );
                              },
                              fit: BoxFit.cover,
                              height: 300,
                              width: double.infinity,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 70, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: ThemeProvider.greenColor,
                                    child: IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoActionSheet(
                                            title: Text('Choose From'.tr),
                                            actions: <CupertinoActionSheetAction>[
                                              CupertinoActionSheetAction(
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  value.selectFromGallery(
                                                      'camera');
                                                },
                                                child: Text('Camera'.tr),
                                              ),
                                              CupertinoActionSheetAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  value.selectFromGallery(
                                                      'gallery');
                                                },
                                                child: Text('Gallery'.tr),
                                              ),
                                              CupertinoActionSheetAction(
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'.tr),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: ThemeProvider.whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            
                             Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.bandName,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Band Name'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.contactName,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Contact Name'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: TextEditingController(text: item.parser.getEmail()),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Email Address'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 5),
                            //   child: SizedBox(
                            //     width: double.infinity,
                            //     child: TextField(
                            //       controller: value.contactNumber.text.isEmpty ? null : value.contactNumber,
                            //       maxLines: 1,
                            //       decoration: InputDecoration(
                            //         filled: true,
                            //         fillColor: ThemeProvider.whiteColor,
                            //         hintText: 'Contact Number'.tr,
                            //         hintStyle: const TextStyle(
                            //             color: ThemeProvider.greyColor,
                            //             fontSize: 12),
                            //         contentPadding: const EdgeInsets.only(
                            //             bottom: 8.0, top: 14.0, left: 20),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10),
                            //           borderSide: const BorderSide(
                            //               color: ThemeProvider.appColor),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(10),
                            //             borderSide: const BorderSide(
                            //                 color: ThemeProvider.appColor)),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                      color: ThemeProvider.appColor,
                                      style: BorderStyle.solid),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    value.onSelectCities();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 11),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value.individualInfo.cityData!.name
                                                          .toString() ==
                                                      '' ||
                                                  value.individualInfo.cityData!
                                                      .name!.isEmpty
                                              ? 'Select'.tr
                                              : value
                                                  .individualInfo.cityData!.name
                                                  .toString(),
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        const Icon(
                                          Icons.expand_more,
                                          color: ThemeProvider.greyColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.aboutTextEditor,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Brief Of Salon'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: ThemeProvider.appColor,
                                      style: BorderStyle.solid),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    value.onSelectCategories();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 11),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            value.individualInfo.webCatesData!
                                                .length,
                                            (index) => Column(
                                              children: [
                                                Text(
                                                  value.individualInfo
                                                      .webCatesData![index].name
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: ThemeProvider.greyColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: 
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.addressTextEditor,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Enter Address..'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            ),
                            
                            Visibility(
                              visible: false,
                              child:Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.zipCodeTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'ZIP Code'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            ),
                            Visibility(
                              visible: false,
                              child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.latTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Latitude'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            ),
                            Visibility(
                              visible: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: value.lngTextEditor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ThemeProvider.whiteColor,
                                    hintText: 'Longitude'.tr,
                                    hintStyle: const TextStyle(
                                        color: ThemeProvider.greyColor,
                                        fontSize: 12),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8.0, top: 14.0, left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: const BorderSide(
                                          color: ThemeProvider.appColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        borderSide: const BorderSide(
                                            color: ThemeProvider.appColor)),
                                  ),
                                ),
                              ),
                            ),
                            ),
                            const SizedBox(height: 30),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 10.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         'Have Popular ?'.tr,
                            //         style: const TextStyle(fontSize: 14),
                            //       ),
                            //       Switch(
                            //         value: value.havePopular,
                            //         onChanged: (bool status) {
                            //           value.updatePopular(status);
                            //         },
                            //         activeColor: ThemeProvider.greenColor,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Have Shop ?'.tr,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Switch(
                                    value: value.haveShop,
                                    onChanged: (bool status) {
                                      value.updateShop(status);
                                    },
                                    activeColor: ThemeProvider.greenColor,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Have Home ?'.tr,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Switch(
                                    value: value.haveHome,
                                    onChanged: (bool status) {
                                      value.updateHome(status);
                                    },
                                    activeColor: ThemeProvider.greenColor,
                                  ),
                                ],
                              ),
                            ),
                             Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Trio'.tr,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Switch(
                                    value: value.haveTrio,
                                    onChanged: (bool status) {
                                      value.updateTrio(status);
                                    },
                                    activeColor: ThemeProvider.greenColor,
                                  ),
                                ],
                              ),
                            ),
                             Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quartet or Higher'.tr,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Switch(
                                    value: value.haveQuartet,
                                    onChanged: (bool status) {
                                      value.updateQuartet(status);
                                    },
                                    activeColor: ThemeProvider.greenColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 10),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         'Opening Hour'.tr,
                            //         style: const TextStyle(
                            //             fontSize: 14,
                            //             fontFamily: 'bold',
                            //             color: ThemeProvider.blackColor),
                            //       ),
                            //       InkWell(
                            //         onTap: () {
                            //           value.onAddNewTiming();
                            //         },
                            //         child: const Icon(
                            //           Icons.add_circle,
                            //           color: ThemeProvider.appColor,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 10),
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Row(
                            //         children: [
                            //           Text(
                            //             'Acoustic Packages'.tr,
                            //             style: const TextStyle(
                            //               fontSize: 14,
                            //               fontFamily: 'bold',
                            //               color: ThemeProvider.blackColor,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       SizedBox(height: 10),
                            //       Visibility(
                            //     visible: value.haveShop,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                                  
                            //       children: [
                            //         Text(
                            //           'Solo',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             fontFamily: 'bold',
                            //             color: ThemeProvider.blackColor,
                            //           ),
                            //         ),
                            //          SizedBox(height: 2),
                            //                   Text(
                            //                     'Price:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                            //         GestureDetector(
                            //           onTap: () {
                            //             // Show/hide dropdown when the text field is tapped
                            //             setState(() {
                            //               showDropdown = !showDropdown;
                            //             });
                            //           },
                            //           child: showDropdown 
                            //           ?AbsorbPointer(
                            //             absorbing: true, // Disable text field editing
                            //             child: TextFormField(
                            //               controller: value.selectedAcusticSoloValue,
                            //               style: TextStyle(
                            //                 fontSize: 14,
                            //                 color: ThemeProvider.blackColor,
                            //               ),
                            //               decoration: InputDecoration(
                            //                 border: InputBorder.none, // Remove underline
                            //               ),
                            //             ),
                            //           )
                            //           : value.individualInfo.selectedAcusticSoloValue != null 
                            //           ? AbsorbPointer(
                            //             absorbing: true, // Disable text field editing
                            //             child: TextFormField(
                            //               controller: value.selectedAcusticSoloValue,
                            //               style: TextStyle(
                            //                 fontSize: 14,
                            //                 color: ThemeProvider.blackColor,
                            //               ),
                            //               decoration: InputDecoration(
                            //                 border: InputBorder.none, // Remove underline
                            //               ),
                            //             ),
                            //           )
                            //           : Text(
                            //               'Select Price',
                            //               style: TextStyle(
                            //                 fontSize: 14,
                            //                 color: ThemeProvider.blackColor,
                            //               ),
                            //             ),
                            //         ),
                            //           SizedBox(width: 10),
                            //         if (showDropdown)
                            //           DropdownButton<String>(
                            //             value: selectedAcusticSoloValue,
                            //             onChanged: (String? newValue) {
                            //               print("Selected value from dropdown: $newValue");
                            //               setState(() {
                            //                 selectedAcusticSoloValue = newValue ?? '';
                            //                 value.selectedAcusticSoloValue.text = selectedAcusticSoloValue;
                            //               });

                            //               // Print the updated value and check if it matches the selected value in the UI
                            //               print("Updated selectedAcusticSoloValue: $selectedAcusticSoloValue");

                            //               // Explicitly trigger a rebuild for the widget containing the Text widget
                            //               WidgetsBinding.instance!.addPostFrameCallback((_) {
                            //                 setState(() {});
                            //               });
                            //             },
                            //             items: <String>[
                            //               '£150-£300',
                            //               '£300-£400',
                            //             ].map<DropdownMenuItem<String>>((String value) {
                            //               return DropdownMenuItem<String>(
                            //                 value: value,
                            //                 child: Text(value),
                            //               );
                            //             }).toList(),
                            //           ),
                            //         SizedBox(height: 5),
                            //                   Text(
                            //                     'What is the setup:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                                  
                            //           //INSTRUMENT
                            //          GestureDetector(
                            //             onTap: () {
                            //               // Show/hide dropdown when the text field is tapped
                            //               setState(() {
                            //                 instrumentOne = !instrumentOne;
                            //               });
                            //             },
                            //             child: instrumentOne
                            //                 ? AbsorbPointer(
                            //                     absorbing: true, // Disable text field editing
                            //                     child: TextFormField(
                            //                       controller: value.selectedAcusticSoloValueInstrument,
                            //                       style: TextStyle(
                            //                         fontSize: 14,
                            //                         color: ThemeProvider.blackColor,
                            //                       ),
                            //                       decoration: InputDecoration(
                            //                       border: InputBorder.none, // Remove underline
                            //                     ),
                            //                     ),
                            //                   )
                            //                 : value.individualInfo.selectedAcusticSoloValueInstrument != null
                            //                     ? AbsorbPointer(
                            //                         absorbing: true, // Disable text field editing
                            //                         child: TextFormField(
                            //                           controller: value.selectedAcusticSoloValueInstrument,
                            //                           style: TextStyle(
                            //                             fontSize: 14,
                            //                             color: ThemeProvider.blackColor,
                            //                           ),
                            //                           decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                         ),
                            //                       )
                            //                     : Text(
                            //                         'Select Instruments',
                            //                         style: TextStyle(
                            //                           fontSize: 14,
                            //                           color: ThemeProvider.blackColor,
                            //                         ),
                            //                       ),
                            //           ),
                            //           SizedBox(width: 10),
                            //           if (instrumentOne)
                            //             DropdownButtonFormField<String>(
                            //               value: selectedAcusticSoloValues.isNotEmpty ? selectedAcusticSoloValues.first : null,
                            //               onChanged: (String? newValue) {
                            //                 setState(() {
                            //                   if (newValue != null) {
                            //                     // Toggle the selected value
                            //                     if (selectedAcusticSoloValues.contains(newValue)) {
                            //                       selectedAcusticSoloValues.remove(newValue);
                            //                     } else {
                            //                       selectedAcusticSoloValues.add(newValue);
                            //                     }

                            //                     // Update the text field with selected values
                            //                     value.selectedAcusticSoloValueInstrument.text = selectedAcusticSoloValues.join(', ');
                            //                   }
                            //                 });
                            //               },
                            //               items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                            //                 bool isSelected = selectedAcusticSoloValues.contains(value);

                            //                 return DropdownMenuItem<String>(
                            //                   value: value,
                            //                   child: Row(
                            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Text(value),
                            //                       if (isSelected) Icon(Icons.check, color: Colors.green),
                            //                     ],
                            //                   ),
                            //                 );
                            //               }).toList(),
                            //             ),

                            //       ],
                            //     ),
                            //       ),

                            //       SizedBox(
                            //           height:
                            //               10), // Adjust the height between dropdowns as needed 
                            //     Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Visibility(
                            //       visible: value.haveHome,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'Duo',
                            //               style: TextStyle(
                            //                 fontSize: 14,
                            //                 fontFamily: 'bold',
                            //                 color: ThemeProvider.blackColor,
                            //               ),
                            //             ),
                            //             SizedBox(height: 2),
                            //                   Text(
                            //                     'Price:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                            //             SizedBox(width: 10),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 // Show/hide duo dropdown when tapped
                            //                 setState(() {
                            //                   showDropdownOne = !showDropdownOne;
                            //                 });
                            //               },
                            //               child: showDropdownOne
                            //               ? AbsorbPointer(
                            //                 absorbing: true, // Disable text field editing
                            //                 child: TextFormField(
                            //                   controller: value.selectedAcusticDuoValue,
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     color: ThemeProvider.blackColor,
                            //                   ),
                            //                    decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                 ),
                            //               )
                            //               : value.individualInfo.selectedAcusticDuoValue != null 
                            //               ? AbsorbPointer(
                            //                   absorbing: true, // Disable text field editing
                            //                   child: TextFormField(
                            //                     controller: value.selectedAcusticDuoValue,
                            //                     style: TextStyle(
                            //                       fontSize: 14,
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                      decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                   ),
                            //                 )
                            //               : Text(
                            //                   'Select Price',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     color: ThemeProvider.blackColor,
                            //                   ),
                            //                 ),
                            //             ),
                            //             SizedBox(width: 10),
                            //             if (showDropdownOne)
                            //               DropdownButton<String>(
                            //                 value: selectedAcusticDuoValue,
                            //                 onChanged: (String? newValue) {
                            //                   print("Selected value from duo dropdown: $newValue");
                            //                   setState(() {
                            //                     selectedAcusticDuoValue = newValue ?? '';
                            //                     value.selectedAcusticDuoValue.text = selectedAcusticDuoValue;
                            //                   });

                            //                   // Print the updated value and check if it matches the selected value in the UI
                            //                   print("Updated selectedAcusticDuoValue: $selectedAcusticDuoValue");

                            //                   // Explicitly trigger a rebuild for the widget containing the Text widget
                            //                   WidgetsBinding.instance?.addPostFrameCallback((_) {
                            //                     setState(() {});
                            //                   });
                            //                 },
                            //                 items: <String>[
                            //                   '£150-£300',
                            //                   '£300-£400',
                            //                 ].map<DropdownMenuItem<String>>((String value) {
                            //                   return DropdownMenuItem<String>(
                            //                     value: value,
                            //                     child: Text(value),
                            //                   );
                            //                 }).toList(),
                            //               ),
                            //             SizedBox(height:5),
                            //                   Text(
                            //                     'What is the setup:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                                        
                            //               //INSTRUMENT
                            //           GestureDetector(
                            //           onTap: () {
                            //             // Show/hide dropdown when the text field is tapped
                            //             setState(() {
                            //               instrumentTwo = !instrumentTwo;
                            //             });
                            //           },
                            //           child: instrumentTwo
                            //               ? AbsorbPointer(
                            //                   absorbing: true, // Disable text field editing
                            //                   child: TextFormField(
                            //                     controller: value.selectedAcusticDuoValueInstrument,
                            //                     style: TextStyle(
                            //                       fontSize: 14,
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                      decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                   ),
                            //                 )
                            //               : value.individualInfo.selectedAcusticDuoValueInstrument != null
                            //                   ? AbsorbPointer(
                            //                       absorbing: true, // Disable text field editing
                            //                       child: TextFormField(
                            //                         controller: value.selectedAcusticDuoValueInstrument,
                            //                         style: TextStyle(
                            //                           fontSize: 14,
                            //                           color: ThemeProvider.blackColor,
                            //                           decoration: TextDecoration.underline,
                            //                         ),
                            //                          decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                       ),
                            //                     )
                            //                   : Text(
                            //                       'Select Instruments',
                            //                       style: TextStyle(
                            //                         fontSize: 14,
                            //                         color: ThemeProvider.blackColor,
                            //                         decoration: TextDecoration.underline,
                            //                       ),
                            //                     ),
                            //         ),
                            //         SizedBox(width: 10),
                            //         if (instrumentTwo)
                            //           DropdownButtonFormField<String>(
                            //             value: selectedAcusticDuoValues.isNotEmpty ? selectedAcusticDuoValues.first : null,
                            //             onChanged: (String? newValue) {
                            //               setState(() {
                            //                 if (newValue != null) {
                            //                   // Toggle the selected value
                            //                   if (selectedAcusticDuoValues.contains(newValue)) {
                            //                     selectedAcusticDuoValues.remove(newValue);
                            //                   } else {
                            //                     selectedAcusticDuoValues.add(newValue);
                            //                   }

                            //                   // Update the text field with selected values
                            //                   value.selectedAcusticDuoValueInstrument.text = selectedAcusticDuoValues.join(', ');
                            //                 }
                            //               });
                            //             },
                            //             items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                            //               bool isSelected = selectedAcusticDuoValues.contains(value);

                            //               return DropdownMenuItem<String>(
                            //                 value: value,
                            //                 child: Row(
                            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                   children: [
                            //                     Text(value),
                            //                     if (isSelected) Icon(Icons.check, color: Colors.green),
                            //                   ],
                            //                 ),
                            //               );
                            //             }).toList(),
                            //           ),

                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //       ),

                            //         SizedBox(
                            //           height:
                            //               10),
                            //     Visibility(
                            //      visible: value.haveTrio,
                            //      child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Text(
                            //                     'Trio',
                            //                     style: TextStyle(
                            //                       fontSize: 14,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                            //                   SizedBox(height: 2),
                            //                   Text(
                            //                     'Price:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   GestureDetector(
                            //                     onTap: () {
                            //                       // Show/hide trio dropdown when tapped
                            //                       setState(() {
                            //                         showDropdownThree = !showDropdownThree;
                            //                       });
                            //                     },
                            //                     child: showDropdownThree
                            //                     ? AbsorbPointer(
                            //                       absorbing: true, // Disable text field editing
                            //                       child: TextFormField(
                            //                         controller: value.selectedAcusticTrioValue,
                            //                         style: TextStyle(
                            //                           fontSize: 14,
                            //                           color: ThemeProvider.blackColor,
                            //                         ),
                            //                          decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                       ),
                            //                     )
                            //                    : value.individualInfo.selectedAcusticTrioValue != null 
                            //                   ? AbsorbPointer(
                            //                       absorbing: true, // Disable text field editing
                            //                       child: TextFormField(
                            //                         controller: value.selectedAcusticTrioValue,
                            //                         style: TextStyle(
                            //                           fontSize: 14,
                            //                           color: ThemeProvider.blackColor,
                            //                         ),
                            //                          decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                       ),
                            //                     )
                            //                   : Text(
                            //                       'Select Price',
                            //                       style: TextStyle(
                            //                         fontSize: 14,
                            //                         color: ThemeProvider.blackColor,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   if (showDropdownThree)
                            //                     DropdownButton<String>(
                            //                       value: selectedAcusticTrioValue,
                            //                       onChanged: (String? newValue) {
                            //                         print("Selected value from trio dropdown: $newValue");
                            //                         setState(() {
                            //                           selectedAcusticTrioValue = newValue ?? '';
                            //                           value.selectedAcusticTrioValue.text = selectedAcusticTrioValue;
                            //                         });

                            //                         // Print the updated value and check if it matches the selected value in the UI
                            //                         print("Updated selectedAcusticTrioValue: $selectedAcusticTrioValue");

                            //                         // Explicitly trigger a rebuild for the widget containing the Text widget
                            //                         WidgetsBinding.instance?.addPostFrameCallback((_) {
                            //                           setState(() {});
                            //                         });
                            //                       },
                            //                       items: <String>[
                            //                         '£300-£400',
                            //                         '£400-£500',
                            //                       ].map<DropdownMenuItem<String>>((String value) {
                            //                         return DropdownMenuItem<String>(
                            //                           value: value,
                            //                           child: Text(value),
                            //                         );
                            //                       }).toList(),
                            //                     ),
                            //                    SizedBox(height: 5),
                            //                   Text(
                            //                     'What is the setup:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                                              
                            //                       //INSTRUMENT
                            //                   GestureDetector(
                            //                   onTap: () {
                            //                     // Show/hide dropdown when the text field is tapped
                            //                     setState(() {
                            //                       instrumentThree = !instrumentThree;
                            //                     });
                            //                   },
                            //                   child: instrumentThree
                            //                       ? AbsorbPointer(
                            //                           absorbing: true, // Disable text field editing
                            //                           child: TextFormField(
                            //                             controller: value.selectedAcusticTrioValueInstrument,
                            //                             style: TextStyle(
                            //                               fontSize: 14,
                            //                               color: ThemeProvider.blackColor,
                            //                             ),
                            //                              decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                           ),
                            //                         )
                            //                       : value.individualInfo.selectedAcusticTrioValueInstrument != null
                            //                           ? AbsorbPointer(
                            //                               absorbing: true, // Disable text field editing
                            //                               child: TextFormField(
                            //                                 controller: value.selectedAcusticTrioValueInstrument,
                            //                                 style: TextStyle(
                            //                                   fontSize: 14,
                            //                                   color: ThemeProvider.blackColor,
                            //                                 ),
                            //                                  decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                               ),
                            //                             )
                            //                           : Text(
                            //                               'Select Instruments',
                            //                               style: TextStyle(
                            //                                 fontSize: 14,
                            //                                 color: ThemeProvider.blackColor,
                            //                               ),
                            //                             ),
                            //                 ),
                            //                 SizedBox(width: 10),
                            //                 if (instrumentThree)
                            //                   DropdownButtonFormField<String>(
                            //                     value: selectedAcusticTrioValues.isNotEmpty ? selectedAcusticTrioValues.first : null,
                            //                     onChanged: (String? newValue) {
                            //                       setState(() {
                            //                         if (newValue != null) {
                            //                           // Toggle the selected value
                            //                           if (selectedAcusticTrioValues.contains(newValue)) {
                            //                             selectedAcusticTrioValues.remove(newValue);
                            //                           } else {
                            //                             selectedAcusticTrioValues.add(newValue);
                            //                           }

                            //                           // Update the text field with selected values
                            //                           value.selectedAcusticTrioValueInstrument.text = selectedAcusticTrioValues.join(', ');
                            //                         }
                            //                       });
                            //                     },
                            //                     items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                            //                       bool isSelected = selectedAcusticTrioValues.contains(value);

                            //                       return DropdownMenuItem<String>(
                            //                         value: value,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                           children: [
                            //                             Text(value),
                            //                             if (isSelected) Icon(Icons.check, color: Colors.green),
                            //                           ],
                            //                         ),
                            //                       );
                            //                     }).toList(),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //        ),

                            //           SizedBox(
                            //           height:
                            //               10),
                            //     Visibility(
                            //       visible: value.haveQuartet,
                            //       child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Text(
                            //                     'Quartet and Higher',
                            //                     style: TextStyle(
                            //                       fontSize: 14,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                            //                    SizedBox(height: 2),
                            //                   Text(
                            //                     'Price:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 10),
                                              
                            //                   GestureDetector(
                            //                     onTap: () {
                            //                       // Show/hide setup dropdown when tapped
                            //                       setState(() {
                            //                         showDropdownFour = !showDropdownFour;
                            //                       });
                            //                     },
                            //                     child: showDropdownFour
                            //                     ? AbsorbPointer(
                            //                       absorbing: true, // Disable text field editing
                            //                       child: Container(
                            //                         constraints: BoxConstraints(minWidth: 0, maxWidth: 200), // Set your desired constraints
                            //                         child: TextFormField(
                            //                           controller: value.selectedAcusticQuarterValue,
                            //                           style: const TextStyle(
                            //                             fontSize: 14,
                            //                             fontFamily: 'bold',
                            //                             color: ThemeProvider.blackColor,
                            //                           ),
                            //                            decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                         ),
                            //                       ),
                            //                     )
                            //                      : value.individualInfo.selectedAcusticQuarterValue != null 
                            //                   ? AbsorbPointer(
                            //                       absorbing: true, // Disable text field editing
                            //                       child: TextFormField(
                            //                         controller: value.selectedAcusticQuarterValue,
                            //                         style: TextStyle(
                            //                           fontSize: 14,
                            //                           color: ThemeProvider.blackColor,
                            //                         ),
                            //                          decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                       ),
                            //                     )
                            //                   : Text(
                            //                       'Select Price',
                            //                       style: TextStyle(
                            //                         fontSize: 14,
                            //                         color: ThemeProvider.blackColor,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   SizedBox(width: 10),
                                               
                            //                   if (showDropdownFour)
                            //                   DropdownButton<String>(
                            //                     value: selectedAcusticQuarterValue,
                            //                     onChanged: (String? newValue) {
                            //                       print("Selected value from setup dropdown: $newValue");
                            //                       setState(() {
                            //                         selectedAcusticQuarterValue = newValue ?? '';
                            //                         value.selectedAcusticQuarterValue.text = selectedAcusticQuarterValue;
                            //                       });

                            //                       // Print the updated value and check if it matches the selected value in the UI
                            //                       print("Updated selectedAcusticQuarterValue: $selectedAcusticQuarterValue");

                            //                       // Explicitly trigger a rebuild for the widget containing the Text widget
                            //                       WidgetsBinding.instance?.addPostFrameCallback((_) {
                            //                         setState(() {});
                            //                       });
                            //                     },
                            //                     items: <String>[
                            //                       '£300-£400',
                            //                       '£400-£500',
                            //                       '£500-£600',
                            //                     ].map<DropdownMenuItem<String>>((String value) {
                            //                       return DropdownMenuItem<String>(
                            //                         value: value,
                            //                         child: Text(value),
                            //                       );
                            //                     }).toList(),
                            //                   ),
                            //                   SizedBox(height: 5),
                            //                   Text(
                            //                     'What is the setup:',
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       fontFamily: 'bold',
                            //                       color: ThemeProvider.blackColor,
                            //                     ),
                            //                   ),
                                              
                            //                       //INSTRUMENT
                            //                     GestureDetector(
                            //                     onTap: () {
                            //                       // Show/hide dropdown when the text field is tapped
                            //                       setState(() {
                            //                         instrumentFour = !instrumentFour;
                            //                       });
                            //                     },
                            //                     child: instrumentFour
                            //                         ? AbsorbPointer(
                            //                             absorbing: true, // Disable text field editing
                            //                             child: TextFormField(
                            //                               controller: value.selectedAcusticQuarterValueInstrument,
                            //                               style: TextStyle(
                            //                                 fontSize: 14,
                            //                                 color: ThemeProvider.blackColor,
                            //                               ),
                            //                                decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                             ),
                            //                           )
                            //                         : value.individualInfo.selectedAcusticQuarterValueInstrument != null
                            //                             ? AbsorbPointer(
                            //                                 absorbing: true, // Disable text field editing
                            //                                 child: TextFormField(
                            //                                   controller: value.selectedAcusticQuarterValueInstrument,
                            //                                   style: TextStyle(
                            //                                     fontSize: 14,
                            //                                     color: ThemeProvider.blackColor,
                            //                                   ),
                            //                                    decoration: InputDecoration(
                            //                           border: InputBorder.none, // Remove underline
                            //                         ),
                            //                                 ),
                            //                               )
                            //                             : Text(
                            //                                 'Select Instruments',
                            //                                 style: TextStyle(
                            //                                   fontSize: 14,
                            //                                   color: ThemeProvider.blackColor,
                            //                                 ),
                            //                               ),
                            //                   ),
                            //                   SizedBox(width: 10),
                            //                   if (instrumentFour)
                            //                     DropdownButtonFormField<String>(
                            //                       value: selectedAcusticQuarterValues.isNotEmpty ? selectedAcusticQuarterValues.first : null,
                            //                       onChanged: (String? newValue) {
                            //                         setState(() {
                            //                           if (newValue != null) {
                            //                             // Toggle the selected value
                            //                             if (selectedAcusticQuarterValues.contains(newValue)) {
                            //                               selectedAcusticQuarterValues.remove(newValue);
                            //                             } else {
                            //                               selectedAcusticQuarterValues.add(newValue);
                            //                             }

                            //                             // Update the text field with selected values
                            //                             value.selectedAcusticQuarterValueInstrument.text = selectedAcusticQuarterValues.join(', ');
                            //                           }
                            //                         });
                            //                       },
                            //                       items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                            //                         bool isSelected = selectedAcusticQuarterValues.contains(value);

                            //                         return DropdownMenuItem<String>(
                            //                           value: value,
                            //                           child: Row(
                            //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                             children: [
                            //                               Text(value),
                            //                               if (isSelected) Icon(Icons.check, color: Colors.green),
                            //                             ],
                            //                           ),
                            //                         );
                            //                       }).toList(),
                            //                     ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         ],
                            //       ),
                            //       // Add more Column widgets for additional dropdowns as needed
                            //     ],
                            //   ),
                            // ),
                                  
                        //   Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 10),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Text(
                        //             'Wedding and Corporate'.tr,
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               fontFamily: 'bold',
                        //               color: ThemeProvider.blackColor,
                        //               decoration: TextDecoration.none,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 10), // Adjust the height as needed
                        //       Row(
                        //         children: [
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 'Fee: ',
                        //                 style: TextStyle(
                        //                   fontSize: 14,
                        //                   color: ThemeProvider.blackColor,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           SizedBox(width: 10),
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //              GestureDetector(
                        //                 onTap: () {
                        //                   // Toggle the visibility of the wedding dropdown
                        //                   setState(() {
                        //                     showDropdownTwo = !showDropdownTwo;
                        //                   });
                        //                 },
                        //                 child: showDropdownTwo
                        //                 ? AbsorbPointer(
                        //                   absorbing: true, // Disable text field editing
                        //                   child: Container(
                        //                     constraints: BoxConstraints(minWidth: 0, maxWidth: 200), // Set your desired constraints
                        //                     child: TextFormField(
                        //                       controller: value.weddingEditor,
                        //                       style: const TextStyle(
                        //                         fontSize: 14,
                        //                         fontFamily: 'bold',
                        //                         color: ThemeProvider.blackColor,
                        //                       ),
                        //                        decoration: InputDecoration(
                        //                               border: InputBorder.none, // Remove underline
                        //                             ),
                        //                     ),
                        //                   ),
                        //                 )
                        //                  : value.individualInfo.weddingEditor != null 
                        //                       ? AbsorbPointer(
                        //                           absorbing: true, // Disable text field editing
                        //                           child: TextFormField(
                        //                             controller: value.weddingEditor,
                        //                             style: TextStyle(
                        //                               fontSize: 14,
                        //                               color: ThemeProvider.blackColor,
                        //                             ),
                        //                              decoration: InputDecoration(
                        //                               border: InputBorder.none, // Remove underline
                        //                             ),
                        //                           ),
                        //                         )
                        //                       : Text(
                        //                           'Select Price',
                        //                           style: TextStyle(
                        //                             fontSize: 14,
                        //                             color: ThemeProvider.blackColor,
                        //                           ),
                        //                         ),
                        //               ),
                        //               SizedBox(height: 10),
                        //               if (showDropdownTwo)
                        //                 DropdownButton<String>(
                        //                   value: weddingEditor,
                        //                   onChanged: (String? newValue) {
                        //                     print("Selected value from wedding dropdown: $newValue");
                        //                     setState(() {
                        //                       weddingEditor = newValue ?? '';
                        //                       value.weddingEditor.text = weddingEditor;
                        //                     });

                        //                     // Print the updated value and check if it matches the selected value in the UI
                        //                     print("Updated weddingEditor: $weddingEditor");

                        //                     // Explicitly trigger a rebuild for the widget containing the Text widget
                        //                     WidgetsBinding.instance?.addPostFrameCallback((_) {
                        //                       setState(() {});
                        //                     });
                        //                   },
                        //                   items: <String>[
                        //                     '£300-£600',
                        //                     '£600-£900',
                        //                   ].map<DropdownMenuItem<String>>((String value) {
                        //                     return DropdownMenuItem<String>(
                        //                       value: value,
                        //                       child: Text(value),
                        //                     );
                        //                   }).toList(),
                        //                 ),
                        //               SizedBox(height: 5),
                        //                       Text(
                        //                         'What is the setup:',
                        //                         style: TextStyle(
                        //                           fontSize: 12,
                        //                           fontFamily: 'bold',
                        //                           color: ThemeProvider.blackColor,
                        //                         ),
                        //                       ),
                                      
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                              // Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //            //INSTRUMENT
                              //                  GestureDetector(
                              //                   onTap: () {
                              //                     // Show/hide dropdown when the text field is tapped
                              //                     setState(() {
                              //                       instrumentFive = !instrumentFive;
                              //                     });
                              //                   },
                              //                   child: instrumentFive
                              //                       ? AbsorbPointer(
                              //                           absorbing: true, // Disable text field editing
                              //                           child: TextFormField(
                              //                             controller: value.weddingEditorInstrument,
                              //                             style: TextStyle(
                              //                               fontSize: 14,
                              //                               color: ThemeProvider.blackColor,
                              //                             ),
                              //                              decoration: InputDecoration(
                              //                         border: InputBorder.none, // Remove underline
                              //                       ),
                              //                           ),
                              //                         )
                              //                       : value.individualInfo.weddingEditorInstrument != null
                              //                           ? AbsorbPointer(
                              //                               absorbing: true, // Disable text field editing
                              //                               child: TextFormField(
                              //                                 controller: value.weddingEditorInstrument,
                              //                                 style: TextStyle(
                              //                                   fontSize: 14,
                              //                                   color: ThemeProvider.blackColor,
                              //                                 ),
                              //                                  decoration: InputDecoration(
                              //                         border: InputBorder.none, // Remove underline
                              //                       ),
                              //                               ),
                              //                             )
                              //                           : Text(
                              //                               'Select Instruments',
                              //                               style: TextStyle(
                              //                                 fontSize: 14,
                              //                                 color: ThemeProvider.blackColor,
                              //                               ),
                              //                             ),
                              //                 ),
                              //                 SizedBox(width: 10),
                              //                 if (instrumentFive)
                              //                   DropdownButtonFormField<String>(
                              //                     value: selectedAcusticWeddingValues.isNotEmpty ? selectedAcusticWeddingValues.first : null,
                              //                     onChanged: (String? newValue) {
                              //                       setState(() {
                              //                         if (newValue != null) {
                              //                           // Toggle the selected value
                              //                           if (selectedAcusticWeddingValues.contains(newValue)) {
                              //                             selectedAcusticWeddingValues.remove(newValue);
                              //                           } else {
                              //                             selectedAcusticWeddingValues.add(newValue);
                              //                           }

                              //                           // Update the text field with selected values
                              //                           value.weddingEditorInstrument.text = selectedAcusticWeddingValues.join(', ');
                              //                         }
                              //                       });
                              //                     },
                              //                     items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                              //                       bool isSelected = selectedAcusticWeddingValues.contains(value);

                              //                       return DropdownMenuItem<String>(
                              //                         value: value,
                              //                         child: Row(
                              //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                           children: [
                              //                             Text(value),
                              //                             if (isSelected) Icon(Icons.check, color: Colors.green),
                              //                           ],
                              //                         ),
                              //                       );
                              //                     }).toList(),
                              //                   ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),


                          //   Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Text(
                          //             'Willing to travel'.tr,
                          //             style: const TextStyle(
                          //               fontSize: 14,
                          //               fontFamily: 'bold',
                          //               color: ThemeProvider.blackColor,
                          //               decoration: TextDecoration.none,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 10),
                          //       Row(
                          //         children: [
                          //           Text(
                          //             'Answer ',
                          //             style: TextStyle(
                          //               fontSize: 14,
                          //               color: ThemeProvider.blackColor,
                          //             ),
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {
                          //               // Toggle the visibility of the travel dropdown
                          //               setState(() {
                          //                 showDropdownFive = !showDropdownFive;
                          //               });
                          //             },
                          //             child: showDropdownFive
                          //             ? AbsorbPointer(
                          //               absorbing: true, // Disable text field editing
                          //               child: Container(
                          //                 constraints: BoxConstraints(minWidth: 0, maxWidth: 200), // Set your desired constraints
                          //                 child: TextFormField(
                          //                   controller: value.travelEditor,
                          //                   style: const TextStyle(
                          //                     fontSize: 14,
                          //                     fontFamily: 'bold',
                          //                     color: ThemeProvider.blackColor,
                          //                   ),
                          //                    decoration: InputDecoration(
                          //                             border: InputBorder.none, // Remove underline
                          //                           ),
                          //                 ),
                          //               ),
                          //             )
                          //              : value.individualInfo.travelEditor != null 
                          //                     ? AbsorbPointer(
                          //                         absorbing: true, // Disable text field editing
                          //                         child: TextFormField(
                          //                           controller: value.travelEditor,
                          //                           style: TextStyle(
                          //                             fontSize: 14,
                          //                             color: ThemeProvider.blackColor,
                          //                           ),
                          //                            decoration: InputDecoration(
                          //                             border: InputBorder.none, // Remove underline
                          //                           ),
                          //                         ),
                          //                       )
                          //                     : Text(
                          //                         'Select Option',
                          //                         style: TextStyle(
                          //                           fontSize: 14,
                          //                           color: ThemeProvider.blackColor,
                          //                         ),
                          //                       ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(height: 10),
                          //       if (showDropdownFive)
                          //         DropdownButton<String>(
                          //                 value: travelEditor,
                          //                 onChanged: (String? newValue) {
                          //                   print("Selected value from wedding dropdown: $newValue");
                          //                   setState(() {
                          //                     travelEditor = newValue ?? '';
                          //                     value.travelEditor.text = travelEditor;
                          //                   });

                          //                   // Print the updated value and check if it matches the selected value in the UI
                          //                   print("Updated travel: $travelEditor");

                          //                   // Explicitly trigger a rebuild for the widget containing the Text widget
                          //                   WidgetsBinding.instance?.addPostFrameCallback((_) {
                          //                     setState(() {});
                          //                   });
                          //                 },
                          //                 items: <String>[
                          //                   'YES',
                          //                   'NO',
                          //                 ].map<DropdownMenuItem<String>>((String value) {
                          //                   return DropdownMenuItem<String>(
                          //                     value: value,
                          //                     child: Text(value),
                          //                   );
                          //                 }).toList(),
                          //               ),
                          //     ],
                          //   ),
                          // ),


                            const SizedBox(height: 30),
                            Column(
                              children: List.generate(
                                value.timesList.length,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.circle,
                                          color: ThemeProvider.greenColor,
                                          size: 15),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                value.getDayName(value
                                                    .timesList[index]
                                                    .day as int),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color:
                                                        ThemeProvider.appColor,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Text(
                                              '${value.timesList[index].openTime} - ${value.timesList[index].closeTime}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color:
                                                      ThemeProvider.blackColor,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 23.0,
                                              width: 70,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        ThemeProvider
                                                            .orangeColor),
                                                onPressed: () {
                                                  value.onEditTime(
                                                      value.getDayName(value
                                                          .timesList[index]
                                                          .day as int),
                                                      value.timesList[index]
                                                          .openTime
                                                          .toString(),
                                                      value.timesList[index]
                                                          .closeTime
                                                          .toString());
                                                },
                                                child: Text(
                                                  'Edit'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: 'bold'),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: InkWell(
              onTap: () {
                value.updateIndividual();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                decoration: contentButtonStyle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SUBMIT'.tr,
                      style: const TextStyle(
                          color: ThemeProvider.whiteColor, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
