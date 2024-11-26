import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class LifestyleSmokingRegister extends StatefulWidget {
  final void Function(bool, bool) onSmokingChanged;

  const LifestyleSmokingRegister({super.key, required this.onSmokingChanged});

  @override
  State<LifestyleSmokingRegister> createState() =>
      _LifestyleSmokingRegisterState();
}

class _LifestyleSmokingRegisterState extends State<LifestyleSmokingRegister> {
  @override
  bool? isSmoking;
  bool? isDrinking;

  void _onToggleSmoking(bool value) {
    setState(() {
      isSmoking = value;
    });
    widget.onSmokingChanged(isSmoking ?? false, isDrinking ?? false);
  }

  void _onToggleDrinking(bool value) {
    setState(() {
      isDrinking = value;
    });
    widget.onSmokingChanged(isSmoking ?? false, isDrinking ?? false);
  }

  Widget buildActivityCard(String title, String imagePath, bool isSelected,
      ValueChanged<bool> onToggle) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.017,
        vertical: screenHeight * 0.017,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: .5),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 5,
        //     spreadRadius: 2,
        //     offset: Offset(0, 5),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Semi-circular background
                  ClipPath(
                    clipper: CurvedBackgroundClipper(),
                    child: Container(
                      height: screenHeight * 0.15,
                      width: screenWidth * 0.3,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  // Image on top of the background
                  Image.asset(
                    imagePath,
                    height: screenHeight * 0.12,
                    width: screenHeight * 0.12,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: Styles.textStyleLarge(
                        context,
                        color: AppColor.mainTextColor,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          ToggleSwitch(
            minWidth: screenWidth * 0.15,
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
            fontSize: 10,
            radiusStyle: true,
           
            onToggle: (index) {
              onToggle(index == 0);
            },
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildActivityCard(
              "Smoking",
              "assets/icons/smoking.png",
             isSmoking ?? false,
              _onToggleSmoking,
            ),
            buildActivityCard(
              "Drinking",
              "assets/icons/drinking.png",
              isDrinking ?? false,
              _onToggleDrinking,
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.6, size.width, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
