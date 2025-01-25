import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class Eatinghabits5 extends StatefulWidget {
  const Eatinghabits5({super.key});

  @override
  State<Eatinghabits5> createState() => _Eatinghabits5State();
}

class _Eatinghabits5State extends State<Eatinghabits5> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  // List of card titles
  final List<String> cardTitles = [
    "Number of Meals",
    "Water Intake per Day",
    "Eating Style",
    "Intake Quantity Level",
    "Chewing Duration",
  ];

  // List of values to display at the center of each card
  final List<String> cardValues = [
    "3 Meals",
    "2 Liters",
    "Spoon",
    "1/3 Spoon",
    "1 mins/Chew",
  ];

  // List of suggestions for the user
  final List<String> cardSuggestions = [
    "Consider adding small snacks between meals.",
    "Increase water intake to 3 liters for better hydration.",
    "Focus on avoiding distractions while eating.",
    "Maintain portion control for healthy eating.",
    "Chew longer to improve digestion efficiency.",
  ];

  // List to track checkbox states
  final List<bool> isChecked = List.generate(5, (index) => false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInstructionDialog();
    });
  }

  // Function to show the alert dialog
  void showInstructionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Instructions"),
          content: const Text(
              "Please review the suggestions for each card and check the boxes to indicate whether you are following the recommendations."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Got it!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Text(
              "Final Tracking",
              style: Styles.textStyleExtraLargeBold2(context,
                  color: AppColor.mainTextColor),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cardTitles.length,
                itemBuilder: (context, index) {
                  return buildCard(
                    title: cardTitles[index],
                    value: cardValues[index],
                    suggestion: cardSuggestions[index],
                    isChecked: isChecked[index],
                    onCheckedChanged: (value) {
                      setState(() {
                        isChecked[index] = value!;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each card
  Widget buildCard({
    required String title,
    required String value,
    required String suggestion,
    required bool isChecked,
    required ValueChanged<bool?> onCheckedChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of the card
          Text(
            title,
            style: Styles.textStyleExtraLarge(
              context,
              color: AppColor.mainTextColor,
            ),
          ),
          const SizedBox(height: 10),
          // Centered value
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.lightblueColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.hintTextColor.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                value,
                style: Styles.textStyleExtraLarge(
                  context,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Suggestion with checkbox
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onCheckedChanged,
                activeColor: AppColor.orangeColor,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Suggestion: ',
                    style: Styles.textStyleMedium(context,
                        color: AppColor.mainTextColor),
                    children: [
                      TextSpan(
                        text: suggestion,
                        style: Styles.textStyleMedium(
                          context,
                          color: AppColor.fillColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
