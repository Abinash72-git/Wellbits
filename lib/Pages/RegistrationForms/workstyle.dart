import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/Pages/RegistrationForms/eatingstyle/eatingstyle.dart';
import 'package:wellbits/Pages/app_pages.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/util/app_constant.dart';
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
  String? selectedHours;
  String? selectedDeskTime;
  String? selectedBreakTime;

  final List<String> workTypes = ["Full-time", "Part-time", "No-work"];
  final List<String> hours = ["12 hours", "8 hours"];
  final List<String> desktime = ["1", "2", "3", "4", "5"];
  final List<String> breaktime = ["1", "2", "3", "4", "5"];
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
                value: selectedHours,
                items: hours,
                onChanged: (value) {
                  setState(() {
                    selectedHours = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // Text(
              //   "Secondary Work",
              //   style: Styles.textStyleExtraLarge(
              //     context,
              //     color: AppColor.mainTextColor,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // createDropdownField(
              //   context,
              //   label: "Select Work",
              //   iconPath:
              //       "assets/icons/secondary work.png", // Example icon path
              //   value: selectedWorkType,
              //   items: workTypes,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedWorkType = value;
              //     });
              //   },
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
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
                value: selectedDeskTime,
                items: desktime,
                onChanged: (value) {
                  setState(() {
                    selectedDeskTime = value;
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
                value: selectedBreakTime,
                items: breaktime,
                onChanged: (value) {
                  setState(() {
                    selectedBreakTime = value;
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
                // onTap: () async {
                //   //validateAndContinue();
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AppPages(tabNumber: 0),
                //     ),
                //   );
                // },
                onTap: () async {
                  if (selectedWorkType != null) {
                    final provider =
                        Provider.of<UserProvider>(context, listen: false);
                    try {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? savedToken = prefs.getString(AppConstants.token);
                      print("Token from SharedPreferences: $savedToken");
                      final response = await provider.createWorkStyleProfile(
                        token: savedToken,
                        workType: selectedWorkType!,
                        workHours: selectedHours!,
                        onDeskTime: selectedDeskTime != null
                            ? double.tryParse(selectedDeskTime!) ?? 0.0
                            : 0.0,
                        breakTime: selectedBreakTime != null
                            ? double.tryParse(selectedBreakTime!) ?? 0.0
                            : 0.0,
                      );

                      if (response.status) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Workstyle profile created successfully!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterAppPages(tabNumber: 4),
                          ),
                        );
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a work type.')),
                    );
                  }
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
