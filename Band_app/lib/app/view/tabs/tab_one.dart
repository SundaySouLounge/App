import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/gallary_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/individual_profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/profile_categories_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/env.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';

class TableInfo extends StatefulWidget {
  const TableInfo({Key? key}) : super(key: key);

  @override
  State<TableInfo> createState() => _TableInfoState();
}

class _TableInfoState extends State<TableInfo> {
  @override
  Widget build(BuildContext context) {
    final value = Get.put(IndividualProfileController(parser: Get.find()));
    final controller = Get.put(ProfileCategoriesController(parser: Get.find()));
    final userType = Get.put(ProfileController(parser: Get.find()));
    final galleryContr = Get.put(GallaryController(parser: Get.find()));
    print('typeeee ${userType.type}');
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: ThemeProvider.whiteColor,
        body: value.apiCalled == false
            ? const Center(
                child: CircularProgressIndicator(color: ThemeProvider.appColor),
              )
            : SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                    color: ThemeProvider.blackColor),
                              ),
                              Text(
                                'View All'.tr,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: ThemeProvider.greyColor),
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
                              galleryContr.gallery.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(35),
                                    child: galleryContr.gallery[index] != null
                                        ? FadeInImage(
                                            image: NetworkImage(
                                              '${Environments.apiBaseURL}storage/images/${galleryContr.gallery[index].toString()}',
                                            ),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/notfound.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox(), // If image URL is null, don't display anything
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Genres Covered'.tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'bold',
                                    color: ThemeProvider.blackColor),
                              ),
                            ],
                          ),
                        ),
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userType.type == true
                              ? (controller.profileInfo.webCatesData ?? [])
                                  .map((category) => category.name.toString())
                                  .join(', ')
                              : (value.individualInfo.webCatesData ?? [])
                                  .map((category) => category.name.toString())
                                  .join(', '),
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),

                        //BAND SIZE
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Band Size'.tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'bold',
                                    color: ThemeProvider.blackColor),
                              ),
                            ],
                          ),
                        ),
                      Text(
                          userType.type != true
                              ? value.individualInfo.getMusicGroupType()
                              : "dj",
                          style: const TextStyle(
                            color: ThemeProvider.blackColor,
                            fontSize: 15,
                          ),
                        ),

                        //BAND SIZE
                        Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Packages'.tr,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'bold',
                                      color: ThemeProvider.blackColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 5), // Adjust the height as needed
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                value.individualInfo.haveShop == 1
                               ?_buildPackageSubtitle('Solo Package')
                               : SizedBox(height: 1), // Customize the subtitle text as needed
                              SizedBox(height: 5), // Adjust the height as needed
                              _buildPackageText(
                                 userType.type == true
                              ?  controller.profileInfo.selectedAcusticSoloValue.toString()
                              :  value.individualInfo.selectedAcusticSoloValue.toString()),
                               
                              SizedBox(height: 3), 
                              _buildPackageText(
                                  userType.type == true
                              ?  controller.profileInfo.selectedAcusticSoloValueInstrument.toString()
                              :  value.individualInfo.selectedAcusticSoloValueInstrument.toString()),
                                
                              SizedBox(height: 5), // Adjust the height as needed
                             userType.type == true
                              ? SizedBox(height: 1)
                              : (value.individualInfo.inHome == 1
                                  ? _buildPackageSubtitle('Duo Package')
                                  : SizedBox(height: 1)),
                              SizedBox(height: 5), // Adjust the height as needed
                              _buildPackageText(
                                  userType.type == true
                              ?  controller.profileInfo.selectedAcusticDuoValue.toString()
                              :  value.individualInfo.selectedAcusticDuoValue.toString()),
                                
                                SizedBox(height: 3), 
                              _buildPackageText(
                                   userType.type == true
                              ?  controller.profileInfo.selectedAcusticDuoValueInstrument.toString()
                              :  value.individualInfo.selectedAcusticDuoValueInstrument.toString()),
                                
                              SizedBox(height: 5), // Adjust the height as needed

                             userType.type == true
                              ? SizedBox(height: 1)
                              : (value.individualInfo.haveTrio == 1
                              ?_buildPackageSubtitle('Trio Package')
                              : SizedBox(height: 1)), // Customize the subtitle text as needed
                              SizedBox(height: 5), // Adjust the height as needed
                              _buildPackageText(
                                 userType.type == true
                              ?  controller.profileInfo.selectedAcusticDuoValueInstrument.toString()
                              :  value.individualInfo.selectedAcusticTrioValue.toString()),
                                
                              SizedBox(height: 3), 
                              _buildPackageText(
                                 userType.type == true
                              ?  controller.profileInfo.selectedAcusticTrioValueInstrument.toString()
                              :  value.individualInfo.selectedAcusticTrioValueInstrument.toString()),
                                
                              SizedBox(height: 5),

                                userType.type == true
                              ? SizedBox(height: 1)
                              : (value.individualInfo.haveQuartet == 1
                              ?_buildPackageSubtitle('Quarter Package')
                              : SizedBox(height: 1)),  // Customize the subtitle text as needed
                              SizedBox(height: 5), // Adjust the height as needed
                              _buildPackageText(
                                userType.type == true
                              ?  controller.profileInfo.selectedAcusticQuarterValue.toString()
                              :  value.individualInfo.selectedAcusticQuarterValue.toString()),
                                
                                SizedBox(height: 3), 
                              _buildPackageText(
                                userType.type == true
                              ?  controller.profileInfo.selectedAcusticQuarterValueInstrument.toString()
                              :  value.individualInfo.selectedAcusticQuarterValueInstrument.toString()),
                                
                              SizedBox(height: 5), // Adjust the height as needed
                              value.individualInfo.weddingEditor.toString()!= 'null' || controller.profileInfo.weddingEditor.toString() != 'null'
                             ? _buildPackageSubtitle('Wedding and Corporation Package')
                             : SizedBox(height: 1), // Customize the subtitle text as needed
                              SizedBox(height: 5), // Adjust the height as needed
                              _buildPackageText(
                                 userType.type == true
                              ?  controller.profileInfo.weddingEditor.toString()
                              :  value.individualInfo.weddingEditor.toString()),
                                
                                SizedBox(height: 3), 
                              _buildPackageText(
                                 userType.type == true
                              ?  controller.profileInfo.weddingEditorInstrument.toString()
                              :  value.individualInfo.weddingEditorInstrument.toString()),
                                
                              SizedBox(height: 5), // Adjust the height as needed
                              ],
                            ),
                          ],
                        ),
                      ),
                        //ADRRESS
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Address'.tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'bold',
                                    color: ThemeProvider.blackColor),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      userType.type == true
                              ?  controller.profileInfo.address.toString()
                              : value.individualInfo.address.toString(),
                                    
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ThemeProvider.greyColor),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.near_me_outlined,
                                          size: 15,
                                          color: ThemeProvider.orangeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Willing to travel'.tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'bold',
                                    color: ThemeProvider.blackColor),
                              ),
                            ],
                          ),
                        ),

                        Text(
                           userType.type == true
                              ?  controller.profileInfo.travelEditor?.toString() ?? ''
                              :  value.individualInfo.travelEditor?.toString()?? '',
                         
                          style: const TextStyle(
                            color: ThemeProvider.blackColor,
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'BIO'.tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'bold',
                                    color: ThemeProvider.blackColor),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          userType.type == true
                              ?  controller.profileInfo.about.toString()
                              :   value.individualInfo.about?.toString() ??
                              'No information available',

                          style: const TextStyle(
                            color: ThemeProvider.blackColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
      ),
    );
  }
}
Widget _buildPackageSubtitle(String subtitle) {
  return Text(
    subtitle,
    style: const TextStyle(
        color: ThemeProvider.greyColor, fontSize: 12),
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