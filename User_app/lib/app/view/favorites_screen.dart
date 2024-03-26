import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/favorite_controller.dart';
import 'package:app_user/app/controller/service_cart_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/view/sidemenu.dart';
import 'package:skeletons/skeletons.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final CarouselController _controller = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var top = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(
      builder: (value) {
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
                      const SizedBox(height: 32),
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
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 32),
                            child: value.haveData == true
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Favorites'.tr,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: 'bold',
                                                  color:
                                                      ThemeProvider.whiteColor),
                                            ),
                                          
                                          ],
                                        ),
                                      ),
                                     
                                      const SizedBox(
                                        height: 20,
                                      ),
                                     SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: Column(
                                          children: [
                                            for (var item in value.individualList)
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                margin:
                                                    const EdgeInsets.symmetric(vertical: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: ThemeProvider.whiteColor,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: ThemeProvider.greyColor,
                                                        blurRadius: 5.0,
                                                        offset: Offset(0.7, 2.0)),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(5),
                                                          child: SizedBox.fromSize(
                                                            size: const Size.fromRadius(40),
                                                            child: FadeInImage(
                                                              image: NetworkImage(
                                                                  '${Environments.apiBaseURL}storage/images/${item.userInfo?.cover.toString()}'),
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
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                    fontFamily: 'bold',
                                                                    fontSize: 14),
                                                              ),
                                                              
                                                          
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(top: 5),
                                                         
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 10, vertical: 10),
                                                          decoration: BoxDecoration(
                                                            color: ThemeProvider.appColor,
                                                            borderRadius:
                                                                BorderRadius.circular(5),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              value.onSpecialist(
                                                                item.id!,
                                                              );
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                'Continue'.tr,
                                                                style: const TextStyle(
                                                                    fontSize: 10,
                                                                    fontFamily: 'bold',
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
                                          ],
                                        ),
                                      ),
                                    ),

                                     //DJS

                                   SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: Column(
                                          children: [
                                           for (var item
                                                    in value.salonList)
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                margin:
                                                    const EdgeInsets.symmetric(vertical: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: ThemeProvider.whiteColor,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: ThemeProvider.greyColor,
                                                        blurRadius: 5.0,
                                                        offset: Offset(0.7, 2.0)),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(5),
                                                          child: SizedBox.fromSize(
                                                            size: const Size.fromRadius(40),
                                                            child: FadeInImage(
                                                              image: NetworkImage(
                                                                  '${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
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
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                item.name.toString(),
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                    fontFamily: 'bold',
                                                                    fontSize: 14),
                                                              ),
                                                              
                                                          
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(top: 5),
                                                          
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 10, vertical: 10),
                                                          decoration: BoxDecoration(
                                                            color: ThemeProvider.appColor,
                                                            borderRadius:
                                                                BorderRadius.circular(5),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              value.onServices(
                                                                item.id!);
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                'Continue'.tr,
                                                                style: const TextStyle(
                                                                    fontSize: 10,
                                                                    fontFamily: 'bold',
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
                                          ],
                                        ),
                                      ),
                                    ),
                                     
                                      
                                  
                                      const SizedBox(
                                        height: 10,
                                      ),
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
