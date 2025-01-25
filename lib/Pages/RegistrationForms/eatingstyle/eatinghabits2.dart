import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class Eatinghabits2 extends StatefulWidget {
  const Eatinghabits2({super.key});

  @override
  State<Eatinghabits2> createState() => _Eatinghabits2State();
}

class _Eatinghabits2State extends State<Eatinghabits2> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  int? selectedImageIndex; // Persistent state for selected image

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
        child: Column(
          children: [
            Text(
              "Pick Your Eating Style",
              style: Styles.textStyleExtraLarge(context,
                  color: AppColor.mainTextColor),
            ),
            Expanded(
              child: buildImageSelectionWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageSelectionWidget(BuildContext context) {
    final List<Map<String, String>> items = [
      {'image': 'assets/image/hands.jpg', 'name': 'Hands'},
      {'image': 'assets/image/spoon.jpg', 'name': 'Spoon'},
      {'image': 'assets/image/choopstick.jpg', 'name': 'Chopstick'},
    ];

    return SizedBox(
      height: 200, // Set the desired height for the ListView
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: items.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedImageIndex = index;
              });
            },
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedImageIndex == index
                          ? AppColor.fillColor
                          : AppColor.hintTextColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: selectedImageIndex == index
                            ? AppColor.fillColor
                                .withOpacity(0.4) // Shadow for selected
                            : AppColor.hintTextColor
                                .withOpacity(0.2), // Shadow for unselected
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 100, // Match the image height
                      width: 100, // Match the image width
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(items[index]['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: selectedImageIndex != index
                          ? Container(
                              color:
                                  Colors.grey.withOpacity(0.5), // Gray overlay
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 5), // Space between image and text
                Text(
                  items[index]['name']!,
                  style: Styles.textStyleLarge(
                    context,
                    color: AppColor.mainTextColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
