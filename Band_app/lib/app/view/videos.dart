import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ultimate_band_owner_flutter/app/controller/video_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  // @override
  // void initState() {
  //   final videoController = Get.put(VideoController(parser: Get.find<VideoParser>()));
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     await videoController.getMyVideos();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.whiteColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 50,
          title: Text(
            'Video'.tr,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: ThemeProvider.titleStyle,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: ThemeProvider.blackColor,
                  backgroundColor: ThemeProvider.greenColor,
                  textStyle: const TextStyle(fontSize: 10),
                ),
                onPressed: () {
                  value.onAddNew();
                },
                child: Text(
                  'Add New'.tr,
                  style: const TextStyle(
                      color: ThemeProvider.whiteColor, fontFamily: 'bold'),
                ),
              ),
            ),
          ],
        ),
        body: value.apiCalled == false
            ? SkeletonListView()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: value.videoList.length,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) => Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: ThemeProvider.greyColor),
                                  top: BorderSide(
                                      color: ThemeProvider.greyColor),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value.videoList[i].title ?? '',
                                      style: const TextStyle(
                                          fontSize: 17, fontFamily: 'bold'),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              value.onEdit(value.videoList[i].id!);
                                            },
                                            child: const Icon(
                                              Icons.edit_note,
                                              color: ThemeProvider.greenColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/delete.png',
                                                            fit: BoxFit.cover,
                                                            height: 80,
                                                            width: 80,
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'Are you sure'.tr,
                                                            style: const TextStyle(
                                                                fontSize: 24,
                                                                fontFamily:
                                                                    'semi-bold'),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              'to delete Video?'
                                                                  .tr),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        ThemeProvider
                                                                            .backgroundColor,
                                                                    backgroundColor:
                                                                        ThemeProvider
                                                                            .redColor,
                                                                    minimumSize:
                                                                        const Size
                                                                            .fromHeight(
                                                                            35),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'Cancel'.tr,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: ThemeProvider
                                                                          .whiteColor,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    value.onRemoveVideo(value.videoList[i].id!);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        ThemeProvider
                                                                            .backgroundColor,
                                                                    backgroundColor:
                                                                        ThemeProvider
                                                                            .greenColor,
                                                                    minimumSize:
                                                                        const Size
                                                                            .fromHeight(
                                                                            35),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'Delete'.tr,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: ThemeProvider
                                                                          .whiteColor,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: ThemeProvider.redColor,
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
              ),
      );
    });
  }
}
