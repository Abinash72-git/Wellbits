import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/Pages/RegistrationForms/lifestyle.dart';
import 'package:wellbits/Pages/RegistrationForms/lifestyle_smoking.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/dilogs.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

import '../../util/color_constant.dart';

class LifestyleAppPages extends StatefulWidget {
  const LifestyleAppPages({super.key});

  @override
  State<LifestyleAppPages> createState() => _LifestyleAppPagesState();
}

class _LifestyleAppPagesState extends State<LifestyleAppPages> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  int currentStep = 1;

  bool isLoading = false;

  bool? isWalking;
  bool? isWorkout;
  bool? isCycling;
  bool? isSwimming;
  bool? isSports;

  bool? isSmoking;
  bool? isDrinking;

  int lifestyleScore = 0;
  int totalScore = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalScore(); // Load initial total score from SharedPreferences
  }

  Future<void> _loadTotalScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalScore = prefs.getInt('totalScore') ?? 0;
    });
  }

  Future<void> _saveTotalScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalScore', score);
  }

  void calculateLifestyleScore() {
    int activityScore = 0;
    int smokingDrinkingScore = 0;

    // Calculate activity score
    if (isWalking == true) activityScore += 4;
    if (isWorkout == true) activityScore += 4;
    if (isCycling == true) activityScore += 4;
    if (isSwimming == true) activityScore += 4;
    if (isSports == true) activityScore += 4;

    // Deduct points if smoking or drinking
    if (isSmoking == true) smokingDrinkingScore += 10;
    if (isDrinking == true) smokingDrinkingScore += 10;

    lifestyleScore = activityScore - smokingDrinkingScore;
    lifestyleScore =
        lifestyleScore.clamp(0, 20); // Ensure it stays between 0 and 20

    // Update the total score
    totalScore += lifestyleScore;

    _saveTotalScore(totalScore); // Save the updated total score
  }

  bool areSmokingAndDrinkingAnswered() {
    return isSmoking != null && isDrinking != null;
  }

  bool areAllActivitiesAnswered() {
    return isWalking != null &&
        isWorkout != null &&
        isCycling != null &&
        isSwimming != null &&
        isSports != null;
  }

  Widget buildStepContent() {
    switch (currentStep) {
      case 1:
        return LifestyleRegister(
          onActivityChanged: (walking, workout, cycling, swimming, sports) {
            setState(() {
              isWalking = walking;
              isWorkout = workout;
              isCycling = cycling;
              isSwimming = swimming;
              isSports = sports;
            });
          },
        );
      case 2:
        return LifestyleSmokingRegister(
          onSmokingChanged: (smoking, drinking) {
            setState(() {
              isSmoking = smoking;
              isDrinking = drinking;
            });
          },
        );

      default:
        return Container();
    }
  }

  bool validateCurrentStep(int step) {
    if (currentStep == 1 && !areAllActivitiesAnswered()) {
      Dialogs.snackbar(
          "Please answer all activities before proceeding.", context);
      return false;
    }
    if (currentStep == 2 && !areSmokingAndDrinkingAnswered()) {
      Dialogs.snackbar(
          "Please answer smoking and drinking questions before proceeding.",
          context);
      return false;
    }
    return true;
  }

  // Method to proceed to the next step
  void nextStep() {
    if (!validateCurrentStep(currentStep)) return;
    if (currentStep == 1 && !areAllActivitiesAnswered()) {
      Dialogs.snackbar(
          "Please answer all activities before proceeding.", context);
      return;
    }
    if (currentStep == 2 && !areSmokingAndDrinkingAnswered()) {
      Dialogs.snackbar(
          "Please answer both smoking and drinking questions before proceeding.",
          context);
      return;
    }
    if (currentStep == 1) {
    print("Walking: $isWalking");
    print("Workout: $isWorkout");
    print("Cycling: $isCycling");
    print("Swimming: $isSwimming");
    print("Sports: $isSports");

    // Calculate and display the score for Step 1
    calculateLifestyleScore();
    // Dialogs.snackbar(
    //     "Step 1 complete. Your current score: $lifestyleScore", context);
  }

  // Handle Step 2: Smoking and Drinking
  if (currentStep == 2) {
    print("Smoking: $isSmoking");
    print("Drinking: $isDrinking");

    // Update the score for Step 2
    calculateLifestyleScore();
    // Dialogs.snackbar("Step 2 complete. Total score: $totalScore", context);
  }

    setState(() {
      if (currentStep < 2) {
        currentStep++;
      } else {
        // Navigate to the new page after the last step is completed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterAppPages(
              tabNumber: 3,
            ),
          ), // Replace with your new page widget
        );
      }
    });
  }

  void goToStep(int step) {
    // Validate the current step before navigating
    if (step > currentStep && !validateCurrentStep(currentStep)) return;

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
        height: screenHeight,
        width: screenWidth,
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
                      .spaceBetween, // Ensure equal space between elements
                  children: [
                    // 'Score' text

                    // 'Profile' text with RichText
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          textAlign: TextAlign.center, // Center-align the text
                          text: TextSpan(
                            text: 'Life',
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
                  scrollDirection: Axis
                      .horizontal, // Allows horizontal scrolling if content overflows
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Align circles and lines properly
                    children: [
                      for (int i = 1; i <= 2; i++)
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
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '$i',
                                        style: Styles.textStyleSmall(
                                          context,
                                          color: currentStep >= i
                                              ? Colors
                                                  .white // White when active
                                              : AppColor
                                                  .mainTextColor, // Main text color when not active
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (i !=
                                  2) // Avoid drawing line after the last circle
                                Container(
                                  width:
                                      25, // Adjust width based on the distance between circles
                                  height: 1, // Line thickness
                                  color: currentStep > i
                                      ? Colors.green
                                      : const Color.fromARGB(
                                          255, 200, 198, 198),
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
                  height: 0,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
