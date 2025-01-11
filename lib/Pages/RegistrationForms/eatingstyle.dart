import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wellbits/Pages/RegistrationForms/eatinghabits1.dart';
import 'package:wellbits/Pages/RegistrationForms/eatinghabits2.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class EatingStyle extends StatefulWidget {
  @override
  _EatingStyleState createState() => _EatingStyleState();
}

class _EatingStyleState extends State<EatingStyle> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  int currentStep = 1; // To track which widget is being displayed
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Widget displayedWidget;

    // Use switch to decide which widget to show
    switch (currentStep) {
      case 1:
        displayedWidget = Eatinghabits1();
        break;
      case 2:
        displayedWidget = Eatinghabits2();
        break;
      default:
        displayedWidget = Eatinghabits1();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      textAlign: TextAlign.center, // Center-align the text
                      text: TextSpan(
                        text: 'Eating ',
                        style: Styles.textStyleHBugeBold(context,
                                color: AppColor.mainTextColor)
                            .copyWith(fontSize: screenWidth * 0.09),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Style',
                            style: Styles.textStyleHBugeBold(context,
                                    color: AppColor.fillColor)
                                .copyWith(fontSize: screenWidth * 0.09),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 20,
            ),

            // Dynamic widget based on switch case
            Expanded(child: displayedWidget),

            MyButton(
              text: isLoading ? 'Loading...' : "NEXT",
              textcolor: AppColor.whiteColor,
              textsize: 23 * (screenWidth / 375),
              fontWeight: FontWeight.w600,
              letterspacing: 0.7,
              buttoncolor: AppColor.fillColor,
              borderColor: AppColor.fillColor,
              buttonheight: 65 * (screenHeight / 812),
              buttonwidth: screenWidth,
              radius: 40,
              onTap: () {
                setState(() {
                  if (currentStep < 2) {
                    currentStep++;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
