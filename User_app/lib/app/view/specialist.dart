import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_user/app/backend/parse/video_parse.dart';
import 'package:app_user/app/controller/all_categories_controller.dart';
import 'package:app_user/app/controller/categories_list_controller.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/favorite_controller.dart';
import 'package:app_user/app/controller/service_cart_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import 'package:app_user/app/controller/video_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:app_user/app/view/components/event_table.dart';
import 'package:app_user/app/view/videos.dart';

class SpecialistScreen extends StatefulWidget {
  const SpecialistScreen({Key? key}) : super(key: key);

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  int tabID = 1;
  final users = Get.put(CategoriesListController(parser: Get.find()));
  final categories = Get.put(AllCategoriesController(parser: Get.find()));
  final favoriteController = Get.put(FavoriteController(parser: Get.find()));

  List<int> getCategories(SpecialistController value) {
    List<int> entries = [];
    for (var e in value.individualDetails.categories?.split(",") ?? []) {
      var item = int.tryParse(e);
      if (item != null) {
        entries.add(item);
      }
    }
    return entries;
  }

  bool getLiked(int id, int fave) {
    return fave == 1 || favoriteController.isIndividualInFavorites(id);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(EventsCreationController(parser: Get.find()));
    return GetBuilder<SpecialistController>(
      builder: (value) {
        List<int> cates = getCategories(value);
        if (value.individualDetails.uid != null) {
          Get.put<VideoController>(VideoController(
            parser: VideoParser(
                apiService: Get.find(), sharedPreferencesManager: Get.find()),
            id: value.individualDetails.uid!,
          ));
        }
        var liked = getLiked(value.individualDetails.id ?? -1,
            value.individualDetails.isFavorite ?? -1);
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          body: value.apiCalled == false
              ? const Center(
                  child:
                      CircularProgressIndicator(color: ThemeProvider.appColor),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ThemeProvider.backgroundColor,
                      floating: true,
                      pinned: true,
                      toolbarHeight: 350,
                      snap: false,
                      elevation: 0,
                      forceElevated: true,
                      iconTheme:
                          const IconThemeData(color: ThemeProvider.appColor),
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 250,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: FadeInImage(
                                  image: NetworkImage(
                                      //'${Environments.apiBaseURL}storage/images/${ value.individualDetails.background.toString()}'),
                                      '${Environments.apiBaseURL}storage/images/${value.userInfo.cover.toString()}'),
                                  placeholder: const AssetImage(
                                      "assets/images/placeholder.jpeg"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/images/notfound.png',
                                        fit: BoxFit.cover);
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            ThemeProvider.whiteColor,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: ThemeProvider.blackColor,
                                          ),
                                          onPressed: () {
                                            value.onBack();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 110,
                                child: Text(
                                  '${value.userInfo.firstName} ${value.userInfo.lastName}',
                                  style: const TextStyle(
                                    fontFamily: 'bold',
                                    color: ThemeProvider.whiteColor,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 10,
                              //   child: Stack(
                              //     clipBehavior: Clip.none,
                              //     children: [
                              //       Container(
                              //         decoration: BoxDecoration(
                              //           border: Border.all(
                              //               color: ThemeProvider.appColor,
                              //               width: 3),
                              //           borderRadius:
                              //               BorderRadius.circular(100),
                              //         ),
                              //         child: ClipRRect(
                              //           borderRadius:
                              //               BorderRadius.circular(100),
                              //           child: SizedBox.fromSize(
                              //             size: const Size.fromRadius(40),
                              //             child: FadeInImage(
                              //               image: NetworkImage(
                              //                   '${Environments.apiBaseURL}storage/images/${value.userInfo.cover.toString()}'),
                              //               placeholder: const AssetImage(
                              //                   "assets/images/placeholder.jpeg"),
                              //               imageErrorBuilder:
                              //                   (context, error, stackTrace) {
                              //                 return Image.asset(
                              //                     'assets/images/notfound.png',
                              //                     fit: BoxFit.cover);
                              //               },
                              //               fit: BoxFit.cover,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       const Positioned(
                              //         right: 5,
                              //         bottom: 5,
                              //         child: SizedBox(
                              //           height: 15,
                              //           width: 15,
                              //           child: CircleAvatar(
                              //             backgroundColor:
                              //                 ThemeProvider.greenColor,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Positioned(
                              //   bottom: -40,
                              //   left: 10,
                              //   child: Container(
                              //     height: 25,
                              //     width: 60,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5),
                              //       border: Border.all(
                              //           color: ThemeProvider.greenColor),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         'OPEN'.tr,
                              //         style: const TextStyle(
                              //             color: ThemeProvider.greenColor,
                              //             fontSize: 10),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              value.parser.isLogin() == true
                                  ? Positioned(
                                      bottom: 70,
                                      left: 330,
                                      child: IconButton(
                                        icon: liked
                                            ? const Icon(Icons.star)
                                            : const Icon(Icons.star_border),
                                        iconSize: 40,
                                        onPressed: () {
                                          if (liked) {
                                            value.deleteFromFavorites();
                                          } else {
                                            value.updateFavoriteIndividual(value
                                                    .individualDetails
                                                    .isFavorite ??
                                                0);
                                          }
                                          favoriteController.getFavoriteData();
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.only(
                              //           top: 5, bottom: 3),
                              //       child: Text(
                              //         value.salonDetails.address
                              //             .toString(),
                              //         overflow: TextOverflow.ellipsis,
                              //         style: const TextStyle(
                              //             color:
                              //                 ThemeProvider.whiteColor,
                              //             fontSize: 13),
                              //       ),
                              //     ),
                              //     IconButton(
                              //       icon: const Icon(Icons.star_border),
                              //       selectedIcon:
                              //           const Icon(Icons.star),
                              //       isSelected:
                              //           value.salonDetails.isFavorite ==
                              //               1,
                              //       onPressed: () =>
                              //           value.updateFavoriteSalon(),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),

                          // Text(
                          //   value.userInfo.email.toString(),
                          //   style: const TextStyle(
                          //       color: ThemeProvider.greyColor, fontSize: 12),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 5),
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: [
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.star,
                          //             size: 15,
                          //             color:
                          //                 value.individualDetails.rating! >= 1
                          //                     ? ThemeProvider.orangeColor
                          //                     : ThemeProvider.greyColor,
                          //           ),
                          //         ),
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.star,
                          //             size: 15,
                          //             color:
                          //                 value.individualDetails.rating! >= 2
                          //                     ? ThemeProvider.orangeColor
                          //                     : ThemeProvider.greyColor,
                          //           ),
                          //         ),
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.star,
                          //             size: 15,
                          //             color:
                          //                 value.individualDetails.rating! >= 3
                          //                     ? ThemeProvider.orangeColor
                          //                     : ThemeProvider.greyColor,
                          //           ),
                          //         ),
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.star,
                          //             size: 15,
                          //             color:
                          //                 value.individualDetails.rating! >= 4
                          //                     ? ThemeProvider.orangeColor
                          //                     : ThemeProvider.greyColor,
                          //           ),
                          //         ),
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.star,
                          //             size: 15,
                          //             color:
                          //                 value.individualDetails.rating! >= 5
                          //                     ? ThemeProvider.orangeColor
                          //                     : ThemeProvider.greyColor,
                          //           ),
                          //         ),
                          //         TextSpan(
                          //           text:
                          //               ' ( ${value.individualDetails.totalRating} ${'Reviews)'.tr}',
                          //           style: const TextStyle(
                          //               fontSize: 12,
                          //               color: ThemeProvider.greyColor),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          value.parser.haveLoggedIn() == true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Container(
                                        //   width: MediaQuery.of(context)
                                        //               .size
                                        //               .width *
                                        //           0.5 -
                                        //       20,
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 10, vertical: 10),
                                        //   decoration: BoxDecoration(
                                        //     color: ThemeProvider.appColor,
                                        //     borderRadius:
                                        //         BorderRadius.circular(5),
                                        //   ),
                                        //   child: InkWell(
                                        //     onTap: () async {
                                        //       final DateTime? picked =
                                        //           await showDatePicker(
                                        //         context: context,
                                        //         initialDate: DateTime.now(),
                                        //         firstDate: DateTime(2000),
                                        //         lastDate: DateTime(2101),
                                        //       );

                                        //       // Check if the user selected a date and it's not null
                                        //       if (picked != null) {
                                        //         // You can perform your action here, e.g., display the selected date.
                                        //         value.onChat();
                                        //       }
                                        //     },
                                        //     child: Center(
                                        //       child: Text(
                                        //         'Request Availability'.tr,
                                        //         style: const TextStyle(
                                        //           fontSize: 10,
                                        //           fontFamily: 'bold',
                                        //           color:
                                        //               ThemeProvider.whiteColor,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5 -
                                              20,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color:
                                                    ThemeProvider.greenColor),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: InkWell(
                                                  onTap: () => showInfo(
                                                      'An artist becomes verified after two or more venues have rebooked the artist. '),
                                                  child: Center(
                                                    child: Text(
                                                      'VERIFIED'.tr,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: 'bold',
                                                          color: ThemeProvider
                                                              .greenColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5 -
                                              20,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.appColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: InkWell(
                                            onTap: () =>
                                                value.onToSendContract(false),
                                            child: Center(
                                              child: Text(
                                                'Send Contract'.tr,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: 'bold',
                                                    color: ThemeProvider
                                                        .whiteColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Visibility(
                              visible: false,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          value.openWebsite();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: ThemeProvider
                                                .secondaryAppColor
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.language,
                                            size: 20,
                                            color: ThemeProvider.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Website'.tr,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: ThemeProvider.greyColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          value.callIndividual();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.greenColor
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.call,
                                            size: 20,
                                            color: ThemeProvider.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Call'.tr,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: ThemeProvider.greyColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          value.onChat();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.orangeColor
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.chat_outlined,
                                            size: 20,
                                            color: ThemeProvider.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Chat'.tr,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: ThemeProvider.greyColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          value.openMap();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.redColor
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.directions,
                                            size: 20,
                                            color: ThemeProvider.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Direction'.tr,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: ThemeProvider.greyColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          value.share();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.orangeColor
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.share,
                                            size: 20,
                                            color: ThemeProvider.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Share'.tr,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: ThemeProvider.greyColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(56),
                        child: AppBar(
                          titleSpacing: 0,
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: ThemeProvider.backgroundColor,
                          title: DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  controller: value.tabController,
                                  labelColor: ThemeProvider.blackColor,
                                  isScrollable: false,
                                  labelStyle:
                                      const TextStyle(fontFamily: 'regular'),
                                  unselectedLabelColor: ThemeProvider.greyColor,
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  indicator: const UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        width: 2.0,
                                        color: ThemeProvider.appColor),
                                  ),
                                  tabs: [
                                    Tab(
                                      text: 'Basic Info'.tr,
                                    ),
                                    Tab(
                                      text: 'Videos'.tr,
                                    ),
                                    Tab(
                                      text: 'Events'.tr,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              controller: value.tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Photos'.tr,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'bold',
                                                      color: ThemeProvider
                                                          .blackColor,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          // Initialize a PageController to control the PageView
                                                          PageController
                                                              _pageController =
                                                              PageController(
                                                                  initialPage:
                                                                      0);

                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_back,
                                                                          color:
                                                                              Colors.white, // Set the icon color to white
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // Navigate to the previous photo
                                                                          _pageController.previousPage(
                                                                              duration: Duration(milliseconds: 300),
                                                                              curve: Curves.easeInOut);
                                                                        },
                                                                      ),
                                                                      IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_forward,
                                                                          color:
                                                                              Colors.white, // Set the icon color to white
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // Navigate to the next photo
                                                                          _pageController.nextPage(
                                                                              duration: Duration(milliseconds: 300),
                                                                              curve: Curves.easeInOut);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        600, // Adjust the height as needed
                                                                    child: PageView
                                                                        .builder(
                                                                      controller:
                                                                          _pageController,
                                                                      itemCount: value
                                                                          .gallery
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10.0),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child:
                                                                                Image.network(
                                                                              '${Environments.apiBaseURL}storage/images/${value.gallery[index].toString()}',
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      'View All'.tr,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: ThemeProvider
                                                            .greyColor,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                  value.gallery.length,
                                                  (index) => GestureDetector(
                                                    onTap: () {
                                                      // Open the full-screen gallery
                                                      _showFullScreenGallery(
                                                          context,
                                                          value.gallery,
                                                          index);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child:
                                                            SizedBox.fromSize(
                                                          size: const Size
                                                              .fromRadius(35),
                                                          child: FadeInImage(
                                                            image: NetworkImage(
                                                                '${Environments.apiBaseURL}storage/images/${value.gallery[index].toString()}'),
                                                            placeholder:
                                                                const AssetImage(
                                                                    "assets/images/placeholder.jpeg"),
                                                            imageErrorBuilder:
                                                                (context, error,
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
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Genres Covered'.tr,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'bold',
                                                        color: ThemeProvider
                                                            .blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //TO-DO
                                            //show only the correct music genres/categories
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: List.generate(
                                                  cates.length, (index) {
                                                var item = cates[index];
                                                var name2 = categories
                                                    .categoriesList
                                                    .firstWhereOrNull(
                                                        (c) => c.id == item)
                                                    ?.name;

                                                // Check if name2 is null, and if not, add a comma after the Text widget
                                                return name2 == null
                                                    ? const SizedBox()
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            name2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: ThemeProvider
                                                                  .blackColor,
                                                            ),
                                                          ),
                                                          if (index <
                                                              cates.length - 1)
                                                            Text(
                                                                ', '), // Add comma if not the last element
                                                        ],
                                                      );
                                              }),
                                            ),

                                            //BAND SIZE
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Band Size'.tr,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'bold',
                                                        color: ThemeProvider
                                                            .blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              value.individualDetails
                                                  .getMusicGroupType(),
                                              style: const TextStyle(
                                                color: ThemeProvider.blackColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                            //BAND SIZE
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Packages'.tr,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: 'bold',
                                                            color: ThemeProvider
                                                                .blackColor),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                          5), // Adjust the height as needed
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      value.individualDetails
                                                                  .haveShop ==
                                                              1
                                                          ? _buildPackageSubtitle(
                                                              'Solo Package')
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticSoloValue
                                                          .toString()),
                                                      const SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticSoloValueInstrument
                                                          .toString()),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      value.individualDetails
                                                                  .inHome ==
                                                              1
                                                          ? _buildPackageSubtitle(
                                                              'Duo Package')
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticDuoValue
                                                          .toString()),
                                                      const SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticDuoValueInstrument
                                                          .toString()),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      value.individualDetails
                                                                  .haveTrio ==
                                                              1
                                                          ? _buildPackageSubtitle(
                                                              'Trio Package')
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticTrioValue
                                                          .toString()),
                                                      const SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticTrioValueInstrument
                                                          .toString()),
                                                      const SizedBox(height: 5),
                                                      value.individualDetails
                                                                  .haveQuartet ==
                                                              1
                                                          ? _buildPackageSubtitle(
                                                              'Quarter Package')
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticQuarterValue
                                                          .toString()),
                                                      const SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .selectedAcusticQuarterValueInstrument
                                                          .toString()),
                                                      const SizedBox(height: 5),
                                                      value.individualDetails
                                                                      .weddingEditor !=
                                                                  null &&
                                                              value.individualDetails
                                                                      .weddingEditorInstrument !=
                                                                  null
                                                          ? _buildPackageSubtitle(
                                                              'Wedding and Corporation Package')
                                                          : const SizedBox(), // Customize the subtitle text as needed
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .weddingEditor
                                                          .toString()),
                                                      const SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .individualDetails
                                                          .weddingEditorInstrument
                                                          .toString()),
                                                      const SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //ADRRESS
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Address'.tr,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'bold',
                                                        color: ThemeProvider
                                                            .blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Text(
                                                        value.individualDetails
                                                            .address
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: ThemeProvider
                                                                .greyColor),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const WidgetSpan(
                                                            child: Icon(
                                                              Icons
                                                                  .near_me_outlined,
                                                              size: 15,
                                                              color: ThemeProvider
                                                                  .orangeColor,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                ' Get Direction - ${value.getDistance}${'KM'.tr}',
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: ThemeProvider
                                                                    .orangeColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        35),
                                                    child: GoogleMap(
                                                        onMapCreated: value
                                                            .onMapCreated(),
                                                        markers: value.markers,
                                                        initialCameraPosition:
                                                            CameraPosition(
                                                                target: LatLng(
                                                                    value.individualDetails
                                                                            .lat
                                                                        as double,
                                                                    value.individualDetails
                                                                            .lng
                                                                        as double),
                                                                zoom: 5),
                                                        myLocationButtonEnabled:
                                                            false,
                                                        zoomControlsEnabled:
                                                            false),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Opening Hour'.tr,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'bold',
                                                        color: ThemeProvider
                                                            .blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            value.individualDetails
                                                        .travelEditor !=
                                                    null
                                                ? Text(
                                                    value.individualDetails
                                                        .travelEditor
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: ThemeProvider
                                                          .blackColor,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                : SizedBox(),

                                            // value.individualDetails.timing !=
                                            //         null
                                            //     ? Column(
                                            //         children: List.generate(
                                            //         value.individualDetails
                                            //             .timing!.length,
                                            //         (index) => Padding(
                                            //           padding: const EdgeInsets
                                            //               .symmetric(
                                            //               vertical: 5),
                                            //           child: Row(
                                            //             children: [
                                            //               const Icon(
                                            //                   Icons.circle,
                                            //                   color: ThemeProvider
                                            //                       .greenColor,
                                            //                   size: 15),
                                            //               const SizedBox(
                                            //                   width: 10),
                                            //               Expanded(
                                            //                 child: Row(
                                            //                   mainAxisAlignment:
                                            //                       MainAxisAlignment
                                            //                           .spaceBetween,
                                            //                   children: [
                                            //                     Text(
                                            //                       value.dayList[value
                                            //                           .individualDetails
                                            //                           .timing![
                                            //                               index]
                                            //                           .day as int],
                                            //                       style: const TextStyle(
                                            //                           color: ThemeProvider
                                            //                               .greyColor,
                                            //                           fontSize:
                                            //                               12),
                                            //                     ),
                                            //                     Text(
                                            //                       '${value.individualDetails.timing![index].openTime}   :   ${value.individualDetails.timing![index].closeTime}',
                                            //                       style: const TextStyle(
                                            //                           color: ThemeProvider
                                            //                               .blackColor,
                                            //                           fontSize:
                                            //                               12),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ))
                                            //     : const SizedBox(),
                                            //CHANGE HERE
                                            //  Padding(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           vertical: 10),
                                            //   child: Row(
                                            //     children: [
                                            //       Text(
                                            //         'YES'.tr,
                                            //         style: const TextStyle(
                                            //             fontSize: 14,
                                            //             fontFamily: 'semibold',
                                            //             color: ThemeProvider
                                            //                 .blackColor),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'About'.tr,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'bold',
                                                        color: ThemeProvider
                                                            .blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              value.individualDetails.about
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      ThemeProvider.blackColor,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minHeight:
                                            200, // Specify a minimum height
                                        maxWidth: double
                                            .infinity, // Specify a maximum width
                                      ),
                                      child: VideosScreen(
                                          id: value.individualDetails.uid!),
                                    ),
                                  ),
                                ),
                                const SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: TableEvents(),
                                    // child: Column(
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.only(
                                    //           top: 10, left: 10),
                                    //       child: Row(
                                    //         children: [
                                    //           Text(
                                    //             '${'All Reviews '.tr}(${value.ownerReviewsList.length})',
                                    //             style: const TextStyle(
                                    //                 color: ThemeProvider
                                    //                     .greyColor),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     value.ownerReviewsList.isNotEmpty
                                    //         ? Column(
                                    //             children: List.generate(
                                    //             value.ownerReviewsList.length,
                                    //             (index) => Container(
                                    //               margin: const EdgeInsets
                                    //                   .symmetric(vertical: 10),
                                    //               decoration:
                                    //                   const BoxDecoration(
                                    //                 border: Border(
                                    //                     bottom: BorderSide(
                                    //                         color: ThemeProvider
                                    //                             .backgroundColor),
                                    //                     top: BorderSide(
                                    //                         color: ThemeProvider
                                    //                             .backgroundColor)),
                                    //               ),
                                    //               child: Column(
                                    //                 children: [
                                    //                   Padding(
                                    //                     padding:
                                    //                         const EdgeInsets
                                    //                             .symmetric(
                                    //                             horizontal: 10,
                                    //                             vertical: 10),
                                    //                     child: Row(
                                    //                       children: [
                                    //                         ClipRRect(
                                    //                           borderRadius:
                                    //                               BorderRadius
                                    //                                   .circular(
                                    //                                       100),
                                    //                           child: SizedBox
                                    //                               .fromSize(
                                    //                             size: const Size
                                    //                                 .fromRadius(
                                    //                                 30),
                                    //                             child:
                                    //                                 FadeInImage(
                                    //                               image: NetworkImage(
                                    //                                   '${Environments.apiBaseURL}storage/images/${value.ownerReviewsList[index].user!.cover.toString()}'),
                                    //                               placeholder:
                                    //                                   const AssetImage(
                                    //                                       "assets/images/placeholder.jpeg"),
                                    //                               imageErrorBuilder:
                                    //                                   (context,
                                    //                                       error,
                                    //                                       stackTrace) {
                                    //                                 return Image
                                    //                                     .asset(
                                    //                                   'assets/images/notfound.png',
                                    //                                   fit: BoxFit
                                    //                                       .cover,
                                    //                                   height:
                                    //                                       30,
                                    //                                   width: 30,
                                    //                                 );
                                    //                               },
                                    //                               fit: BoxFit
                                    //                                   .cover,
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                         Expanded(
                                    //                           child: Padding(
                                    //                             padding: const EdgeInsets
                                    //                                 .symmetric(
                                    //                                 horizontal:
                                    //                                     10),
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Row(
                                    //                                   mainAxisAlignment:
                                    //                                       MainAxisAlignment
                                    //                                           .spaceBetween,
                                    //                                   children: [
                                    //                                     SizedBox(
                                    //                                       width:
                                    //                                           120,
                                    //                                       child:
                                    //                                           Text(
                                    //                                         '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
                                    //                                         overflow:
                                    //                                             TextOverflow.ellipsis,
                                    //                                         style:
                                    //                                             const TextStyle(fontSize: 15),
                                    //                                       ),
                                    //                                     ),
                                    //                                     Row(
                                    //                                       children: [
                                    //                                         const Icon(
                                    //                                           Icons.star,
                                    //                                           color: ThemeProvider.orangeColor,
                                    //                                           size: 15,
                                    //                                         ),
                                    //                                         SizedBox(
                                    //                                           child: Text(
                                    //                                             value.ownerReviewsList[index].rating.toString(),
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 12),
                                    //                                           ),
                                    //                                         ),
                                    //                                       ],
                                    //                                     ),
                                    //                                   ],
                                    //                                 ),
                                    //                                 Row(
                                    //                                   children: [
                                    //                                     Icon(
                                    //                                         Icons
                                    //                                             .star,
                                    //                                         color: value.ownerReviewsList[index].rating! >= 1
                                    //                                             ? ThemeProvider.orangeColor
                                    //                                             : ThemeProvider.greyColor,
                                    //                                         size: 15),
                                    //                                     Icon(
                                    //                                         Icons
                                    //                                             .star,
                                    //                                         color: value.ownerReviewsList[index].rating! >= 2
                                    //                                             ? ThemeProvider.orangeColor
                                    //                                             : ThemeProvider.greyColor,
                                    //                                         size: 15),
                                    //                                     Icon(
                                    //                                         Icons
                                    //                                             .star,
                                    //                                         color: value.ownerReviewsList[index].rating! >= 3
                                    //                                             ? ThemeProvider.orangeColor
                                    //                                             : ThemeProvider.greyColor,
                                    //                                         size: 15),
                                    //                                     Icon(
                                    //                                         Icons
                                    //                                             .star,
                                    //                                         color: value.ownerReviewsList[index].rating! >= 4
                                    //                                             ? ThemeProvider.orangeColor
                                    //                                             : ThemeProvider.greyColor,
                                    //                                         size: 15),
                                    //                                     Icon(
                                    //                                         Icons
                                    //                                             .star,
                                    //                                         color: value.ownerReviewsList[index].rating! >= 5
                                    //                                             ? ThemeProvider.orangeColor
                                    //                                             : ThemeProvider.greyColor,
                                    //                                         size: 15),
                                    //                                   ],
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                   Padding(
                                    //                     padding:
                                    //                         const EdgeInsets
                                    //                             .symmetric(
                                    //                             horizontal: 10,
                                    //                             vertical: 5),
                                    //                     child: Text(
                                    //                       value
                                    //                           .ownerReviewsList[
                                    //                               index]
                                    //                           .notes!,
                                    //                       style:
                                    //                           const TextStyle(
                                    //                               fontSize: 12),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ))
                                    //         : Column(
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment.center,
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.center,
                                    //             children: [
                                    //               const SizedBox(height: 20),
                                    //               SizedBox(
                                    //                 height: 80,
                                    //                 width: 80,
                                    //                 child: Image.asset(
                                    //                   "assets/images/no-data.png",
                                    //                   fit: BoxFit.cover,
                                    //                 ),
                                    //               ),
                                    //               const SizedBox(
                                    //                 height: 30,
                                    //               ),
                                    //               Center(
                                    //                 child: Text(
                                    //                   'No Found'.tr,
                                    //                   style: const TextStyle(
                                    //                       fontFamily: 'bold'),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //   ],
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar:
              Get.find<ServiceCartController>().totalItemsInCart > 0 &&
                      Get.find<ServiceCartController>().servicesFrom ==
                          'individual'
                  ? SizedBox(
                      height: 70,
                      child: InkWell(
                        onTap: () {
                          value.onCheckout();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: ThemeProvider.appColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value.currencySide == 'left'
                                    ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                    : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                                style: const TextStyle(
                                    color: ThemeProvider.whiteColor),
                              ),
                              Text(
                                'Book Services'.tr,
                                style: const TextStyle(
                                    color: ThemeProvider.whiteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
        );
      },
    );
  }

  Widget _buildSegment() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ThemeProvider.appColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    tabID = 1;
                  });
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: tabID == 1
                        ? ThemeProvider.appColor
                        : Colors.transparent,
                    borderRadius: tabID == 1
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )
                        : BorderRadius.circular(0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Services'.tr, style: segmentText(1)),
                  )),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    tabID = 2;
                  });
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: tabID == 2
                        ? ThemeProvider.appColor
                        : Colors.transparent,
                    borderRadius: tabID == 2
                        ? const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : BorderRadius.circular(0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Packages'.tr, style: segmentText(2)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  segmentText(val) {
    return TextStyle(
        fontSize: 12,
        color:
            tabID == val ? ThemeProvider.whiteColor : ThemeProvider.greyColor);
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

Widget _buildPackageSubtitle(String subtitle) {
  return Text(
    subtitle,
    style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
  );
}

Widget _buildPackageText(String text) {
  // Check if text is null or empty
  if (text == null || text.isEmpty || text == "null") {
    return Container(); // Return an empty container if text is null or empty
  }

  return Container(
    margin: const EdgeInsets.only(left: 10), // Adjust the margin as needed
    child: Text(
      text,
      style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 15),
    ),
  );
}

void _showFullScreenGallery(
    BuildContext context, List<String> gallery, int initialIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Initialize a PageController to control the PageView
      PageController _pageController =
          PageController(initialPage: initialIndex);

      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white, // Set the icon color to white
                    ),
                    onPressed: () {
                      // Navigate to the previous photo
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white, // Set the icon color to white
                    ),
                    onPressed: () {
                      // Navigate to the next photo
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
              Container(
                height: 600, // Adjust the height as needed
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: gallery.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          '${Environments.apiBaseURL}storage/images/${gallery[index].toString()}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
