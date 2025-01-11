import 'package:flutter/material.dart';
import 'package:wellbits/Pages/booking/calender.dart';
import 'package:wellbits/Pages/summary_calender_page.dart';
import 'package:wellbits/Pages/summary_mealtiming_page.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class WellbitsSummaryPage extends StatefulWidget {
  @override
  State<WellbitsSummaryPage> createState() => _WellbitsSummaryPageState();
}

class _WellbitsSummaryPageState extends State<WellbitsSummaryPage> {
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
    double sh = MediaQuery.of(context).size.height;
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(sh, sw, context),
      body: Container(
        width: sw,
        height: sh,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icons/bg.png"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Today Details",
                  style: Styles.textStyleExtraLargeBold(context),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Calories Card
                    _buildInfoCard(
                        title: "Calories",
                        value: "600Kcal",
                        valueColor: AppColor.whiteColor,
                        backgroundColor: AppColor.lightblueColor,
                        context: context),
                    // Protein Card
                    _buildInfoCard(
                        title: "Protein",
                        value: "0.36g",
                        valueColor: AppColor.whiteColor,
                        backgroundColor: AppColor.purpleColor,
                        context: context),
                    // Total Score Card
                    _buildTotalScoreCard(
                        score: 90,
                        context: context,
                        backgroundColor: AppColor.orangeColor),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MealTimeWidget(),
                statusCard(
                    title: "Status : ",
                    status: "Good",
                    description:
                        "Serve apporpriate portions to avoid overeating and maintain energy levels")
                // const SizedBox(height: 20),
                // Row(
                //   children: [
                //     _buildMealButton('Break Fast', 'breakfast', Colors.green),
                //     const SizedBox(width: 8),
                //     _buildMealButton('Lunch', 'lunch', Colors.blue[900]!),
                //     const SizedBox(width: 8),
                //     _buildMealButton('Dinner', 'dinner', Colors.blue[900]!),
                //   ],
                // ),
                // const SizedBox(height: 20),
                // _buildInfoRow(Icons.restaurant_menu, 'Cuisine',
                //     mealTypes[selectedMeal]!['cuisine']!),
                // _buildInfoRow(Icons.person, 'Prepared',
                //     mealTypes[selectedMeal]!['prepared']!),
                // _buildTypeRow('Type', mealTypes[selectedMeal]!['type']!),
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                //   decoration: BoxDecoration(
                //     color: Colors.orange,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: const Center(
                //     child: Text(
                //       'Wellbits Estimate Time',
                //       style: TextStyle(
                //           color: Colors.white, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),

                // // Time Estimates
                // _buildTimeRow(
                //   Icons.timer_outlined,
                //   'Estimated Time',
                //   '${mealTypes[selectedMeal]!['estimatedTime']!} Sec',
                //   Colors.green,
                // ),
                // _buildTimeRow(
                //   Icons.timer,
                //   'Your bits Time',
                //   '${mealTypes[selectedMeal]!['bitsTime']!} Sec',
                //   Colors.red,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double sh, double sw, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(200.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30.0),
        ),
        child: Container(
          color: Colors.blue.shade900, // Background color for the AppBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ), // Reduced vertical padding
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Wellbits Summary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const SummaryCalender(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build the small info cards
  Widget _buildInfoCard({
    required String title,
    required String value,
    required Color valueColor,
    required Color backgroundColor,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            12), // Apply circular border radius to all corners
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.8),
            blurRadius: 4,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Styles.textStyleSmall2(context),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero, // No radius on top-left corner
                topRight: Radius.circular(
                    12), // Apply circular radius to top-right corner
                bottomLeft: Radius.circular(
                    12), // Apply circular radius to bottom-left corner
                bottomRight: Radius.circular(
                    12), // Apply circular radius to bottom-right corner
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: Styles.textStyleMedium1(context,
                        color: AppColor.whiteColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to build the Total Score Card
  Widget _buildTotalScoreCard({
    required int score,
    required Color backgroundColor,
    required BuildContext context,
  }) {
    double percentage = score / 100; // Convert score into a percentage (0 to 1)

    return Container(
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.8),
              blurRadius: 4,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(children: [
          // Left Container with the man icon
          Container(
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white, // Ensure background is white
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft:
                    Radius.circular(12), // Apply circular radius to bottom-left
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4), // Light shadow color
                  blurRadius: 6, // Blur effect for the shadow
                  offset: Offset(0, 4), // Shadow offset (vertical)
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Icon (green icon)
                Positioned.fill(
                  child: Icon(
                    Icons.man,
                    color: AppColor.fillColor,
                    size: 60,
                  ),
                ),
                // Blue Progress (based on score)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: percentage),
                      duration: Duration(
                          seconds: 1), // Adjust the duration for the animation
                      builder: (context, double value, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.bottomCenter,
                          heightFactor:
                              value, // This is the animated percentage of the blue color
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.mainText2Color.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          // Expanded section for the text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total score",
                  style: Styles.textStyleSmall2(context),
                ),
                SizedBox(height: 8),
                Spacer(),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero, // No radius on top-left corner
                      topRight: Radius.circular(
                          12), // Apply circular radius to top-right corner
                      bottomLeft: Radius
                          .zero, // Apply circular radius to bottom-left corner
                      bottomRight: Radius.circular(
                          12), // Apply circular radius to bottom-right corner
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$score',
                            style: Styles.textStyleExtraHugeBold(context,
                                color: AppColor.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }

  Widget _buildMealButton(String text, String mealType, Color activeColor) {
    final isSelected = selectedMeal == mealType;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => selectedMeal = mealType),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? activeColor : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[900], size: 20),
          const SizedBox(width: 12),
          SizedBox(width: 80, child: Text(label)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTypeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          SizedBox(width: 80, child: Text(label)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTimeRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: $value',
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    IconData? icon,
    String? text, // For buttons and row text
    String? label, // For label in info or type rows
    String? value, // For value in info or type rows
    List<Color>? circles, // For type row circle indicators
    Color? color, // For icon or text color
    bool isButton = false, // Distinguish between button and rows
    Color? activeColor, // For button active background
    String? mealType, // For button meal type
  }) {
    if (isButton) {
      final isSelected = selectedMeal == mealType;
      return Expanded(
        child: ElevatedButton(
          onPressed: () => setState(() => selectedMeal = mealType!),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? activeColor : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(text!),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: color ?? Colors.blue[900], size: 20),
            const SizedBox(width: 12),
          ],
          if (circles != null) ...[
            Row(
              children: circles
                  .map(
                    (circleColor) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(width: 12),
          ],
          if (label != null) SizedBox(width: 80, child: Text(label)),
          if (value != null) Text(value, style: TextStyle(color: color)),
          if (text != null) Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget statusCard({
    required String title,
    required String status,
    required String description,
  }) {
    // Determine the color for the status
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'good':
        statusColor = Colors.white;
        break;
      case 'bad':
        statusColor = Colors.red;
        break;
      case 'excellent':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status row
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColor.fillColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description text
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
