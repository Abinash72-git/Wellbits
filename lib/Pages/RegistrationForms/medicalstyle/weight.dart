import 'dart:math';

import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class WeightRegister extends StatefulWidget {
 final void Function(double) onWeightChanged;
  const WeightRegister({super.key, required this.onWeightChanged});

  @override
  State<WeightRegister> createState() => _WeightRegisterState();
}

class _WeightRegisterState extends State<WeightRegister> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  double minWeight = 50; // Minimum weight
  double maxWeight = 200.0; // Maximum weight
  double selectedWeight = 50.0; // Default initial weight

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    // Define the image width scaling based on the weight, keeping height fixed
    double minImageWidth = screenWidth * 0.25;
    double maxImageWidth = screenWidth * 0.5;
    double imageHeight = screenHeight * 0.2; // Constant height for the image

    double imageWidth = minImageWidth +
        ((selectedWeight - minWeight) / (maxWeight - minWeight)) *
            (maxImageWidth - minImageWidth);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Current Weight?",
            style: Styles.textStyleExtraLarge(
              context,
              color: AppColor.mainTextColor,
            ).copyWith(fontSize: screenWidth * 0.06),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${selectedWeight.toStringAsFixed(1)} kg",
            style: Styles.textStyleLarge(
              context,
              color: AppColor.mainTextColor,
            ).copyWith(fontSize: screenWidth * 0.08),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 170,
            child: AnimatedWeightPicker(
              min: minWeight,
              max: maxWeight,
              division: 0.5, // Set division to 0.5 for whole and .5 intervals
              dialHeight: 70.0,
              dialThickness: 3.0,
              dialColor: Colors.green,
              majorIntervalAt: 10,
              majorIntervalHeight: 40.0,
              majorIntervalThickness: 1.5,
              majorIntervalColor: AppColor.mainTextColor,
              showMajorIntervalText: true,
              majorIntervalTextSize: screenWidth * 0.04,
              majorIntervalTextColor: AppColor.mainTextColor,
              subIntervalAt: 2,
              subIntervalHeight: 25.0,
              subIntervalThickness: 1.5,
              subIntervalColor: Colors.grey,
              showSelectedValue: false,
              onChange: (newValue) {
                setState(() {
                  selectedWeight = double.parse(newValue);
                });
                widget.onWeightChanged(selectedWeight);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Image of the man which adjusts size based on weight
           Image.asset(
          'assets/icons/man2.png',
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
