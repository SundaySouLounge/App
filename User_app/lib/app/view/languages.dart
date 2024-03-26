import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/languages_controller.dart';
import 'package:app_user/app/util/constant.dart';
import 'package:app_user/app/util/theme.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text('Languages'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: ThemeProvider.whiteColor,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              for (var language in AppConstants.languages)
                ListTile(
                  title: Text(language.languageName),
                  leading: Radio(
                      value: language.languageCode,
                      groupValue: value.languageCode,
                      onChanged: (e) {
                        value.saveLanguages(e.toString());
                      }),
                )
            ]),
          ),
        );
      },
    );
  }
}
