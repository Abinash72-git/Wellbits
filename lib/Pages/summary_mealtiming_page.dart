import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class MealTimeWidget extends StatefulWidget {
  const MealTimeWidget({Key? key}) : super(key: key);

  @override
  State<MealTimeWidget> createState() => _MealTimeWidgetState();
}

class _MealTimeWidgetState extends State<MealTimeWidget> {
  String selectedMeal = 'breakfast';

  final Map<String, Map<String, String>> mealTypes = {
    'breakfast': {
      'cuisine': 'South Indian',
      'prepared': 'Hotel',
      'type': 'Non-Veg',
      'estimatedTime': '0:30',
      'bitsTime': '0:25'
    },
    'lunch': {
      'cuisine': 'South Indian',
      'prepared': 'Hotel',
      'type': 'Veg',
      'estimatedTime': '0:30',
      'bitsTime': '0:25'
    },
    'dinner': {
      'cuisine': 'South Indian',
      'prepared': 'Home',
      'type': 'Non-Veg',
      'estimatedTime': '0:30',
      'bitsTime': '0:25'
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Meal Type Selection Buttons
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Breakfast Button
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedMeal == 'breakfast'
                            ? AppColor.fillColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            setState(() => selectedMeal = 'breakfast'),
                        child: Text(
                          'Breakfast',
                          // style: TextStyle(
                          //   color: selectedMeal == 'breakfast'
                          //       ? Colors.white
                          //       : Colors.black,
                          // ),
                          style: Styles.textStyleMedium1(
                            context,
                            color: selectedMeal == 'breakfast'
                                ? AppColor.whiteColor
                                : AppColor.blackColor,
                          ),
                        ),
                      ),
                    ),
                    // Underline for Breakfast
                    if (selectedMeal == 'breakfast')
                      Container(
                        height: 2,
                        color: AppColor.fillColor,
                        width: double
                            .infinity, // Explicit width handled by Expanded
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Lunch Button
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedMeal == 'lunch'
                            ? AppColor.fillColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () => setState(() => selectedMeal = 'lunch'),
                        child: Text(
                          'Lunch',
                          style: Styles.textStyleMedium1(
                            context,
                            color: selectedMeal == 'lunch'
                                ? AppColor.whiteColor
                                : AppColor.blackColor,
                          ),
                        ),
                      ),
                    ),
                    // Underline for Lunch
                    if (selectedMeal == 'lunch')
                      Container(
                        height: 2,
                        color: AppColor.fillColor,
                        width: double
                            .infinity, // Explicit width handled by Expanded
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Dinner Button
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedMeal == 'dinner'
                            ? AppColor.fillColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            setState(() => selectedMeal = 'dinner'),
                        child: Text(
                          'Dinner',
                          style: Styles.textStyleMedium1(
                            context,
                            color: selectedMeal == 'dinner'
                                ? AppColor.whiteColor
                                : AppColor.blackColor,
                          ),
                        ),
                      ),
                    ),
                    // Underline for Dinner
                    if (selectedMeal == 'dinner')
                      Container(
                        height: 2,
                        color: AppColor.fillColor,
                        width: double
                            .infinity, // Explicit width handled by Expanded
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Cuisine Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Image.asset('assets/icons/cuisine.png', height: 24, width: 24),
                const SizedBox(width: 12),
                const Text('Cuisine'),
                const Spacer(),
                Text(mealTypes[selectedMeal]!['cuisine']!),
              ],
            ),
          ),

          // Prepared Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Image.asset('assets/icons/cooking.png', height: 24, width: 24),
                const SizedBox(width: 12),
                const Text('Prepared'),
                const Spacer(),
                Text(mealTypes[selectedMeal]!['prepared']!),
              ],
            ),
          ),

          // Type Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Text('Type'),
                const Spacer(),
                Text(mealTypes[selectedMeal]!['type']!),
              ],
            ),
          ),

          // Wellbits Estimate Time
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Center(
              child: Text(
                'Wellbits Estimate Time',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Estimated Time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Estimated Time',
                  style: TextStyle(color: Colors.green),
                ),
                const Spacer(),
                Text(
                  '${mealTypes[selectedMeal]!['estimatedTime']!} Sec',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),

          // Your bits Time
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Icon(Icons.timer, color: Colors.red, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Your bits Time',
                  style: TextStyle(color: Colors.red),
                ),
                const Spacer(),
                Text(
                  '${mealTypes[selectedMeal]!['bitsTime']!} Sec',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
