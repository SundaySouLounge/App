import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/profile_categories_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/video_controller.dart';
import 'package:ultimate_band_owner_flutter/app/env.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/util/toast.dart';
import 'package:ultimate_band_owner_flutter/app/controller/profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/individual_profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/view/calendar.dart';
import 'package:ultimate_band_owner_flutter/app/view/notification_screen/notification_screen.dart';
import 'package:ultimate_band_owner_flutter/app/view/tabs/tab_one.dart';
import 'package:ultimate_band_owner_flutter/app/view/tabs/tab_three.dart';
import 'package:ultimate_band_owner_flutter/app/view/tabs/tab_two.dart';


class ProfileShow extends StatefulWidget {
  const ProfileShow({Key? key}) : super(key: key);

  @override
  State<ProfileShow> createState() => _ProfileShowState();
}

class _ProfileShowState extends State<ProfileShow> {
  @override
  Widget build(BuildContext context) {
    final item = Get.put(IndividualProfileController(parser: Get.find()));
    final sal = Get.put(ProfileCategoriesController(parser: Get.find()));
    final videoController = Get.put(VideoController(parser: Get.find()));

    return GetBuilder<ProfileController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.whiteColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 50,
          title: Text(
            'Profile View'.tr,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: ThemeProvider.titleStyle,
          ),
        ),
        body: CustomScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 50),
                                child: FadeInImage(
                                  image: NetworkImage(
                                    value.type
                                        ? '${Environments.apiBaseURL}storage/images/${sal.cover.toString()}' 
                                        : '${Environments.apiBaseURL}storage/images/${item.backgroundCover.toString()}',
                                  ),
                                  placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                              
                              
                             
                            ],
                          ),
                          Text(
                            '${value.parser.getName().toString()}',
                            style: const TextStyle(
                              fontFamily: 'bold',
                              color: ThemeProvider.blackColor,
                            ),
                          ),
                           SizedBox(),

                           Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                      successToast(
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
                                      (),
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
                                      ]
                                  )
                                  )
                          
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10),
                                        child: TableInfo(),
                                  )
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: TableVideos(videoList: videoController.videoList),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10),
                                   child: TableCalendar(),
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
      );
    });
  }
}
