import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class Eatinghabits1 extends StatefulWidget {
  const Eatinghabits1({super.key});

  @override
  State<Eatinghabits1> createState() => _Eatinghabits1State();
}

class _Eatinghabits1State extends State<Eatinghabits1> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  int? selectedValue; // Track the selected button's value
  int _selectedMealsValue = 2; // Initial value for meals
  int _selectedWaterValue = 2; // Initial value for water intake

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCustomWidget(
                title: "Number Of Meals",
                imagePath: "assets/icons/mealtime.png",
                inputValue: 4,
                initialSelectedValue: _selectedMealsValue,
                onSelectionChanged: (value) {
                  setState(() {
                    _selectedMealsValue = value;
                  });
                },
              ),
              buildCustomWidget(
                  title: "Water Intake in Liter",
                  imagePath: 'assets/icons/waterbottle.png',
                  inputValue: 4,
                  initialSelectedValue: _selectedWaterValue,
                  onSelectionChanged: (value) {
                    setState(() {
                      _selectedWaterValue = value;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }

  /// Method to create the custom widget
  Widget buildCustomWidget({
    required String title,
    required String imagePath,
    required int inputValue,
    required int initialSelectedValue,
    required Function(int) onSelectionChanged,
  }) {
    int selectedValue = initialSelectedValue;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: Styles.textStyleExtraLarge(
            context,
            color: AppColor.mainTextColor,
          ),
        ),

        const SizedBox(height: 20),

        // Dynamic Circular Image
        Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 60, // Circle size
            backgroundImage: AssetImage(
              imagePath,
            ), // Dynamic image path
          ),
        ),

        const SizedBox(height: 20),

        // Dynamic Circle Buttons
        Wrap(
          spacing: 10,
          children: List.generate(inputValue, (index) {
            int buttonValue = index + 2;
            return createCircleButton(
              label: buttonValue.toString(),
              isSelected: selectedValue == buttonValue,
              onTap: () {
                onSelectionChanged(buttonValue);
              },
            );
          }),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  /// Method to create the custom widget
  Widget createCircleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColor.mainText2Color : Colors.grey[300],
          border: isSelected
              ? Border.all(color: AppColor.fillColor, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.3), // Adjust opacity as needed
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // Adjust offset for shadow direction
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
