import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruler_picker_bn/ruler_picker_bn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wellbits/Pages/RegistrationForms/cholesterol.dart';
import 'package:wellbits/Pages/RegistrationForms/height.dart';
import 'package:wellbits/Pages/RegistrationForms/pressure.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/Pages/RegistrationForms/sugar_level.dart';
import 'package:wellbits/Pages/RegistrationForms/weight.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/app_constant.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/dilogs.dart';
import 'package:wellbits/util/exception.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';
import 'package:wellbits/widgets/dilogue/dilogue.dart';

class MedicalRegister extends StatefulWidget {
  const MedicalRegister({super.key});

  @override
  State<MedicalRegister> createState() => _MedicalRegisterState();
}

class _MedicalRegisterState extends State<MedicalRegister> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  int currentStep = 1;

  bool isLoading = false;
  bool isHeightSelected = false;
  bool isWeightSelected = false;
  bool isCMSelected = true;
  bool isPressureSelected = false;
  bool isSugarLevelSelected = false;
  bool isCholesterolSelected = false;

  double selectedWeight = 50.0;
  double selectedHeight = 0.0;

  double systolicLevel = 120.0;
  double diastolicLevel = 80.0;
  double cholesterolLevel = 120.0;

  double prePrandialLevel = 0.0;
  double postPrandialLevel = 0.0;

  double triglyceridesLevel = 120.0;
  double ldlLevel = 120.0;
  double hdlLevel = 120.0;

  int totalScore = 0;

  UserProvider get provider => context.read<UserProvider>();

  Widget buildStepContent() {
    switch (currentStep) {
      case 1:
        return HeightRegister(
          onHeightChanged: (height, isCM) {
            setState(() {
              selectedHeight = height;
              isCMSelected = isCM;
              isHeightSelected = true;
            });
          },
        );
      case 2:
        return WeightRegister(
          onWeightChanged: (weight) {
            setState(() {
              selectedWeight = weight; // Update the selected weight
              isWeightSelected = true; // Mark weight as selected
            });
          },
        );
      case 3:
        return PressureRegister(
          onPressureChanged: (systolic, diastolic, cholesterol) {
            setState(() {
              systolicLevel = systolic;
              diastolicLevel = diastolic;
              cholesterolLevel = cholesterol;
              isPressureSelected = true;
            });
          },
        );
      case 4:
        return SugarLevelRegister(
          onSugarLevelChanged: (prePrandial, postPrandial) {
            setState(() {
              prePrandialLevel = prePrandial;
              postPrandialLevel = postPrandial;
              isSugarLevelSelected = true;
            });
          },
        );
      case 5:
        return Cholesterol(
          onCholesterolChanged: (triglycerides, ldl, hdl) {
            setState(() {
              triglyceridesLevel = triglycerides;
              ldlLevel = ldl;
              hdlLevel = hdl;
              isCholesterolSelected = true;
            });
          },
        );
      default:
        return Container();
    }
  }

  // Method to proceed to the next step
  void nextStep() async {
    if (currentStep == 1 && (!isHeightSelected || selectedHeight <= 0)) {
      Dialogs.snackbar("Please select your height before proceeding.", context);
      return;
    }
    if (currentStep == 2 && (selectedWeight <= 0 || !isWeightSelected)) {
      Dialogs.snackbar("Please select your weight before proceeding.", context);
      return;
    }
    if (currentStep == 3 &&
        (!isPressureSelected ||
            systolicLevel <= 0 ||
            diastolicLevel <= 0 ||
            cholesterolLevel <= 0)) {
      Dialogs.snackbar(
          "Please select your pressure and cholesterol levels.", context);
      return;
    }
    if (currentStep == 4 &&
        (!isSugarLevelSelected ||
            prePrandialLevel <= 0 ||
            postPrandialLevel <= 0)) {
      Dialogs.snackbar(
          "Please select your sugar levels before proceeding.", context);
      return;
    }
    if (currentStep == 5 &&
        (!isCholesterolSelected ||
            triglyceridesLevel <= 0 ||
            ldlLevel <= 0 ||
            hdlLevel <= 0)) {
      Dialogs.snackbar(
          "Please complete your cholesterol levels before proceeding.",
          context);
      return;
    }

    if (currentStep == 5) {
      FocusScope.of(context).unfocus(); // Close the keyboard
      setState(() {
        isLoading = true;
      });

      // try {
      //   await AppDialogue.openLoadingDialogAfterClose(
      //     context,
      //     text: "Saving Medical Profile...",
      //     load: () async {
      //       final SharedPreferences prefs =
      //           await SharedPreferences.getInstance();
      //       final String? token = prefs.getString(AppConstants.token);

      //       if (token == null) {
      //         throw Exception("User token not found. Please log in again.");
      //       }

      //       // Call createMedicalProfile
      //       return await provider.createMedicalProfile(
      //         token: token,
      //         height: selectedHeight,
      //         weight: selectedWeight,
      //         pressureSystolic: systolicLevel,
      //         pressureDiastolic: diastolicLevel,
      //         triglycerides: triglyceridesLevel,
      //         ldl: ldlLevel,
      //         hdl: hdlLevel,
      //         sugarPre: prePrandialLevel,
      //         sugarPost: postPrandialLevel,
      //       );
      //     },
      //     afterComplete: (resp) async {
      //       if (resp.status) {
      //         AppDialogue.toast("Medical profile created successfully!");
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => RegisterAppPages(tabNumber: 2),
      //           ),
      //         );
      //       } else {
      //         AppDialogue.toast("Failed to save medical profile!");
      //       }
      //     },
      //   );
      // } catch (e) {
      //   ExceptionHandler.showMessage(context, e);
      // } finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    } else {
      setState(() {
        currentStep++;
      });
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterAppPages(tabNumber: 2)));
  }

  // Method to go back to the previous step
  void previousStep() {
    setState(() {
      if (currentStep > 1) currentStep--;
    });
  }

  void goToStep(int step) {
    // Validate and store data from the current step before navigating
    if (step > currentStep) {
      if (currentStep == 1 && (!isHeightSelected || selectedHeight <= 0)) {
        Dialogs.snackbar(
            "Please complete step 1 (Height) before proceeding.", context);
        return;
      }
      if (currentStep == 2 && (selectedWeight <= 0 || !isWeightSelected)) {
        Dialogs.snackbar(
            "Please complete step 2 (Weight) before proceeding.", context);
        return;
      }
      if (currentStep == 3 &&
          (!isPressureSelected ||
              systolicLevel <= 0 ||
              diastolicLevel <= 0 ||
              cholesterolLevel <= 0)) {
        Dialogs.snackbar(
            "Please complete step 3 (Pressure and Cholesterol) before proceeding.",
            context);
        return;
      }
      if (currentStep == 4 &&
          (!isSugarLevelSelected ||
              prePrandialLevel <= 0 ||
              postPrandialLevel <= 0)) {
        Dialogs.snackbar(
            "Please complete step 4 (Sugar Levels) before proceeding.",
            context);
        return;
      }
      if (currentStep == 5 &&
          (!isCholesterolSelected ||
              triglyceridesLevel <= 0 ||
              ldlLevel <= 0 ||
              hdlLevel <= 0)) {
        Dialogs.snackbar(
            "Please complete step 5 (Cholesterol Levels) before proceeding.",
            context);
        return;
      }
    }

    // Allow navigation to the selected step
    setState(() {
      currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: context.height,
        width: context.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 70.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .start, // Ensure equal space between elements
                  children: [
                    // 'Score' text

                    // 'Profile' text with RichText
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          // textAlign: TextAlign.center, // Center-align the text
                          text: TextSpan(
                            text: 'Medi',
                            style: Styles.textStyleHBugeBold(context,
                                    color: AppColor.mainTextColor)
                                .copyWith(fontSize: screenWidth * 0.09),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'cal',
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
                  height: screenHeight * 0.023,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'score',
                          style: Styles.textStyleExtraLarge(
                            context,
                            color: AppColor.mainTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Flexible(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColor.yellowColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(3, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$totalScore%',
                            style: Styles.textStyleMedium(
                              context,
                              color: AppColor.whiteColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.023,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Align circles and lines properly
                    children: [
                      for (int i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () => goToStep(i),
                          child: Row(
                            children: [
                              // Stepper Circle with Box Shadow
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Circle color set to white
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 206, 197, 197)
                                            .withOpacity(0.2), // Shadow color
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(1, 1), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: currentStep >= i
                                        ? AppColor.mainTextColor
                                        : Colors.white,
                                    radius: 17, // Adjust size as needed
                                    child: Text(
                                      '$i',
                                      style: Styles.textStyleSmall(
                                        context,
                                        color: currentStep >= i
                                            ? Colors.white // White when active
                                            : AppColor
                                                .mainTextColor, // Main text color when not active
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (i !=
                                  5) // Avoid drawing line after the last circle
                                Container(
                                  width:
                                      15, // Adjust width based on the distance between circles
                                  height: 2, // Line thickness
                                  color: currentStep > i
                                      ? Colors.green
                                      : const Color.fromARGB(
                                          255, 221, 218, 218),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildStepContent(),
                const SizedBox(
                  height: 20,
                ),
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
                  onTap: nextStep,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
