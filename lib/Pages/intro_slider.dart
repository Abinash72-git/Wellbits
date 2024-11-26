import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/color_constant.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
   MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  int _currentPageIndex = 0;
  final List<String> imagePaths = [
    'assets/bg/intro 1.jpg',
    'assets/bg/intro 2.jpg',
    'assets/bg/Intro 3.jpg',
    'assets/bg/intro 4.jpg',
    'assets/bg/intro 5.jpg',
    'assets/bg/intro 6.jpg',
    'assets/bg/intro 7.jpg'
  ];

  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imagePaths.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       await Navigator.pushNamedAndRemoveUntil(
          //         context,
          //         AppConstants.SELECTLOCATION,
          //         (Route<dynamic> route) => false,
          //       );
          //     },
          //     child: Text('Skip'),
          //   ),
          // ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppColor.mainTextColor,
                ), // Set your desired color here
              ),
              onPressed: () async {
                if (_currentPage < imagePaths.length - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                   AppRouteName.registerAppPages.pushAndRemoveUntil(context, (route) => false);
                }
              },
              child: Text(
                _currentPage == imagePaths.length - 1 ? 'Done' : 'Next',
                style:
                    TextStyle(color: Colors.white), // Set text color if needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
