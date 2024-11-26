import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wellbits/Pages/app_pages.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

class Workstyle extends StatefulWidget {
  const Workstyle({super.key});

  @override
  State<Workstyle> createState() => _WorkstyleState();
}

class _WorkstyleState extends State<Workstyle> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedWorkType;
  final List<String> workTypes = ["Full-time", "Part-time", "No-work"];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensure equal space between elements
                children: [
                  // 'Score' text
                  // FittedBox(
                  //   fit: BoxFit.scaleDown,
                  //   child: Text(
                  //     'score',
                  //     style: Styles.textStyleExtraLarge(
                  //       context,
                  //       color: AppColor.mainTextColor,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //     overflow: TextOverflow.ellipsis, // Prevent overflow
                  //   ),
                  // ),

                  // Container(
                  //   width: screenWidth * 0.15,
                  //   height: screenWidth * 0.15,
                  //   decoration: BoxDecoration(
                  //     color: AppColor.yellowColor,
                  //     shape: BoxShape.circle,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.2),
                  //         spreadRadius: 2,
                  //         blurRadius: 10,
                  //         offset: Offset(5, 5),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: screenWidth * 0.05,
                  // ),
                  // 'Profile' text with RichText
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center, // Center-align the text
                        text: TextSpan(
                          text: 'Work ',
                          style: Styles.textStyleHBugeBold(context,
                              color: AppColor.mainTextColor).copyWith(fontSize: screenWidth * 0.09),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Style',
                              style: Styles.textStyleHBugeBold(context,
                                  color: AppColor.fillColor).copyWith(fontSize: screenWidth * 0.09),
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Work Type",
                  style: Styles.textStyleExtraLarge(
                    context,
                    color: AppColor.mainTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              createDropdownField(
                context,
                label: "Select Type",
                iconPath: "assets/icons/work type.png", // Example icon path
                value: selectedWorkType,
                items: workTypes,
                onChanged: (value) {
                  setState(() {
                    selectedWorkType = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Hours",
                style: Styles.textStyleExtraLarge(
                  context,
                  color: AppColor.mainTextColor,
                ),
              ),
              const SizedBox(height: 8),
              createDropdownField(
                context,
                label: "Select Hours",
                iconPath: "assets/icons/select hours.png", // Example icon path
                value: selectedWorkType,
                items: workTypes,
                onChanged: (value) {
                  setState(() {
                    selectedWorkType = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Secondary Work",
                style: Styles.textStyleExtraLarge(
                  context,
                  color: AppColor.mainTextColor,
                ),
              ),
              const SizedBox(height: 8),
              createDropdownField(
                context,
                label: "Select Work",
                iconPath:
                    "assets/icons/secondary work.png", // Example icon path
                value: selectedWorkType,
                items: workTypes,
                onChanged: (value) {
                  setState(() {
                    selectedWorkType = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "On Desk Time",
                style: Styles.textStyleExtraLarge(
                  context,
                  color: AppColor.mainTextColor,
                ),
              ),
              const SizedBox(height: 8),
              createDropdownField(
                context,
                label: "Select on desk time",
                iconPath: "assets/icons/ondesk time.png", // Example icon path
                value: selectedWorkType,
                items: workTypes,
                onChanged: (value) {
                  setState(() {
                    selectedWorkType = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Break",
                style: Styles.textStyleExtraLarge(
                  context,
                  color: AppColor.mainTextColor,
                ),
              ),
              const SizedBox(height: 8),
              createDropdownField(
                context,
                label: "Select break",
                iconPath: "assets/icons/break.png", // Example icon path
                value: selectedWorkType,
                items: workTypes,
                onChanged: (value) {
                  setState(() {
                    selectedWorkType = value;
                  });
                },
              ),
              SizedBox(
                height: height / 20,
              ),
              MyButton(
                text: isLoading ? 'Loading...' : "next".toUpperCase(),
                textcolor: AppColor.whiteColor,
                textsize: 23 * (screenWidth / 375),
                fontWeight: FontWeight.w600,
                letterspacing: 0.7,
                buttoncolor: AppColor.fillColor,
                borderColor: AppColor.fillColor,
                buttonheight: 65 * (screenHeight / 812),
                buttonwidth: screenWidth,
                radius: 40,
                onTap: () async {
                  //validateAndContinue();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppPages(tabNumber: 0),
                    ),
                  );
                },
              ),
              SizedBox(
                height: height / 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createDropdownField(
    BuildContext context, {
    required String label,
    required String iconPath,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
     padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: screenHeight * 0.04,
            width: screenHeight * 0.04,
            color: AppColor.mainTextColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: Styles.textStyleMedium(
                      context,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                value: value,
                isExpanded: true,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item,
                        style: Styles.textStyleMedium(
                          context,
                          color: AppColor.mainTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
