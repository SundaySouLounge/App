import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:app_user/app/controller/register_controller.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (value) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ThemeProvider.appColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ThemeProvider.whiteColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Create an Account'.tr,
            style: ThemeProvider.titleStyle,
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: value.venueName,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Venue Name'.tr,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: value.venueAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Venue Address'.tr,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: value.firstNameTextEditor,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'First Name'.tr,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: value.lastNameTextEditor,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Last Name'.tr,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: value.emailTextEditor,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Email Address'.tr,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          onChanged: (e) =>
                              value.updateCountryCode(e.dialCode.toString()),
                          initialSelection: 'United Kingdom',
                          favorite: const ['+44', 'UK'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        )),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TextFormField(
                          controller: value.mobileTextEditor,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number'.tr,
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: value.passwordTextEditor,
                        textInputAction: TextInputAction.next,
                        obscureText: passwordVisible == true ? false : true,
                        decoration: InputDecoration(
                          labelText: 'Password'.tr,
                          filled: true,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible == false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ThemeProvider.appColor,
                            ),
                          ),
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10), 
                Visibility(
                  visible: false,
                  child: 
                    TextFormField(
                      controller: value.passwordTextEditor, // Use the controller for the second password field
                      obscureText: true, // Always obscure this field
                      decoration: InputDecoration(
                        labelText: 'Confirm Password'.tr,
                        filled: true,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                    ),
                ),
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                         items: ["Cash", "BACS", "Event UK/Just Pay", "c247", "SAP Concur"]
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // Update the controller with the selected value
                              value.referralCodeTextEditor.text = newValue;
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            labelText: 'Payment Method'.tr,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                      child: Text.rich(TextSpan(
                          text: 'By continuing, you agree to our '.tr,
                          style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'regular',
                              color: ThemeProvider.blackColor),
                          children: <TextSpan>[
                        TextSpan(
                            text: 'Terms of Service'.tr,
                            style: const TextStyle(
                              fontSize: 10,
                              color: ThemeProvider.blackColor,
                              fontFamily: 'bold',
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                value.onAppPages('Terms & Conditions'.tr, '3');
                              }),
                        TextSpan(
                            text: ' and '.tr,
                            style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'regular',
                                color: ThemeProvider.blackColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Privacy Policy'.tr,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: ThemeProvider.blackColor,
                                      fontFamily: 'bold',
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      value.onAppPages(
                                          'Privacy Policy'.tr, '2');
                                    })
                            ])
                      ]))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20.0),
                  child: InkWell(
                    onTap: () {
                      value.onRegister();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                          color: ThemeProvider.appColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up'.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'bold'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have already account ?'.tr,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            'Log in'.tr,
                            style: const TextStyle(
                                fontFamily: 'bold',
                                fontSize: 14,
                                color: ThemeProvider.appColor),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
