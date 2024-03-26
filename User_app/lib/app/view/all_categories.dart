import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/all_categories_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/view/filterdialog.dart';
import 'package:skeletons/skeletons.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCategoriesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor2,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'All Categories'.tr,
              style: ThemeProvider.titleStyle,
            ),
            // actions: [
            //   // Add your filter button here
            //   IconButton(
            //     icon: Icon(
            //         Icons.filter_list), // You can change the icon as needed
            //     onPressed: () {
            //       // Show the filter dialog
            //       showDialog(
            //         context: context,
            //         builder: (context) {
            //           return FilterDialog(
            //             switchValue1: value.switchValue1,
            //             switchValue2: value.switchValue2,
            //             switchValue3: value.switchValue3,
            //             switchValue4: value.switchValue4,
            //             selectedDate: value.selectedDate,
            //             onClose: (
            //               bool switchValue1,
            //               bool switchValue2,
            //               bool switchValue3,
            //               bool switchValue4,
            //               DateTime selectedDate,
            //             ) {
            //               value.setFilterValues(
            //                 switchValue1,
            //                 switchValue2,
            //                 switchValue3,
            //                 switchValue4,
            //                 selectedDate,
            //               );
            //             },
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ],
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  child: Column(children: [
                    GridView(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        childAspectRatio: 90 / 100,
                      ),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: List.generate(
                          10,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                      height: 130,
                                      width: 120,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              )),
                    ),
                  ]),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: 90 / 100,
                        ),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: [
                          for (var item in value.categoriesList)
                            if (item.extraField != 'dj' &&
                                item.extraField == null)
                              InkWell(
                                onTap: () {
                                  value.clickCategoryItem(item);
                                },
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 3,
                                      color: value.selectedCategoriesList
                                              .contains(item.id)
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ThemeProvider.greyColor,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  ThemeProvider.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                  child: FadeInImage(
                                                    image: NetworkImage(
                                                        '${Environments.apiBaseURL}storage/images/${item.cover.toString()}'),
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
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.name.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 13),
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
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: ThemeProvider.appColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                onTap: () {
                  value.onCategoriesList();
                },
                child: Center(
                  child: Text(
                    'Apply'.tr,
                    style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'bold',
                        color: ThemeProvider.whiteColor),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
