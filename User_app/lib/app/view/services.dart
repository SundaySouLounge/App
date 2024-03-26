import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_user/app/backend/parse/video_parse.dart';
import 'package:app_user/app/controller/all_categories_controller.dart';
import 'package:app_user/app/controller/favorite_controller.dart';
import 'package:app_user/app/controller/service_cart_controller.dart';
import 'package:app_user/app/controller/services_controller.dart';
import 'package:app_user/app/controller/top_specialist_controller.dart';
import 'package:app_user/app/controller/video_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:app_user/app/view/components/event_table.dart';
import 'package:app_user/app/view/events_creation/events_creation.dart';
import 'package:app_user/app/view/videos.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int tabID = 1;

  final categories = Get.put(AllCategoriesController(parser: Get.find()));
  final favoriteController = Get.put(FavoriteController(parser: Get.find()));
  
  List<int> getCategories(ServicesController value) {
    List<int> entries = [];
    for (var e in value.salonDetails.categories?.split(",") ?? []) {
      var item = int.tryParse(e);
      if (item != null && item < 20) {
        entries.add(item);
      }
    }
    return entries;
  }

  bool getLiked(int id, int fave) {
    return fave == 1 || favoriteController.isSalonInFavorites(id);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesController>(
      builder: (value) {
        var catIds = getCategories(value);
        if (value.salonDetails.uid != null) {
          Get.put<VideoController>(VideoController(
            parser: VideoParser(
                apiService: Get.find(), sharedPreferencesManager: Get.find()),
            id: value.salonDetails.uid!,
          ));
        }
        var liked = getLiked(
            value.salonDetails.id ?? -1, value.salonDetails.isFavorite ?? -1);
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
                      toolbarHeight: 400,
                      snap: false,
                      elevation: 0,
                      forceElevated: true,
                      iconTheme:
                          const IconThemeData(color: ThemeProvider.appColor),
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${Environments.apiBaseURL}storage/images/${value.salonDetails.cover.toString()}'),
                                  fit: BoxFit.cover),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          // CircleAvatar(
                                          //   radius: 20,
                                          //   backgroundColor:
                                          //       ThemeProvider.transparent,
                                          //   child: IconButton(
                                          //     icon: const Icon(
                                          //       Icons.save_alt,
                                          //       color: ThemeProvider.whiteColor,
                                          //     ),
                                          //     onPressed: () {
                                          //       //
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        value.salonDetails.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: ThemeProvider.whiteColor,
                                            fontFamily: 'bold',
                                            fontSize: 17),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 3),
                                            // child: Text(
                                            //   value.salonDetails.address
                                            //       .toString(),
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: const TextStyle(
                                            //       color:
                                            //           ThemeProvider.whiteColor,
                                            //       fontSize: 13),
                                            // ),
                                          ),
                                          value.parser.isLogin() == true
                                              ?  IconButton(
                                                    icon: liked
                                                        ? const Icon(Icons.star)
                                                        : const Icon(
                                                            Icons.star_border),
                                                    iconSize: 40,
                                                    onPressed: () {
                                                      if (liked) {
                                                        value
                                                            .deleteFromFavorites();
                                                      } else {
                                                        value.updateFavoriteSalon(
                                                            value.salonDetails
                                                                    .isFavorite ??
                                                                0);
                                                      }
                                                      favoriteController
                                                          .getFavoriteData();
                                                    },
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          value.parser.haveLoggedIn() == true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
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
                                        //       if (picked != null) {
                                        //         // You can perform your action here, e.g., display the selected date.
                                        //         value.onChat();
                                        //       }
                                        //     },
                                        //     child: Center(
                                        //       child: Text(
                                        //         'Request Availability'.tr,
                                        //         style: const TextStyle(
                                        //             fontSize: 10,
                                        //             fontFamily: 'bold',
                                        //             color: ThemeProvider
                                        //                 .whiteColor),
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
                                                color: ThemeProvider.greenColor),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: InkWell(
                                            onTap: () =>
                                               showInfo(
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
                                                value.onToSendContract(true),
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
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: [
                          //       InkWell(
                          //         onTap: () {
                          //           //
                          //           value.openWebsite();
                          //         },
                          //         child: Column(
                          //           children: [
                          //             const Icon(
                          //               Icons.language,
                          //               size: 40,
                          //               color: ThemeProvider.orangeColor,
                          //             ),
                          //             Text(
                          //               'Website'.tr,
                          //               style: const TextStyle(
                          //                   fontSize: 12,
                          //                   color: ThemeProvider.greyColor),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           //
                          //           value.callSalon();
                          //         },
                          //         child: Column(
                          //           children: [
                          //             const Icon(
                          //               Icons.call,
                          //               size: 40,
                          //               color: ThemeProvider.orangeColor,
                          //             ),
                          //             Text(
                          //               'Call'.tr,
                          //               style: const TextStyle(
                          //                   fontSize: 12,
                          //                   color: ThemeProvider.greyColor),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           //
                          //           value.onChat();
                          //         },
                          //         child: Column(
                          //           children: [
                          //             const Icon(
                          //               Icons.chat_outlined,
                          //               size: 40,
                          //               color: ThemeProvider.orangeColor,
                          //             ),
                          //             Text(
                          //               'Chat'.tr,
                          //               style: const TextStyle(
                          //                   fontSize: 12,
                          //                   color: ThemeProvider.greyColor),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           //
                          //           value.openMap();
                          //         },
                          //         child: Column(
                          //           children: [
                          //             const Icon(
                          //               Icons.directions,
                          //               size: 40,
                          //               color: ThemeProvider.orangeColor,
                          //             ),
                          //             Text(
                          //               'Direction'.tr,
                          //               style: const TextStyle(
                          //                   fontSize: 12,
                          //                   color: ThemeProvider.greyColor),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           ///
                          //           value.share();
                          //         },
                          //         child: Column(
                          //           children: [
                          //             const Icon(
                          //               Icons.offline_share,
                          //               size: 40,
                          //               color: ThemeProvider.orangeColor,
                          //             ),
                          //             Text(
                          //               'Share'.tr,
                          //               style: const TextStyle(
                          //                   fontSize: 12,
                          //                   color: ThemeProvider.greyColor),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 10),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         'Salon Specialist'.tr,
                          //         style: const TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: 'bold',
                          //             color: ThemeProvider.blackColor),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: SingleChildScrollView(
                          //     scrollDirection: Axis.horizontal,
                          //     child: Row(
                          //       children: [
                          //         for (var item in value.specialistList)
                          //           Padding(
                          //             padding: const EdgeInsets.all(10.0),
                          //             child: Column(
                          //               children: [
                          //                 Container(
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(100.0),
                          //                     border: Border.all(
                          //                       width: 2,
                          //                       color: ThemeProvider.appColor,
                          //                     ),
                          //                   ),
                          //                   child: Padding(
                          //                     padding:
                          //                         const EdgeInsets.all(3.0),
                          //                     child: ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(100),
                          //                       child: SizedBox.fromSize(
                          //                         size:
                          //                             const Size.fromRadius(25),
                          //                         child: FadeInImage(
                          //                           image: NetworkImage(
                          //                               '${Environments.apiBaseURL}storage/images/${item.cover}'),
                          //                           placeholder: const AssetImage(
                          //                               "assets/images/placeholder.jpeg"),
                          //                           imageErrorBuilder: (context,
                          //                               error, stackTrace) {
                          //                             return Image.asset(
                          //                                 'assets/images/notfound.png',
                          //                                 fit: BoxFit.cover);
                          //                           },
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       top: 10, bottom: 3),
                          //                   child: Text(
                          //                     '${item.firstName} ${item.lastName}',
                          //                     style: const TextStyle(
                          //                         fontSize: 12,
                          //                         color:
                          //                             ThemeProvider.blackColor),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           )
                          //       ],
                          //     ),
                          //   ),
                          // ),
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
                                    // Tab(
                                    //   text: 'Services'.tr,
                                    // ),
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
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Photos'.tr,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'bold',
                                                      color: ThemeProvider.blackColor,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        // Initialize a PageController to control the PageView
                                                        PageController _pageController = PageController(initialPage: 0);

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
                                                                            curve: Curves.easeInOut);
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
                                                                            curve: Curves.easeInOut);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 600, // Adjust the height as needed
                                                                  child: PageView.builder(
                                                                    controller: _pageController,
                                                                    itemCount: value.gallery.length,
                                                                    itemBuilder: (context, index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets.all(10.0),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          child: Image.network(
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
                                                      color: ThemeProvider.greyColor,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ),
                                                ],
                                              ),
                                            ),
                                            SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: List.generate(
                                                value.gallery.length,
                                                (index) => GestureDetector(
                                                  onTap: () {
                                                    // Open the full-screen gallery
                                                    _showFullScreenGallery(context, value.gallery, index);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: SizedBox.fromSize(
                                                        size: const Size.fromRadius(35),
                                                        child: FadeInImage(
                                                          image: NetworkImage(
                                                              '${Environments.apiBaseURL}storage/images/${value.gallery[index].toString()}'),
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
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),


                                            //GENERES COVERED
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

                                            SizedBox(
                                              width: Get.width,
                                              child: Wrap(
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.start,
                                                children: List.generate(
                                                    catIds.length, (index) {
                                                  var item = catIds[index];
                                                  var name2 = categories
                                                      .categoriesList
                                                      .firstWhereOrNull(
                                                          (c) => c.id == item)
                                                      ?.name;
                                                  return name2 == null
                                                      ? const SizedBox()
                                                      : Text(
                                                          '$name2, ',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                }),
                                              ),
                                            ),

                                            //BANDS SIZE
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
                                              "Dj",
                                              style: const TextStyle(
                                                  color:
                                                      ThemeProvider.blackColor,
                                                  fontSize: 15),
                                            ),
                                            // Text(
                                            //   value.salonDetails.getMusicGroupType(),
                                            //   style: const TextStyle(
                                            //       color:
                                            //           ThemeProvider.blackColor,
                                            //       fontSize: 15),
                                            // ),
                                            //BANDS Packages
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
                                                  SizedBox(
                                                      height:
                                                          5), // Adjust the height as needed
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      value.salonDetails
                                                                      .selectedAcusticSoloValue !=
                                                                  null &&
                                                              value.salonDetails
                                                                      .selectedAcusticSoloValueInstrument !=
                                                                  null
                                                          ? _buildPackageSubtitle(
                                                              'Solo Package')
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticSoloValue
                                                          .toString()),
                                                      SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticSoloValueInstrument
                                                          .toString()),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      value.salonDetails
                                                                      .selectedAcusticDuoValue !=
                                                                  null &&
                                                              value.salonDetails
                                                                      .selectedAcusticDuoValueInstrument !=
                                                                  null
                                                          ? _buildPackageSubtitle(
                                                              'Duo Package')
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticDuoValue
                                                          .toString()),
                                                      SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticDuoValueInstrument
                                                          .toString()),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      value.salonDetails
                                                                      .selectedAcusticTrioValue !=
                                                                  null &&
                                                              value.salonDetails
                                                                      .selectedAcusticTrioValueInstrument !=
                                                                  null
                                                          ? _buildPackageSubtitle(
                                                              'Trio Package')
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticTrioValue
                                                          .toString()),
                                                      SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticTrioValueInstrument
                                                          .toString()),
                                                      SizedBox(height: 5),
                                                      value.salonDetails
                                                                      .selectedAcusticQuarterValue !=
                                                                  null &&
                                                              value.salonDetails
                                                                      .selectedAcusticQuarterValueInstrument !=
                                                                  null
                                                          ? _buildPackageSubtitle(
                                                              'Quarter Package')
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticQuarterValue
                                                          .toString()),
                                                      SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .selectedAcusticQuarterValueInstrument
                                                          .toString()),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as neededù
                                                      value.salonDetails
                                                                      .weddingEditor !=
                                                                  null &&
                                                              value.salonDetails
                                                                      .weddingEditorInstrument !=
                                                                  null
                                                          ? _buildPackageSubtitle(
                                                              'Wedding and Corporation Package')
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .weddingEditor
                                                          .toString()),
                                                      SizedBox(height: 3),
                                                      _buildPackageText(value
                                                          .salonDetails
                                                          .weddingEditorInstrument
                                                          .toString()),
                                                      SizedBox(
                                                          height:
                                                              5), // Adjust the height as needed
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                                        value.salonDetails
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
                                                                '${' Get Direction - '.tr}${value.getDistance}KM',
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
                                                                    value.salonDetails
                                                                            .lat
                                                                        as double,
                                                                    value.salonDetails
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
                                            // Column(
                                            //     children: List.generate(
                                            //   value.salonDetails.timing!.length,
                                            //   (index) => Padding(
                                            //     padding:
                                            //         const EdgeInsets.symmetric(
                                            //             vertical: 5),
                                            //     child: Row(
                                            //       children: [
                                            //         const Icon(Icons.circle,
                                            //             color: ThemeProvider
                                            //                 .greenColor,
                                            //             size: 15),
                                            //         const SizedBox(width: 10),
                                            //         Expanded(
                                            //           child: Row(
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .spaceBetween,
                                            //             children: [
                                            //               Text(
                                            //                 value.dayList[value
                                            //                     .salonDetails
                                            //                     .timing![index]
                                            //                     .day as int],
                                            //                 style: const TextStyle(
                                            //                     color: ThemeProvider
                                            //                         .greyColor,
                                            //                     fontSize: 12),
                                            //               ),
                                            //               Text(
                                            //                 '${value.salonDetails.timing![index].openTime}   :   ${value.salonDetails.timing![index].closeTime}',
                                            //                 style: const TextStyle(
                                            //                     color: ThemeProvider
                                            //                         .blackColor,
                                            //                     fontSize: 12),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // )),

                                            //   CHNAGE HERE
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  value.salonDetails
                                                              .travelEditor !=
                                                          null
                                                      ? Text(
                                                          value.salonDetails
                                                              .travelEditor
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'semibold',
                                                              color: ThemeProvider
                                                                  .blackColor),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),

                                            //ABOUT
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
                                              value.salonDetails.about
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
                                      child: VideosScreen(
                                          id: value.salonDetails.uid!)
                                      //  Column(
                                      // children: [
                                      //   _buildSegment(),
                                      //   if (tabID == 1)
                                      //     for (var item in value.categoriesList)
                                      //       Column(
                                      //         children: [
                                      //           Padding(
                                      //             padding: const EdgeInsets
                                      //                 .symmetric(vertical: 5),
                                      //             child: Row(
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment
                                      //                       .start,
                                      //               children: [
                                      //                 Container(
                                      //                   height: 70,
                                      //                   width: 70,
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                     color: ThemeProvider
                                      //                         .backgroundColor,
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(5),
                                      //                   ),
                                      //                   child: Padding(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                             .all(10.0),
                                      //                     child: ClipRRect(
                                      //                       borderRadius:
                                      //                           BorderRadius
                                      //                               .circular(
                                      //                                   5),
                                      //                       child: SizedBox
                                      //                           .fromSize(
                                      //                         size: const Size
                                      //                             .fromRadius(
                                      //                             20),
                                      //                         child:
                                      //                             FadeInImage(
                                      //                           image: NetworkImage(
                                      //                               '${Environments.apiBaseURL}storage/images/${item.cover}'),
                                      //                           placeholder:
                                      //                               const AssetImage(
                                      //                                   "assets/images/placeholder.jpeg"),
                                      //                           imageErrorBuilder:
                                      //                               (context,
                                      //                                   error,
                                      //                                   stackTrace) {
                                      //                             return Image.asset(
                                      //                                 'assets/images/notfound.png',
                                      //                                 fit: BoxFit
                                      //                                     .cover);
                                      //                           },
                                      //                           fit: BoxFit
                                      //                               .cover,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 const SizedBox(width: 10),
                                      //                 Expanded(
                                      //                   child: Column(
                                      //                     children: [
                                      //                       Padding(
                                      //                         padding:
                                      //                             const EdgeInsets
                                      //                                 .symmetric(
                                      //                                 vertical:
                                      //                                     5),
                                      //                         child: Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .spaceBetween,
                                      //                           children: [
                                      //                             Text(
                                      //                               item.name
                                      //                                   .toString(),
                                      //                               style: const TextStyle(
                                      //                                   color: ThemeProvider
                                      //                                       .blackColor,
                                      //                                   fontSize:
                                      //                                       14),
                                      //                             ),
                                      //                             InkWell(
                                      //                               onTap: () {
                                      //                                 value.onServicesView(
                                      //                                     item.id
                                      //                                         as int,
                                      //                                     item.name
                                      //                                         .toString());
                                      //                               },
                                      //                               child: Text(
                                      //                                 'View'.tr,
                                      //                                 style: const TextStyle(
                                      //                                     color: ThemeProvider
                                      //                                         .appColor,
                                      //                                     fontSize:
                                      //                                         14),
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .spaceBetween,
                                      //                         children: [
                                      //                           Text(
                                      //                             item.services
                                      //                                     .toString() +
                                      //                                 '  Type'
                                      //                                     .tr,
                                      //                             style: const TextStyle(
                                      //                                 color: ThemeProvider
                                      //                                     .greyColor,
                                      //                                 fontSize:
                                      //                                     12),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       )
                                      //   else if (tabID == 2)
                                      //     for (var item in value.packagesList)
                                      //       Padding(
                                      //         padding:
                                      //             const EdgeInsets.symmetric(
                                      //                 vertical: 5),
                                      //         child: Column(
                                      //           children: [
                                      //             Container(
                                      //               height: 150,
                                      //               width: double.infinity,
                                      //               decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(
                                      //                         5),
                                      //               ),
                                      //               child: ClipRRect(
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(
                                      //                         5),
                                      //                 child: FadeInImage(
                                      //                   image: NetworkImage(
                                      //                       '${Environments.apiBaseURL}storage/images/${item.cover}'),
                                      //                   placeholder:
                                      //                       const AssetImage(
                                      //                           "assets/images/placeholder.jpeg"),
                                      //                   imageErrorBuilder:
                                      //                       (context, error,
                                      //                           stackTrace) {
                                      //                     return Image.asset(
                                      //                         'assets/images/notfound.png',
                                      //                         fit:
                                      //                             BoxFit.cover);
                                      //                   },
                                      //                   fit: BoxFit.cover,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 10, bottom: 3),
                                      //               child: Row(
                                      //                 mainAxisAlignment:
                                      //                     MainAxisAlignment
                                      //                         .spaceBetween,
                                      //                 children: [
                                      //                   Expanded(
                                      //                     child: Text(
                                      //                       item.name
                                      //                           .toString(),
                                      //                       maxLines: 1,
                                      //                       overflow:
                                      //                           TextOverflow
                                      //                               .ellipsis,
                                      //                       style: const TextStyle(
                                      //                           color: ThemeProvider
                                      //                               .blackColor,
                                      //                           fontFamily:
                                      //                               'bold'),
                                      //                     ),
                                      //                   ),
                                      //                   InkWell(
                                      //                     onTap: () {
                                      //                       value.onPackagesDetails(
                                      //                           item.id as int,
                                      //                           item.name
                                      //                               .toString());
                                      //                     },
                                      //                     child: Text(
                                      //                       'View'.tr,
                                      //                       style: const TextStyle(
                                      //                           color:
                                      //                               ThemeProvider
                                      //                                   .appColor,
                                      //                           fontFamily:
                                      //                               'bold'),
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //             Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment.start,
                                      //               children: [
                                      //                 Text(
                                      //                   Get.find<ServicesController>()
                                      //                               .currencySide ==
                                      //                           'left'
                                      //                       ? '${Get.find<ServicesController>().currencySymbol}  ${item.price}'
                                      //                       : '  ${item.price}${Get.find<ServicesController>().currencySymbol}',
                                      //                   style: const TextStyle(
                                      //                       color: ThemeProvider
                                      //                           .greyColor,
                                      //                       fontSize: 12),
                                      //                 ),
                                      //               ],
                                      //             )
                                      //           ],
                                      //         ),
                                      //       ),
                                      // ],
                                      // ),
                                      ),
                                ),
                                const SingleChildScrollView(
                                  //   // child: Padding(
                                  //   //   padding: const EdgeInsets.symmetric(
                                  //   //       horizontal: 10, vertical: 10),
                                  //   //   child: value.gallery.isNotEmpty
                                  //   //       ? Column(
                                  //   //           children: [
                                  //   //             GridView.count(
                                  //   //               primary: false,
                                  //   //               crossAxisCount: 2,
                                  //   //               mainAxisSpacing: 10,
                                  //   //               crossAxisSpacing: 10,
                                  //   //               shrinkWrap: true,
                                  //   //               childAspectRatio: 100 / 100,
                                  //   //               padding: EdgeInsets.zero,
                                  //   //               children: List.generate(
                                  //   //                 value.gallery.length,
                                  //   //                 (index) {
                                  //   //                   return Padding(
                                  //   //                     padding:
                                  //   //                         const EdgeInsets.all(
                                  //   //                             10.0),
                                  //   //                     child: ClipRRect(
                                  //   //                       borderRadius:
                                  //   //                           BorderRadius
                                  //   //                               .circular(5),
                                  //   //                       child:
                                  //   //                           SizedBox.fromSize(
                                  //   //                         size: const Size
                                  //   //                             .fromRadius(35),
                                  //   //                         child: FadeInImage(
                                  //   //                           image: NetworkImage(
                                  //   //                               '${Environments.apiBaseURL}storage/images/${value.gallery[index].toString()}'),
                                  //   //                           placeholder:
                                  //   //                               const AssetImage(
                                  //   //                                   "assets/images/placeholder.jpeg"),
                                  //   //                           imageErrorBuilder:
                                  //   //                               (context, error,
                                  //   //                                   stackTrace) {
                                  //   //                             return Image.asset(
                                  //   //                                 'assets/images/notfound.png',
                                  //   //                                 fit: BoxFit
                                  //   //                                     .cover);
                                  //   //                           },
                                  //   //                           fit: BoxFit.cover,
                                  //   //                         ),
                                  //   //                       ),
                                  //   //                     ),
                                  //   //                   );
                                  //   //                 },
                                  //   //               ),
                                  //   //             ),
                                  //   //           ],
                                  //   //         )
                                  //   //       : Column(
                                  //   //           crossAxisAlignment:
                                  //   //               CrossAxisAlignment.center,
                                  //   //           mainAxisAlignment:
                                  //   //               MainAxisAlignment.center,
                                  //   //           children: [
                                  //   //             const SizedBox(height: 20),
                                  //   //             SizedBox(
                                  //   //               height: 80,
                                  //   //               width: 80,
                                  //   //               child: Image.asset(
                                  //   //                 "assets/images/no-data.png",
                                  //   //                 fit: BoxFit.cover,
                                  //   //               ),
                                  //   //             ),
                                  //   //             const SizedBox(
                                  //   //               height: 30,
                                  //   //             ),
                                  //   //             Center(
                                  //   //               child: Text(
                                  //   //                 'No Found'.tr,
                                  //   //                 style: const TextStyle(
                                  //   //                     fontFamily: 'bold'),
                                  //   //               ),
                                  //   //             ),
                                  //   //           ],
                                  //   //         ),
                                  //   // ),

                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: TableEvents(),
                                  ),
                                ),
                                // SingleChildScrollView(
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(
                                //         vertical: 10),
                                //     child: Column(
                                //       children: [
                                //         Padding(
                                //           padding: const EdgeInsets.only(
                                //               top: 10, left: 10),
                                //           child: Row(
                                //             children: [
                                //               Text(
                                //                 '${'All Events '.tr}(${value.ownerReviewsList.length})',
                                //                 style: const TextStyle(
                                //                     color: ThemeProvider
                                //                         .greyColor),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //         value.ownerReviewsList.isNotEmpty
                                //             ? Column(
                                //                 children: List.generate(
                                //                 value.ownerReviewsList.length,
                                //                 (index) => Container(
                                //                   margin: const EdgeInsets
                                //                       .symmetric(vertical: 10),
                                //                   decoration:
                                //                       const BoxDecoration(
                                //                     border: Border(
                                //                         bottom: BorderSide(
                                //                             color: ThemeProvider
                                //                                 .backgroundColor),
                                //                         top: BorderSide(
                                //                             color: ThemeProvider
                                //                                 .backgroundColor)),
                                //                   ),
                                //                   child: Column(
                                //                     children: [
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .symmetric(
                                //                                 horizontal: 10,
                                //                                 vertical: 10),
                                //                         child: Row(
                                //                           children: [
                                //                             ClipRRect(
                                //                               borderRadius:
                                //                                   BorderRadius
                                //                                       .circular(
                                //                                           100),
                                //                               child: SizedBox
                                //                                   .fromSize(
                                //                                 size: const Size
                                //                                     .fromRadius(
                                //                                     30),
                                //                                 child:
                                //                                     FadeInImage(
                                //                                   image: NetworkImage(
                                //                                       '${Environments.apiBaseURL}storage/images/${value.ownerReviewsList[index].user!.cover.toString()}'),
                                //                                   placeholder:
                                //                                       const AssetImage(
                                //                                           "assets/images/placeholder.jpeg"),
                                //                                   imageErrorBuilder:
                                //                                       (context,
                                //                                           error,
                                //                                           stackTrace) {
                                //                                     return Image
                                //                                         .asset(
                                //                                       'assets/images/notfound.png',
                                //                                       fit: BoxFit
                                //                                           .cover,
                                //                                       height:
                                //                                           30,
                                //                                       width: 30,
                                //                                     );
                                //                                   },
                                //                                   fit: BoxFit
                                //                                       .cover,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                             Expanded(
                                //                               child: Padding(
                                //                                 padding: const EdgeInsets
                                //                                     .symmetric(
                                //                                     horizontal:
                                //                                         10),
                                //                                 child: Column(
                                //                                   children: [
                                //                                     Row(
                                //                                       mainAxisAlignment:
                                //                                           MainAxisAlignment
                                //                                               .spaceBetween,
                                //                                       children: [
                                //                                         SizedBox(
                                //                                           width:
                                //                                               120,
                                //                                           child:
                                //                                               Text(
                                //                                             '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
                                //                                             overflow:
                                //                                                 TextOverflow.ellipsis,
                                //                                             style:
                                //                                                 const TextStyle(fontSize: 15),
                                //                                           ),
                                //                                         ),
                                //                                         Row(
                                //                                           children: [
                                //                                             const Icon(
                                //                                               Icons.star,
                                //                                               color: ThemeProvider.orangeColor,
                                //                                               size: 15,
                                //                                             ),
                                //                                             SizedBox(
                                //                                               child: Text(
                                //                                                 value.ownerReviewsList[index].rating.toString(),
                                //                                                 overflow: TextOverflow.ellipsis,
                                //                                                 style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 12),
                                //                                               ),
                                //                                             ),
                                //                                           ],
                                //                                         ),
                                //                                       ],
                                //                                     ),
                                //                                     Row(
                                //                                       children: [
                                //                                         Icon(
                                //                                             Icons
                                //                                                 .star,
                                //                                             color: value.ownerReviewsList[index].rating! >= 1
                                //                                                 ? ThemeProvider.orangeColor
                                //                                                 : ThemeProvider.greyColor,
                                //                                             size: 15),
                                //                                         Icon(
                                //                                             Icons
                                //                                                 .star,
                                //                                             color: value.ownerReviewsList[index].rating! >= 2
                                //                                                 ? ThemeProvider.orangeColor
                                //                                                 : ThemeProvider.greyColor,
                                //                                             size: 15),
                                //                                         Icon(
                                //                                             Icons
                                //                                                 .star,
                                //                                             color: value.ownerReviewsList[index].rating! >= 3
                                //                                                 ? ThemeProvider.orangeColor
                                //                                                 : ThemeProvider.greyColor,
                                //                                             size: 15),
                                //                                         Icon(
                                //                                             Icons
                                //                                                 .star,
                                //                                             color: value.ownerReviewsList[index].rating! >= 4
                                //                                                 ? ThemeProvider.orangeColor
                                //                                                 : ThemeProvider.greyColor,
                                //                                             size: 15),
                                //                                         Icon(
                                //                                             Icons
                                //                                                 .star,
                                //                                             color: value.ownerReviewsList[index].rating! >= 5
                                //                                                 ? ThemeProvider.orangeColor
                                //                                                 : ThemeProvider.greyColor,
                                //                                             size: 15),
                                //                                       ],
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .symmetric(
                                //                                 horizontal: 10,
                                //                                 vertical: 5),
                                //                         child: Text(
                                //                           value
                                //                               .ownerReviewsList[
                                //                                   index]
                                //                               .notes!,
                                //                           style:
                                //                               const TextStyle(
                                //                                   fontSize: 12),
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ))
                                //             : Column(
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.center,
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   const SizedBox(height: 20),
                                //                   SizedBox(
                                //                     height: 80,
                                //                     width: 80,
                                //                     child: Image.asset(
                                //                       "assets/images/no-data.png",
                                //                       fit: BoxFit.cover,
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     height: 30,
                                //                   ),
                                //                   Center(
                                //                     child: Text(
                                //                       'No Found'.tr,
                                //                       style: const TextStyle(
                                //                           fontFamily: 'bold'),
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
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
                      Get.find<ServiceCartController>().servicesFrom == 'salon'
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

void _showFullScreenGallery(BuildContext context, List<String> gallery, int initialIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Initialize a PageController to control the PageView
      PageController _pageController = PageController(initialPage: initialIndex);

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