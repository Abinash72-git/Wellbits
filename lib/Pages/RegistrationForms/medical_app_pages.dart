import 'dart:math';

import 'package:flutter/material.dart';
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
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/dilogs.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

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
  int heightWeightScore = 0;
  int sugarScore = 0;
  int pressureScore = 0;
  int cholesterolScore = 0;

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
  void nextStep() {
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
    if (currentStep == 1 || currentStep == 2) {
      heightWeightScore =
          calculateHeightWeightScore(selectedHeight, selectedWeight);
    }
    if (currentStep == 3) {
      pressureScore = calculatePressureScore(systolicLevel, diastolicLevel);
    }
    if (currentStep == 4) {
      sugarScore = calculateSugarScore(prePrandialLevel, postPrandialLevel);
    }
    if (currentStep == 5) {
      cholesterolScore =
          calculateCholesterolScore(triglyceridesLevel, ldlLevel, hdlLevel);
    }

    // Update the total score
    totalScore =
        heightWeightScore + pressureScore + sugarScore + cholesterolScore;

    // Save the total score locally for the next page
    saveTotalScore(totalScore);
    // if (currentStep == 1) {
    //   String unit = isCMSelected ? "cm" : "ft";
    //   print("Selected Height: ${selectedHeight.toStringAsFixed(1)} $unit");
    // }
    // if (currentStep == 2) {
    //   print("Selected Weight: ${selectedWeight.toStringAsFixed(1)} kg");
    // }
    // if (currentStep == 3) {
    //   print("Systolic Level: $systolicLevel");
    //   print("Diastolic Level: $diastolicLevel");
    //   print("Cholesterol Level: $cholesterolLevel");
    // }
    // if (currentStep == 4) {
    //   print("Pre-prandial Level: $prePrandialLevel");
    //   print("Post-prandial Level: $postPrandialLevel");
    // }
    // if (currentStep == 5) {
    //   print("Triglycerides Level: $triglyceridesLevel");
    //   print("LDL Level: $ldlLevel");
    //   print("HDL Level: $hdlLevel");
    // }

    setState(() {
      if (currentStep < 5) {
        currentStep++;
      } else {
        // Navigate to the new page after the last step is completed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterAppPages(
              tabNumber: 2,
            ),
          ),
        );
      }
    });
  }

  // Method to go back to the previous step
  void previousStep() {
    setState(() {
      if (currentStep > 1) currentStep--;
    });
  }

  int calculateHeightWeightScore(double height, double weight) {
    double bmi = weight / ((height / 100) * (height / 100));
    if (bmi >= 18.5 && bmi <= 24.9) {
      return 0; // Healthy range
    } else if (bmi < 18.5 || bmi > 30) {
      return 20; // Unhealthy range
    } else {
      return 10; // Slightly unhealthy
    }
  }

  int calculatePressureScore(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 0; // Normal pressure
    } else if ((systolic >= 120 && systolic <= 139) ||
        (diastolic >= 80 && diastolic <= 89)) {
      return 10; // Elevated pressure
    } else {
      return 20; // High pressure
    }
  }

  int calculateSugarScore(double prePrandial, double postPrandial) {
    if (prePrandial < 100 && postPrandial < 140) {
      return 0; // Normal sugar
    } else if (prePrandial < 126 && postPrandial < 200) {
      return 10; // Prediabetes
    } else {
      return 20; // Diabetes
    }
  }

  int calculateCholesterolScore(double triglycerides, double ldl, double hdl) {
    if (triglycerides < 150 && ldl < 100 && hdl > 40) {
      return 0; // Healthy cholesterol
    } else if (triglycerides < 200 && ldl < 130 && hdl >= 40) {
      return 10; // Slightly unhealthy
    } else {
      return 20; // Unhealthy
    }
  }

  void saveTotalScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalScore', score);
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
                // if (currentStep > 1)
                //   MyButton(
                //     text: "BACK",
                //     textcolor: AppColor.whiteColor,
                //     textsize: 23,
                //     fontWeight: FontWeight.w600,
                //     letterspacing: 0.7,
                //     buttoncolor: Colors.grey,
                //     borderColor: Colors.grey,
                //     buttonheight: 60,
                //     buttonwidth: context.width,
                //     radius: 40,
                //     onTap: previousStep,
                //   ),
                // const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
