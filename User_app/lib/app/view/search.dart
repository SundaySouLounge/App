import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/search_controller.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/view/filterdialog.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController calendarController = TextEditingController();

  void showCalendarPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime(DateTime.now().year - 1),
                lastDay: DateTime(DateTime.now().year + 1),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Handle the search button action here
                // You can use calendarController.selectedDay to get the selected date.
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppSearchController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor2,
          body: DefaultTabController(
            length: 1,
            child: TabBarView(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ThemeProvider.appColor,
                      floating: true,
                      pinned: true,
                      toolbarHeight: 70,
                      snap: false,
                      elevation: 0,
                      iconTheme:
                          const IconThemeData(color: ThemeProvider.whiteColor),
                      automaticallyImplyLeading: false,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search'.tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ThemeProvider.whiteColor,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  value.onBack();
                                },
                                child: const Icon(
                                  Icons.close_outlined,
                                  color: ThemeProvider.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: value.searchController,
                                      onChanged: value.searchProducts,
                                      style: const TextStyle(
                                          color: ThemeProvider.blackColor),
                                      decoration: InputDecoration(
                                        hintText:
                                            'Search For Salon, Services.....'
                                                .tr,
                                        prefixIcon: const Icon(Icons.search),
                                        hintStyle: const TextStyle(
                                            color: ThemeProvider.greyColor),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: ThemeProvider.whiteColor,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: ThemeProvider.transparent,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: ThemeProvider.transparent,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: ThemeProvider.whiteColor,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FilterDialog(
                                        switchValue1: value.switchValue1,
                                        switchValue2: value.switchValue2,
                                        switchValue3: value.switchValue3,
                                        switchValue4: value.switchValue4,
                                        selectedDate: value.selectedDate,
                                        onClose: (
                                          bool switchValue1,
                                          bool switchValue2,
                                          bool switchValue3,
                                          bool switchValue4,
                                          DateTime selectedDate,
                                        ) {
                                          value.setFilterValues(
                                            switchValue1,
                                            switchValue2,
                                            switchValue3,
                                            switchValue4,
                                            selectedDate,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.calendar_today),
                                color: ThemeProvider.whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              value.individualList.isNotEmpty
                                  ? _buildTitle('Specialist'.tr)
                                  : const SizedBox(),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      value.individualList.length,
                                      (index) => GestureDetector(
                                            onTap: () {
                                              value.onSpecialist(value
                                                  .individualList[index].id!);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: ThemeProvider
                                                            .appColor,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            SizedBox.fromSize(
                                                          size: const Size
                                                              .fromRadius(25),
                                                          child: FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: FadeInImage(
                                                              image: NetworkImage(
                                                                  '${Environments.apiBaseURL}storage/images/${value.individualList[index].cover.toString()}'),
                                                              placeholder:
                                                                  const AssetImage(
                                                                      "assets/images/placeholder.jpeg"),
                                                              imageErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Image.asset(
                                                                    'assets/images/notfound.png',
                                                                    fit: BoxFit
                                                                        .cover);
                                                              },
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    value.individualList[index]
                                                        .firstName!,
                                                    style: const TextStyle(
                                                        fontFamily: 'semibold',
                                                        color: ThemeProvider
                                                            .whiteColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                              value.salonList.isNotEmpty
                                  ? _buildTitle('Salons'.tr)
                                  : const SizedBox(),
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color:
                                                ThemeProvider.backgroundColor),
                                      ),
                                    ),
                                    child: Column(
                                        children: List.generate(
                                      value.salonList.length,
                                      (index) => Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(40),
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: FadeInImage(
                                                    image: NetworkImage(
                                                        '${Environments.apiBaseURL}storage/images/${value.salonList[index].cover.toString()}'),
                                                    placeholder: const AssetImage(
                                                        "assets/images/placeholder.jpeg"),
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          'assets/images/notfound.png',
                                                          fit: BoxFit.cover);
                                                    },
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 120,
                                                          child: Text(
                                                            value
                                                                .salonList[
                                                                    index]
                                                                .name!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'bold',
                                                                fontSize: 15,
                                                                color: ThemeProvider
                                                                    .whiteColor),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.location_on,
                                                              size: 15,
                                                              color:
                                                                  ThemeProvider
                                                                      .greyColor,
                                                            ),
                                                            Text(
                                                              '${value.salonList[index].distance}KM',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: const TextStyle(
                                                                  color: ThemeProvider
                                                                      .greyColor,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 120,
                                                          child: Text(
                                                            value
                                                                .salonList[
                                                                    index]
                                                                .address!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                color: ThemeProvider
                                                                    .greyColor,
                                                                fontFamily:
                                                                    'bold',
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Row(
                                                    //   children: [
                                                    //     const Icon(
                                                    //       Icons.star,
                                                    //       color: ThemeProvider
                                                    //           .orangeColor,
                                                    //       size: 15,
                                                    //     ),
                                                    //     Padding(
                                                    //       padding:
                                                    //           const EdgeInsets
                                                    //               .symmetric(
                                                    //               horizontal:
                                                    //                   5),
                                                    //       child: Text(
                                                    //         value
                                                    //             .salonList[
                                                    //                 index]
                                                    //             .rating
                                                    //             .toString(),
                                                    //         style: const TextStyle(
                                                    //             color: ThemeProvider
                                                    //                 .greyColor,
                                                    //             fontSize: 12),
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                            width: 120),
                                                        GestureDetector(
                                                          onTap: () {
                                                            value.onServices(
                                                                value
                                                                    .salonList[
                                                                        index]
                                                                    .id!);
                                                          },
                                                          child: Container(
                                                            width: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  ThemeProvider
                                                                      .appColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            child: Center(
                                                              child: Text(
                                                                'Book'.tr,
                                                                style: const TextStyle(
                                                                    color: ThemeProvider
                                                                        .whiteColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(txt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$txt',
            style: const TextStyle(
                fontSize: 14,
                fontFamily: 'bold',
                color: ThemeProvider.whiteColor),
          ),
        ],
      ),
    );
  }
}
