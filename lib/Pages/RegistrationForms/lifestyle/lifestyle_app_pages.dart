import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/Pages/RegistrationForms/lifestyle/lifestyle.dart';
import 'package:wellbits/Pages/RegistrationForms/lifestyle/lifestyle_smoking.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/util/app_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/dilogs.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';
import 'package:wellbits/widgets/dilogue/dilogue.dart';

import '../../../util/color_constant.dart';

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
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    // Load initial total score from SharedPreferences
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Provide a default value of 0 if the key doesn't exist
      totalScore = prefs.getInt(AppConstants.TotalScore) ?? 0;
    });
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
  void nextStep() async {
    // First, validate the current step before proceeding
    if (!validateCurrentStep(currentStep)) return;

    // Validate Step 1: Ensure all activities are answered
    if (currentStep == 1 && !areAllActivitiesAnswered()) {
      Dialogs.snackbar(
          "Please answer all activities before proceeding.", context);
      return;
    }

    // Validate Step 2: Ensure smoking and drinking questions are answered
    if (currentStep == 2 && !areSmokingAndDrinkingAnswered()) {
      Dialogs.snackbar(
          "Please answer both smoking and drinking questions before proceeding.",
          context);
      return;
    }

    // When we reach Step 2, we call the API to create the lifestyle profile
    if (currentStep == 2) {
      // Set loading state to true to indicate the request is being made
      setState(() {
        isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedToken = prefs.getString(AppConstants.token);
        print("Token from SharedPreferences: $savedToken");

        await AppDialogue.openLoadingDialogAfterClose(context,
            text: "Creating LifeStle", load: () async {
          final response = await provider.createLifestyleProfile(
            token: savedToken, // Pass the user's token here
            walking: isWalking?.toString() ?? "false",
            workout: isWorkout?.toString() ?? "false",
            cycling: isCycling?.toString() ?? "false",
            swimming: isSwimming?.toString() ?? "false",
            sports: isSports?.toString() ?? "false",
            smoking: isSmoking?.toString() ?? "false",
            drinking: isDrinking?.toString() ?? "false",
          );

          // Check if the response is successful and navigate to the next page
          if (response.status) {
            // Assuming the response contains a score or some other data
            print("Lifestyle Profile Created Successfully!");

            // Navigate to RegisterAppPages after the API call
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterAppPages(
                  tabNumber: 3,
                ),
              ),
            );
          }
        });

        // Call the createLifestyleProfile method with user data
        // final response =
      } catch (e) {
        // Handle any errors that occurred during the API call
        Dialogs.snackbar("An error occurred: ${e.toString()}", context);
      } finally {
        // Set loading state back to false once the request completes
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Proceed to next step if currentStep is not 2
      setState(() {
        if (currentStep < 2) {
          currentStep++;
        }
      });
    }
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
