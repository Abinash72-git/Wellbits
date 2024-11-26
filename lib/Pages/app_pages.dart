import 'dart:math';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wellbits/Pages/RegistrationForms/lifestyle_app_pages.dart';
import 'package:wellbits/Pages/RegistrationForms/medical_app_pages.dart';
import 'package:wellbits/Pages/RegistrationForms/profile.dart';
import 'package:wellbits/Pages/homepage.dart';
import 'package:wellbits/util/color_constant.dart';

class AppPages extends StatefulWidget {
  final int tabNumber;
  const AppPages({required this.tabNumber});

  @override
  State<AppPages> createState() => _AppPagesState();
}

class _AppPagesState extends State<AppPages> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int index;
  late DateTime currentBackPressTime;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    Homepage(),
    Container(color: Colors.white),
    Container(color: Colors.white),
  ];

  @override
  void initState() {
    super.initState();
    currentBackPressTime = DateTime.now();
    index = widget.tabNumber;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        extendBody: true,
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          color: AppColor.fillColor,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: AppColor.mainTextColor,
          height: 65,
          animationDuration: const Duration(milliseconds: 300),
          items: <Widget>[
            _buildNavItem("assets/icons/appointment.png", isActive: index == 0),
            _buildNavItem("assets/icons/operator.png", isActive: index == 1),
            _buildNavItem("assets/icons/analysis.png", isActive: index == 2),
          ],
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
            _pageController.jumpToPage(selectedIndex);
          },
        ),
      ),
    );
  }

 Widget _buildNavItem(String assetPath, {bool isActive = false}) {
  return isActive
      ? Image.asset(
          assetPath,
          height: 40, // Active icon size
          width: 40,
          color: Colors.white,
          fit: BoxFit.contain,
        )
      : Padding(
        padding: const EdgeInsets.only(top: 13),
        child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                //shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  assetPath,
                  height: 30, // Inactive icon size
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      );
}


  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (index != 0) {
      setState(() {
        index = 0;
      });
      _pageController.jumpToPage(index);
      return Future.value(false);
    } else {
      if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Tap Again to Exit");
        return Future.value(false);
      }
      return Future.value(true);
    }
  }
}
