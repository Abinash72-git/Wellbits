import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class LifestyleRegister extends StatefulWidget {
  final void Function(bool, bool, bool, bool, bool) onActivityChanged;
  const LifestyleRegister({super.key, required this.onActivityChanged});

  @override
  State<LifestyleRegister> createState() => _LifestyleRegisterState();
}

class _LifestyleRegisterState extends State<LifestyleRegister> {
  @override
  bool isWalking = false;
  bool isWorkout = false;
  bool isCycling = false;
  bool isSwimming = false;
  bool isSports = false;

  void updateActivities() {
    widget.onActivityChanged(
        isWalking, isWorkout, isCycling, isSwimming, isSports);
  }

  Widget buildActivityCard(String title, String imagePath, bool isSelected,
      ValueChanged<bool> onToggle) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1.1),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 5,
        //     spreadRadius: 2,
        //     offset: Offset(0, 5),
        //   ),
        // ],
      ),
      child: Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.005,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Curved background container
                        ClipPath(
                          clipper: CurvedBackgroundClipper(),
                          child: Container(
                            height: screenHeight * 0.15,
                            width: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        // Image on top of the curved background
                        Image.asset(
                          imagePath,
                          height: screenHeight * 0.1,
                          width: screenHeight * 0.1,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize
                              .min, // Ensures the column only takes necessary space
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: screenHeight * 0.015),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  title,
                                  style: Styles.textStyleLarge(
                                    context,
                                    color: AppColor.mainTextColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            ToggleSwitch(
                              minWidth: screenWidth * 0.3, // Adjusted width
                              cornerRadius: 40.0,
                              activeBgColors: [
                                [AppColor.fillColor],
                                [AppColor.fillColor],
                              ],
                              activeFgColor: Colors.white,
                              inactiveBgColor: AppColor.mainTextColor,
                              inactiveFgColor: Colors.white,
                              initialLabelIndex: isSelected ? 0 : 1,
                              totalSwitches: 2,
                              labels: ['Yes', 'No'],
                              fontSize: screenWidth * 0.024,
                              radiusStyle: true,
                              onToggle: (index) {
                                onToggle(index == 0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          buildActivityCard(
            "Walking",
            "assets/icons/walking.png",
            isWalking,
             (value) {
              setState(() => isWalking = value);
              updateActivities();
            },
          ),
          buildActivityCard(
            "Workout",
            "assets/icons/workout.png",
            isWorkout,
             (value) {
              setState(() => isWorkout = value);
              updateActivities();
            },
          ),
          buildActivityCard(
            "Cycling",
            "assets/icons/cycling.png",
            isCycling,
             (value) {
              setState(() => isCycling = value);
              updateActivities();
            },
          ),
          buildActivityCard(
            "Swimming",
            "assets/icons/swiming.png",
            isSwimming,
            (value) {
              setState(() => isSwimming = value);
              updateActivities();
            },
          ),
          buildActivityCard(
            "Sports",
            "assets/icons/sports.png",
            isSports,
            (value) {
              setState(() => isSports = value);
              updateActivities();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Start from bottom-left
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width,
        0); // Create a smooth curve to the top-right
    path.lineTo(size.width, 0); // Close the path along the top-right edge
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
