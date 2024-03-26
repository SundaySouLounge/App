import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ultimate_band_owner_flutter/app/controller/video_controller.dart';
import 'package:ultimate_band_owner_flutter/app/env.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
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
            // value.type == 'create' ? 'Create Service' : 'Update Service',
            '${value.action} Video'.tr,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: ThemeProvider.titleStyle,
          ),
        ),
        body: value.apiCalled == false
            ? SkeletonListView()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.titleTextEditor,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ThemeProvider.whiteColor,
                              hintText: 'Video title'.tr,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 8.0, top: 14.0, left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeProvider.appColor),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeProvider.greyColor)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: value.videoLinkTextEditor,
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeProvider.greyColor)),
                              fillColor: ThemeProvider.whiteColor,
                              hintText: 'Video Link'.tr,
                              contentPadding: const EdgeInsets.only(
                                  bottom: 8.0, top: 14.0, left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeProvider.appColor),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeProvider.greyColor)),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Only YouTube videos are allowed',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: value.action == 'Add'
              ? InkWell(
                  onTap: () {
                    value.onSubmit();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    decoration: contentButtonStyle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Video'.tr,
                          style: const TextStyle(
                              color: ThemeProvider.whiteColor, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    value.onUpdateVideo();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                      color: ThemeProvider.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'UPDATE'.tr,
                          style: const TextStyle(
                              color: ThemeProvider.whiteColor, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
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
