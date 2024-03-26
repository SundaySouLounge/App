import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/intro_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/constant.dart';
import 'package:app_user/app/util/theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final CarouselController _controller = CarouselController();
  int currentIndex = 0;
  List items = [0, 1, 2, 3, 4];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(builder: (value) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: ThemeProvider.whiteColor,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //   ),
        //  // actions: <Widget>[getLanguages()],
        // ),
        backgroundColor: ThemeProvider.whiteColor,
        body: _buildBody(),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: Column(
            children: [
              if (currentIndex == 0)
                _buildBottomNavigationBar1()
              else if (currentIndex == 1)
                _buildBottomNavigationBar2()
              else if (currentIndex == 2)
                _buildBottomNavigationBar3()
              else if (currentIndex == 3)
                _buildBottomNavigationBar4()
              else if (currentIndex == 4)
                _buildBottomNavigationBar5()
            ],
          ),
        ),
      );
    });
  }

  Widget getLanguages() {
    return PopupMenuButton(
      onSelected: (value) {},
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 20),
      //   child: IconButton(
      //     icon: const Icon(Icons.translate),
      //     color: ThemeProvider.appColor,
      //     tooltip: "Save Todo and Retrun to List".tr,
      //     onPressed: () {},
      //   ),
      // ),
      itemBuilder: (context) => AppConstants.languages
          .map((e) => PopupMenuItem<String>(
                value: e.languageCode.toString(),
                onTap: () {
                  var locale = Locale(e.languageCode.toString());
                  Get.updateLocale(locale);
                  Get.find<IntroController>().saveLanguage(e.languageCode);
                },
                child: Text(e.languageName.toString()),
              ))
          .toList(),
    );
  }

  Widget _buildBody() {
    return CarouselSlider(
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
        height: double.infinity,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      carouselController: _controller,
      items: items.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  if (i == 0)
                    _buildSlide1(context)
                  else if (i == 1)
                    _buildSlide2(context)
                  else if (i == 2)
                    _buildSlide3(context)
                  else if (i == 3)
                    _buildSlide4(context)
                  else if (i == 4)
                    _buildSlide5(context),
                  _buildDots()
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSlide1(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/1.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Welcome to the Elite Artist booking app! '.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 17),
              ),
            ),
            Text(
              'Since 2010, we have been on a vibrant journey, hosting weekly auditions in various locations to discover exceptional musicians to join our esteemed Elite Artist roster. With a cumulative experience of over a century in the music industry, we are committed to maintaining an elevated standard of excellence. Join us in celebrating the best in music!'
                  .tr,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: ThemeProvider.greyColor, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide2(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/2.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Your assurance of quality starts here!'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 17),
              ),
            ),
            Text(
              'Every artist can now easily create an account on the Elite Artist app. To help you distinguish the exceptional from the rest, keep an eye out for the coveted "Verified" stamp of approval. This ensures that the artist you are booking boasts a proven track record of excellence.'
                  .tr,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: ThemeProvider.greyColor, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide3(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/3.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Verified!'.tr,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 17),
              ),
            ),
            Text(
              'Achieving verification on our platform is a mark of distinction for artists. This status is earned either by receiving rebookings from two or more venues following a successful initial gig or by showcasing their talent, reliability, and time management skills at our weekly auditions. It is our way of ensuring that verified artists on our platform consistently deliver excellence - on stage, and off stage.'
                  .tr,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: ThemeProvider.greyColor, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide4(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/4.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Contracts'.tr,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 17),
              ),
            ),
            Text(
              'Within the Elite Artist Booking App, the contract process is seamless. Upon receiving a contract, artists can Accept, Reject, or Negotiate the terms. Once both parties have agreed on the fee, the contract receives the official stamp of approval from the Elite Artist Booking App. This ensures clarity and transparency in the agreement, making the booking process straightforward and efficient.'
                  .tr,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: ThemeProvider.greyColor, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlide5(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/sliders/5.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'The Show Must Go On! '.tr,
                style: const TextStyle(
                    fontFamily: 'bold',
                    color: ThemeProvider.blackColor,
                    fontSize: 17),
              ),
            ),
            Text(
              'In 2023, the Elite Artist platform successfully facilitated nearly 2000 bookings, boasting a remarkable record of zero no-shows. In cases where an artist is unable to perform due to illness, we ensure continuity by replacing the originally booked artist with an alternative with a similar skill set. When you book through the Elite Artist app, we promise to honour your contract, ensuring a reliable and uninterrupted performance experience.'.tr,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: ThemeProvider.greyColor, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? ThemeProvider.whiteColor
                              : ThemeProvider.blackColor)
                          .withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar1() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                Get.toNamed(AppRouter.chooseLocationRoutes);
              },
              child: Center(
                child: Text(
                  'Skip'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.nextPage();
              },
              child: Center(
                child: Text(
                  'Next'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.appColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar2() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.previousPage();
              },
              child: Center(
                child: Text(
                  'Previous'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.nextPage();
              },
              child: Center(
                child: Text(
                  'Next'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.appColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar3() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.previousPage();
              },
              child: Center(
                child: Text(
                  'Previous'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.nextPage();
              },
              child: Center(
                child: Text(
                  'Next'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.appColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar4() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.previousPage();
              },
              child: Center(
                child: Text(
                  'Previous'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.nextPage();
              },
              child: Center(
                child: Text(
                  'Next'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.appColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar5() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeProvider.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                _controller.previousPage();
              },
              child: Center(
                child: Text(
                  'Previous'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.blackColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                Get.toNamed(AppRouter.chooseLocationRoutes);
              },
              child: Center(
                child: Text(
                  'Get Started'.tr,
                  style: const TextStyle(
                      fontFamily: 'bold', color: ThemeProvider.appColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

contentButtonStyle1() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(50.0),
    ),
    color: ThemeProvider.blackColor,
  );
}

contentButtonStyle2() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(50.0),
    ),
    color: ThemeProvider.appColor,
  );
}

contentButtonStyle3() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(50.0),
    ),
    color: ThemeProvider.redColor,
  );
}
