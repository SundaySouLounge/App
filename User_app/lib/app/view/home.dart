import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/home_controller.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/controller/service_cart_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:app_user/app/view/notification_screen/notification_screen.dart';
import 'package:app_user/app/view/sidemenu.dart';
import 'package:skeletons/skeletons.dart';

class BannerItem {
  final String title;
  final String cover;
  final String value;
  final String type;

  BannerItem({
    required this.title,
    required this.cover,
    required this.value,
    required this.type,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _controller = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  var top = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (value) {
        List<BannerItem> banners = [
          // Manual Banner
          BannerItem(
            title: "Musicians & Tribute Bands",
            cover:
                "assets/images/artist.png", // Replace with the actual image path or URL
            value: "manual_value",
            type: "manual_type",
          ),

          BannerItem(
            title: "DJs & Karaoke",
            cover:
                "assets/images/dj.jpeg", // Replace with the actual image path or URL
            value: "manual_value",
            type: "manual_type",
          ),
        ];
        final item = Get.put(NotificationController(parser: Get.find()));
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor2,
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          drawer: const SideMenuScreen(),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SkeletonLine(
                                style: SkeletonLineStyle(
                                    height: 220,
                                    width: double.infinity,
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 6,
                              lineStyle: SkeletonLineStyle(
                                randomLength: true,
                                height: 20,
                                borderRadius: BorderRadius.circular(8),
                                minLength: MediaQuery.of(context).size.width,
                              )),
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              7,
                              (index) => const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          shape: BoxShape.circle,
                                          width: 60,
                                          height: 60),
                                    ),
                                  )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          children: List.generate(
                              7,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SkeletonLine(
                                      style: SkeletonLineStyle(
                                          height: 170,
                                          width: 250,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              7,
                              (index) => const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          shape: BoxShape.circle,
                                          width: 60,
                                          height: 60),
                                    ),
                                  )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 6,
                              lineStyle: SkeletonLineStyle(
                                randomLength: true,
                                height: 20,
                                borderRadius: BorderRadius.circular(8),
                                minLength: MediaQuery.of(context).size.width,
                              )),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          children: List.generate(
                              7,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SkeletonLine(
                                      style: SkeletonLineStyle(
                                          height: 170,
                                          width: 250,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )),
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: ThemeProvider.appColor,
                      pinned: true,
                      snap: false,
                      floating: true,
                      elevation: 0,
                      toolbarHeight: 70,
                      expandedHeight: 230.0,
                      iconTheme:
                          const IconThemeData(color: ThemeProvider.whiteColor),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          color: ThemeProvider.whiteColor,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      actions: [
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: ThemeProvider.whiteColor,
                              ),
                              onPressed: () {
                                Get.to(const NotificationsScreen());
                              },
                            ),
                            Positioned(
                              right: 13,
                              top: 10,
                              child: GetBuilder<NotificationController>(
                                builder: (controller) {
                                  final notificationCount =
                                      controller.notificationCount;

                                  if (notificationCount > 0) {
                                    return Container(
                                      width: 14, // Adjust the width as needed
                                      height: 14, // Adjust the height as needed
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$notificationCount',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(); // This will hide the red dot when notificationCount is 0
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      flexibleSpace: LayoutBuilder(
                        builder: (ctx, cons) {
                          top = cons.biggest.height;
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(
                              opacity: top <= 80 ? 1.0 : 0.0,
                              duration: const Duration(microseconds: 200),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: InkWell(
                                  onTap: () {
                                    value.onSearch();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Search Bands, Artist and more'.tr,
                                          style: const TextStyle(
                                              color: ThemeProvider.greyColor,
                                              fontSize: 16),
                                        ),
                                        const Icon(
                                          Icons.search_outlined,
                                          color: ThemeProvider.greyColor,
                                          size: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            background: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/elit.jpg'),
                                    fit: BoxFit.cover),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5),
                                    // InkWell(
                                    //   onTap: () {
                                    //     Get.toNamed(
                                    //         AppRouter.getFindLocationRoutes());
                                    //   },
                                    //   child: Text(
                                    //     value.title,
                                    //     textAlign: TextAlign.center,
                                    //     style: const TextStyle(
                                    //         color: Colors.white,
                                    //         fontFamily: 'bold',
                                    //         fontSize: 14),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 5),
                                    // Text(
                                    //   'Find and book best services'.tr,
                                    //   style: const TextStyle(
                                    //       color: Colors.white,
                                    //       fontFamily: 'bold',
                                    //       fontSize: 22),
                                    // ),
                                    const SizedBox(height: 130),
                                    InkWell(
                                      onTap: () {
                                        value.onSearch();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Search Bands or DJ name'.tr,
                                              style: const TextStyle(
                                                  color:
                                                      ThemeProvider.greyColor,
                                                  fontSize: 16),
                                            ),
                                            const Icon(
                                              Icons.search_outlined,
                                              color: ThemeProvider.greyColor,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: value.haveData == true
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                              // Your options here
                                              ),
                                          items: List.generate(
                                            banners.length,
                                            (index) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // Update the selectedIndex based on the clicked index
                                                  selectedIndex = index;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: index ==
                                                            selectedIndex
                                                        ? Colors.yellowAccent
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Adjust the radius as needed
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            SizedBox(
                                                              height: 170,
                                                              width: double
                                                                  .infinity,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    FadeInImage(
                                                                  image: AssetImage(
                                                                      banners[index]
                                                                          .cover),
                                                                  placeholder:
                                                                      const AssetImage(
                                                                          "assets/images/placeholder.jpeg"),
                                                                  imageErrorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                      'assets/images/notfound.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    );
                                                                  },
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 50,
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                color: ThemeProvider
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    banners[index]
                                                                        .title,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: ThemeProvider
                                                                          .whiteColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      
//START NEW ARTIST
                                      Visibility(
                                        visible: selectedIndex == 0 ||
                                            selectedIndex == 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Top Salon'.tr,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'bold',
                                                  color:
                                                      ThemeProvider.whiteColor),
                                            ),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .whiteColor),
                                                ),
                                                onPressed: () {
                                                  value.onAllSpecialist();
                                                },
                                                child: Text(
                                                  'View all'.tr,
                                                  style: const TextStyle(
                                                      color: ThemeProvider
                                                          .appColor,
                                                      fontSize: 12),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: selectedIndex == 0 ||
                                            selectedIndex == 3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  for (var item in (value
                                                          .individualList
                                                          .toList()
                                                        ..shuffle())
                                                      .take(7))
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          value.onSpecialist(
                                                            item.id!,
                                                          );
                                                        },
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 100,
                                                              width: 250,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                child:
                                                                    FadeInImage(
                                                                  image: NetworkImage(
                                                                      '${Environments.apiBaseURL}storage/images/${item.userInfo?.cover.toString()}'),
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
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 250,
                                                              child: Stack(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  item.userInfo!.firstName.toString() + ' ' + item.userInfo!.lastName.toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor),
                                                                                ),
                                                                              ),
                                                                              // Row(
                                                                              //   children: [
                                                                              //     const Icon(
                                                                              //       Icons.star,
                                                                              //       color: Colors.orange,
                                                                              //       size: 17,
                                                                              //     ),
                                                                              //     const SizedBox(width: 5),
                                                                              //     Text(
                                                                              //       item.rating.toString(),
                                                                              //       style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor),
                                                                              //     )
                                                                              //   ],
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 15),
                                                                          // child:
                                                                          //     Text(
                                                                          //   item.userInfo!.!.length > 15
                                                                          //       ? '${item.address!.substring(0, 27)}...'
                                                                          //       : item.address.toString(),
                                                                          //   overflow:
                                                                          //       TextOverflow.ellipsis,
                                                                          //   style: const TextStyle(
                                                                          //       fontSize: 12,
                                                                          //       color: ThemeProvider.greyColor),
                                                                          // ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      width: 60,
                                                                      decoration: const BoxDecoration(
                                                                          color: ThemeProvider
                                                                              .appColor,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10))),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'Book'.tr,
                                                                            style:
                                                                                const TextStyle(fontSize: 10, color: Colors.white),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Visibility(
                                        visible: selectedIndex == 1 ||
                                            selectedIndex == 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'New DJs'.tr,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'bold',
                                                  color:
                                                      ThemeProvider.whiteColor),
                                            ),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .whiteColor),
                                                ),
                                                onPressed: () {
                                                  value.onAllOffers();
                                                },
                                                child: Text(
                                                  'View all'.tr,
                                                  style: const TextStyle(
                                                      color: ThemeProvider
                                                          .appColor,
                                                      fontSize: 12),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: selectedIndex == 1 ||
                                            selectedIndex == 2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  for (var item in (value
                                                          .salonList
                                                          .toList()
                                                        ..shuffle())
                                                      .take(7))
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          value.onServices(
                                                              item.id!);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 100,
                                                              width: 250,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                child:
                                                                    FadeInImage(
                                                                  image: NetworkImage(
                                                                      '${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
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
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 250,
                                                              child: Stack(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  item.name.toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor),
                                                                                ),
                                                                              ),
                                                                              // Row(
                                                                              //   children: [
                                                                              //     const Icon(
                                                                              //       Icons.star,
                                                                              //       color: Colors.orange,
                                                                              //       size: 17,
                                                                              //     ),
                                                                              //     const SizedBox(width: 5),
                                                                              //     Text(
                                                                              //       item.rating.toString(),
                                                                              //       style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor),
                                                                              //     )
                                                                              //   ],
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 15),
                                                                          child:
                                                                              Text(
                                                                            item.address!.length > 15
                                                                                ? '${item.address!.substring(0, 27)}...'
                                                                                : item.address.toString(),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontSize: 12, color: ThemeProvider.greyColor),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      width: 60,
                                                                      decoration: const BoxDecoration(
                                                                          color: ThemeProvider
                                                                              .appColor,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10))),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'Book'.tr,
                                                                            style:
                                                                                const TextStyle(fontSize: 10, color: Colors.white),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //END NEW ARTIST

                                      /// END BANNER
                                      Row(
                                        children: [
                                          Text(
                                            'Elite Artist'.tr,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'bold',
                                              color: ThemeProvider.whiteColor,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Show a toast or perform any action when the IconButton is clicked
                                              showInfo(
                                                  'The ranking of a top artist is determined by the quantity of bookings in their calendar. The greater the number of bookings in the artists diary, the higher their position on the Top Artist list they appear.');
                                            },
                                            icon: Icon(Icons.help_outline,
                                                color: Colors.white),
                                          ),
                                          Spacer(),
                                          // TextButton(
                                          //   style: TextButton.styleFrom(
                                          //     textStyle: const TextStyle(
                                          //       fontSize: 14,
                                          //       color: ThemeProvider.blackColor,
                                          //     ),
                                          //   ),
                                          //   onPressed: () {
                                          //     value.onAllSpecialist();
                                          //   },
                                          //   child: Text(
                                          //     'View all'.tr,
                                          //     style: const TextStyle(color: ThemeProvider.appColor, fontSize: 12),
                                          //   ),
                                          // ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            //BEST ARTIST

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                   for (var item in (value
                                                          .individualList
                                                          .toList()
                                                        ..shuffle())
                                                      .take(4))
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          value.onSpecialist(
                                                            item.id!,
                                                          );
                                                        },
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 100,
                                                              width: 250,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                child:
                                                                    FadeInImage(
                                                                  image: NetworkImage(
                                                                      '${Environments.apiBaseURL}storage/images/${item.userInfo?.cover.toString()}'),
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
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 250,
                                                              child: Stack(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  item.userInfo!.firstName.toString() + ' ' + item.userInfo!.lastName.toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 15),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      width: 60,
                                                                      decoration: const BoxDecoration(
                                                                          color: ThemeProvider
                                                                              .appColor,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10))),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'Book'.tr,
                                                                            style:
                                                                                const TextStyle(fontSize: 10, color: Colors.white),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  for (var item in (value
                                                          .salonList
                                                          .toList()
                                                        ..shuffle())
                                                      .take(2))
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          value.onServices(
                                                            item.id!,
                                                          );
                                                        },
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 100,
                                                              width: 250,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                child:
                                                                    FadeInImage(
                                                                  image: NetworkImage(
                                                                      '${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
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
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 250,
                                                              child: Stack(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  item.name.toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(fontSize: 15, color: ThemeProvider.whiteColor),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 15),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      width: 60,
                                                                      decoration: const BoxDecoration(
                                                                          color: ThemeProvider
                                                                              .appColor,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10))),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'Book'.tr,
                                                                            style:
                                                                                const TextStyle(fontSize: 10, color: Colors.white),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      //START MUSIC GENERES
                                      Visibility(
                                        visible: selectedIndex == 0 ||
                                            selectedIndex == 3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Top Categories'.tr,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'bold',
                                                    color: ThemeProvider
                                                        .whiteColor),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .whiteColor),
                                                ),
                                                onPressed: () {
                                                  value.onAllCategories();
                                                },
                                                child: Text(
                                                  'View all'.tr,
                                                  style: const TextStyle(
                                                      color: ThemeProvider
                                                          .appColor,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: selectedIndex == 0 ||
                                            selectedIndex == 3,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (var item
                                                  in value.categoriesList)
                                                if (item.extraField != 'dj' &&
                                                    item.extraField == null)
                                                  InkWell(
                                                    //OLD METHTOD
                                                    // onTap: () {
                                                    //   value.onCategoriesList(
                                                    //       item.id as int);
                                                    // },

                                                    //NEW METHOD
                                                    onTap: () {
                                                      value.onAllCategories();
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: SizedBox
                                                                .fromSize(
                                                              size: const Size
                                                                  .fromRadius(
                                                                  30),
                                                              child:
                                                                  FadeInImage(
                                                                image: NetworkImage(
                                                                    '${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
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
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  item.name!.length >
                                                                          15
                                                                      ? '${item.name!.substring(0, 15)}...'
                                                                      : item
                                                                          .name
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: ThemeProvider
                                                                          .greyColor,
                                                                      fontFamily:
                                                                          'bold'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //END MUSIC GENERES

                                      //1-2 START

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: selectedIndex == 1 ||
                                            selectedIndex == 2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'DJ Genres'.tr,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'bold',
                                                    color: ThemeProvider
                                                        .whiteColor),
                                              ),

                                              // TextButton(
                                              //   style: TextButton.styleFrom(
                                              //     textStyle: const TextStyle(
                                              //         fontSize: 14,
                                              //         color: ThemeProvider
                                              //             .whiteColor),
                                              //   ),
                                              //   onPressed: () {
                                              //     value.onAllCategories();
                                              //   },
                                              //   child: Text(
                                              //     'View all'.tr,
                                              //     style: const TextStyle(
                                              //         color:
                                              //             ThemeProvider.appColor,
                                              //         fontSize: 12),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: selectedIndex == 1 ||
                                            selectedIndex == 2,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (var item
                                                  in value.categoriesList)
                                                if (item.extraField == 'dj' &&
                                                    item.extraField != null)
                                                  InkWell(
                                                    //OLD METHTOD
                                                    onTap: () {
                                                      value.onCategoriesList(
                                                          item.id as int);
                                                    },
                                                    //NEW METHOD
                                                    //  onTap: () {
                                                    // value.onAllCategories();
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: SizedBox
                                                                .fromSize(
                                                              size: const Size
                                                                  .fromRadius(
                                                                  30),
                                                              child:
                                                                  FadeInImage(
                                                                image: NetworkImage(
                                                                    '${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
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
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  item.name!.length >
                                                                          15
                                                                      ? '${item.name!.substring(0, 15)}...'
                                                                      : item
                                                                          .name
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: ThemeProvider
                                                                          .greyColor,
                                                                      fontFamily:
                                                                          'bold'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //1-2 END
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //       'Top Products'.tr,
                                      //       style: const TextStyle(
                                      //           fontSize: 14,
                                      //           fontFamily: 'bold'),
                                      //     ),
                                      //     TextButton(
                                      //         style: TextButton.styleFrom(
                                      //           textStyle: const TextStyle(
                                      //               fontSize: 14,
                                      //               color: ThemeProvider
                                      //                   .blackColor),
                                      //         ),
                                      //         onPressed: () {
                                      //           value.onTopProducts();
                                      //         },
                                      //         child: Text(
                                      //           'View all'.tr,
                                      //           style: const TextStyle(
                                      //               color:
                                      //                   ThemeProvider.appColor,
                                      //               fontSize: 12),
                                      //         ))
                                      //   ],
                                      // ),
                                      // const SizedBox(
                                      //   height: 10,
                                      // ),
                                      // SingleChildScrollView(
                                      //   scrollDirection: Axis.horizontal,
                                      //   child: Container(
                                      //     padding:
                                      //         const EdgeInsets.only(left: 16),
                                      //     margin: const EdgeInsets.symmetric(
                                      //         vertical: 8),
                                      //     child: Row(
                                      //       children: List.generate(
                                      //         value.productsList.length,
                                      //         (i) {
                                      //           return GestureDetector(
                                      //             onTap: () {
                                      //               value.onProduct(
                                      //                 value.productsList[i].id
                                      //                     as int,
                                      //               );
                                      //             },
                                      //             child: Container(
                                      //               clipBehavior:
                                      //                   Clip.antiAlias,
                                      //               margin:
                                      //                   const EdgeInsets.only(
                                      //                       right: 10,
                                      //                       bottom: 16),
                                      //               width: 150,
                                      //               decoration: BoxDecoration(
                                      //                 color: ThemeProvider
                                      //                     .whiteColor,
                                      //                 borderRadius:
                                      //                     const BorderRadius
                                      //                         .all(
                                      //                   Radius.circular(8),
                                      //                 ),
                                      //                 boxShadow: [
                                      //                   BoxShadow(
                                      //                       color: ThemeProvider
                                      //                           .blackColor
                                      //                           .withOpacity(
                                      //                               0.2),
                                      //                       offset:
                                      //                           const Offset(
                                      //                               0, 1),
                                      //                       blurRadius: 3),
                                      //                 ],
                                      //               ),
                                      //               child: Column(
                                      //                 children: [
                                      //                   SizedBox(
                                      //                     height: 120,
                                      //                     width:
                                      //                         double.infinity,
                                      //                     child: Stack(
                                      //                       clipBehavior:
                                      //                           Clip.none,
                                      //                       children: [
                                      //                         FadeInImage(
                                      //                           image: NetworkImage(
                                      //                               '${Environments.apiBaseURL}storage/images/${value.productsList[i].cover.toString()}'),
                                      //                           placeholder:
                                      //                               const AssetImage(
                                      //                                   "assets/images/placeholder.jpeg"),
                                      //                           imageErrorBuilder:
                                      //                               (context,
                                      //                                   error,
                                      //                                   stackTrace) {
                                      //                             return Image.asset(
                                      //                                 'assets/images/notfound.png',
                                      //                                 width: double
                                      //                                     .infinity,
                                      //                                 height:
                                      //                                     120,
                                      //                                 fit: BoxFit
                                      //                                     .cover);
                                      //                           },
                                      //                           width: double
                                      //                               .infinity,
                                      //                           height: 120,
                                      //                           fit: BoxFit
                                      //                               .cover,
                                      //                         ),
                                      //                         Positioned(
                                      //                           top: 8,
                                      //                           left: 0,
                                      //                           child:
                                      //                               Container(
                                      //                             padding: const EdgeInsets
                                      //                                 .symmetric(
                                      //                                 horizontal:
                                      //                                     4),
                                      //                             color: ThemeProvider
                                      //                                 .secondaryAppColor
                                      //                                 .withOpacity(
                                      //                                     .2),
                                      //                             child: Text(
                                      //                               '${value.productsList[i].discount} %',
                                      //                               style: const TextStyle(
                                      //                                   color: ThemeProvider
                                      //                                       .secondaryAppColor,
                                      //                                   fontFamily:
                                      //                                       'medium',
                                      //                                   fontSize:
                                      //                                       12),
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                   Container(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                             .symmetric(
                                      //                             vertical: 8,
                                      //                             horizontal:
                                      //                                 8),
                                      //                     child: Column(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment
                                      //                               .center,
                                      //                       children: [
                                      //                         Text(
                                      //                           value
                                      //                               .productsList[
                                      //                                   i]
                                      //                               .name
                                      //                               .toString(),
                                      //                           overflow:
                                      //                               TextOverflow
                                      //                                   .ellipsis,
                                      //                           textAlign:
                                      //                               TextAlign
                                      //                                   .center,
                                      //                           style: const TextStyle(
                                      //                               color: ThemeProvider
                                      //                                   .blackColor,
                                      //                               fontFamily:
                                      //                                   'medium',
                                      //                               fontSize:
                                      //                                   14),
                                      //                         ),
                                      //                         const SizedBox(
                                      //                             height: 6),
                                      //                         Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .center,
                                      //                           children: [
                                      //                             Icon(
                                      //                                 Icons
                                      //                                     .star,
                                      //                                 color: value.productsList[i].rating! >= 1
                                      //                                     ? ThemeProvider
                                      //                                         .orangeColor
                                      //                                     : ThemeProvider
                                      //                                         .greyColor,
                                      //                                 size: 12),
                                      //                             Icon(
                                      //                                 Icons
                                      //                                     .star,
                                      //                                 color: value.productsList[i].rating! >= 2
                                      //                                     ? ThemeProvider
                                      //                                         .orangeColor
                                      //                                     : ThemeProvider
                                      //                                         .greyColor,
                                      //                                 size: 12),
                                      //                             Icon(
                                      //                                 Icons
                                      //                                     .star,
                                      //                                 color: value.productsList[i].rating! >= 3
                                      //                                     ? ThemeProvider
                                      //                                         .orangeColor
                                      //                                     : ThemeProvider
                                      //                                         .greyColor,
                                      //                                 size: 12),
                                      //                             Icon(
                                      //                                 Icons
                                      //                                     .star,
                                      //                                 color: value.productsList[i].rating! >= 4
                                      //                                     ? ThemeProvider
                                      //                                         .orangeColor
                                      //                                     : ThemeProvider
                                      //                                         .greyColor,
                                      //                                 size: 12),
                                      //                             Icon(
                                      //                                 Icons
                                      //                                     .star,
                                      //                                 color: value.productsList[i].rating! >= 5
                                      //                                     ? ThemeProvider
                                      //                                         .orangeColor
                                      //                                     : ThemeProvider
                                      //                                         .greyColor,
                                      //                                 size: 12),
                                      //                             const SizedBox(
                                      //                                 width: 6),
                                      //                             Text(
                                      //                               value
                                      //                                   .productsList[
                                      //                                       i]
                                      //                                   .totalRating
                                      //                                   .toString(),
                                      //                               style: const TextStyle(
                                      //                                   color: ThemeProvider
                                      //                                       .blackColor,
                                      //                                   fontFamily:
                                      //                                       'medium',
                                      //                                   fontSize:
                                      //                                       12),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         const SizedBox(
                                      //                             height: 6),
                                      //                         Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .center,
                                      //                           crossAxisAlignment:
                                      //                               CrossAxisAlignment
                                      //                                   .center,
                                      //                           children: [
                                      //                             Text(
                                      //                               value.currencySide ==
                                      //                                       'left'
                                      //                                   ? '${value.currencySymbol}${value.productsList[i].originalPrice}'
                                      //                                   : '${value.productsList[i].originalPrice}${value.currencySymbol}',
                                      //                               style: const TextStyle(
                                      //                                   decoration:
                                      //                                       TextDecoration
                                      //                                           .lineThrough,
                                      //                                   color: ThemeProvider
                                      //                                       .greyColor,
                                      //                                   fontSize:
                                      //                                       12),
                                      //                             ),
                                      //                             Text(
                                      //                               value.currencySide ==
                                      //                                       'left'
                                      //                                   ? '${value.currencySymbol}${value.productsList[i].sellPrice}'
                                      //                                   : '${value.productsList[i].sellPrice}${value.currencySymbol}',
                                      //                               style: const TextStyle(
                                      //                                   color: ThemeProvider
                                      //                                       .appColor,
                                      //                                   fontFamily:
                                      //                                       'bold',
                                      //                                   fontSize:
                                      //                                       12),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         const SizedBox(
                                      //                             height: 6),
                                      //                         value.productsList[i]
                                      //                                     .quantity ==
                                      //                                 0
                                      //                             ? SizedBox(
                                      //                                 width:
                                      //                                     100,
                                      //                                 height:
                                      //                                     26,
                                      //                                 child:
                                      //                                     ElevatedButton(
                                      //                                   onPressed:
                                      //                                       () {
                                      //                                     value.addToCart(
                                      //                                         i);
                                      //                                   },
                                      //                                   style: ElevatedButton.styleFrom(
                                      //                                       backgroundColor: ThemeProvider.appColor,
                                      //                                       shadowColor: ThemeProvider.blackColor,
                                      //                                       foregroundColor: ThemeProvider.whiteColor,
                                      //                                       elevation: 3,
                                      //                                       shape: (RoundedRectangleBorder(
                                      //                                         borderRadius: BorderRadius.circular(6),
                                      //                                       )),
                                      //                                       padding: const EdgeInsets.all(0)),
                                      //                                   child:
                                      //                                       Text(
                                      //                                     'ADD'
                                      //                                         .tr,
                                      //                                     style: const TextStyle(
                                      //                                         letterSpacing: 1,
                                      //                                         fontSize: 12,
                                      //                                         color: ThemeProvider.whiteColor,
                                      //                                         fontFamily: 'bold'),
                                      //                                   ),
                                      //                                 ),
                                      //                               )
                                      //                             : Row(
                                      //                                 mainAxisAlignment:
                                      //                                     MainAxisAlignment
                                      //                                         .center,
                                      //                                 children: [
                                      //                                   Row(
                                      //                                     children: [
                                      //                                       SizedBox(
                                      //                                         width: 24,
                                      //                                         height: 24,
                                      //                                         child: ElevatedButton(
                                      //                                             onPressed: () {
                                      //                                               value.updateProductQuantityRemove(i);
                                      //                                             },
                                      //                                             style: ElevatedButton.styleFrom(
                                      //                                                 backgroundColor: ThemeProvider.redColor,
                                      //                                                 shadowColor: ThemeProvider.blackColor,
                                      //                                                 foregroundColor: ThemeProvider.whiteColor,
                                      //                                                 elevation: 3,
                                      //                                                 shape: (RoundedRectangleBorder(
                                      //                                                   borderRadius: BorderRadius.circular(50),
                                      //                                                 )),
                                      //                                                 padding: const EdgeInsets.all(0)),
                                      //                                             child: const Icon(Icons.remove)),
                                      //                                       ),
                                      //                                       Container(
                                      //                                         padding: const EdgeInsets.symmetric(horizontal: 10),
                                      //                                         child: Text(
                                      //                                           value.productsList[i].quantity.toString(),
                                      //                                           style: const TextStyle(fontSize: 14, fontFamily: 'medium', color: ThemeProvider.blackColor),
                                      //                                         ),
                                      //                                       ),
                                      //                                       SizedBox(
                                      //                                         width: 24,
                                      //                                         height: 24,
                                      //                                         child: ElevatedButton(
                                      //                                             onPressed: () {
                                      //                                               value.updateProductQuantity(i);
                                      //                                             },
                                      //                                             style: ElevatedButton.styleFrom(
                                      //                                                 backgroundColor: ThemeProvider.greenColor,
                                      //                                                 shadowColor: ThemeProvider.blackColor,
                                      //                                                 foregroundColor: ThemeProvider.whiteColor,
                                      //                                                 elevation: 3,
                                      //                                                 shape: (RoundedRectangleBorder(
                                      //                                                   borderRadius: BorderRadius.circular(50),
                                      //                                                 )),
                                      //                                                 padding: const EdgeInsets.all(0)),
                                      //                                             child: const Icon(Icons.add)),
                                      //                                       )
                                      //                                     ],
                                      //                                   ),
                                      //                                 ],
                                      //                               ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           );
                                      //         },
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Image.asset(
                                          "assets/images/no-data.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                        child: Text(
                                          'No Data Found Near You!'.tr,
                                          style: const TextStyle(
                                              fontFamily: 'bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
          bottomNavigationBar:
              Get.find<ServiceCartController>().totalItemsInCart > 0
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
}


