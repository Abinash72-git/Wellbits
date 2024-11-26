import 'dart:math';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wellbits/Pages/food_page.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CarouselController _carouselController = CarouselController();
  int myCurrentIndex = 0;
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<String> images = [
    "assets/icons/slider.png",
    "assets/icons/slider.png",
    "assets/icons/slider.png",
  ];
  List<String> meals = ["Break Fast", "Lunch", "Dinner"];
  List<String> days = ["DAY 1", "DAY 2", "DAY 3", "DAY 4", "DAY 5"];

  double totalScore = 0;

  @override
  void initState() {
    super.initState();
    _retrieveTotalScore();
  }

  // Method to retrieve total score from local storage
  Future<void> _retrieveTotalScore() async {
    // Replace with your local storage implementation
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalScore =
          prefs.getDouble('totalScore') ?? 0.0; // Default to 0 if not found
    });
  }

  void _navigateToFoodPage(String meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodPage(selectedMeal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.HomeBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Image.asset(
                        "assets/icons/menu.png",
                        height: screenHeight * 0.04,
                        width: screenWidth * 0.1,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Image.asset(
                      "assets/icons/wellbbits-logo.png",
                      height: screenHeight * 0.1,
                      fit: BoxFit.cover,
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'score',
                          style: Styles.textStyleExtraLarge(context,
                              color: AppColor.whiteColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          color: AppColor.yellowColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${totalScore.toStringAsFixed(0)}%", // Display the total score
                              style: Styles.textStyleSmall(
                                context,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Image.asset(
                        "assets/icons/stock-photo-woman-and-man-signs.png",
                        height:
                            screenHeight * 0.06, // Adjusted for responsiveness
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    viewportFraction: 1, // Set the height of the slider
                    autoPlay: true,
                    enlargeCenterPage: true,

                    onPageChanged: (index, reason) {
                      setState(() {
                        myCurrentIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        image: DecorationImage(
                          image: AssetImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),

                // Dots Indicator
                const SizedBox(
                  height: 10,
                ),
                AnimatedSmoothIndicator(
                  activeIndex: myCurrentIndex,
                  count: images.length, // Use the length of your images list
                  effect: const WormEffect(
                    activeDotColor: AppColor.mainTextColor,
                    dotColor: Colors.grey,
                    dotHeight: 7,
                    dotWidth: 7,
                    paintStyle: PaintingStyle.fill,
                    spacing: 5,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(days.length, (dayIndex) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: screenWidth * 0.22,
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            //  padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: dayIndex == 0
                                  ? AppColor.fillColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(screenWidth * 0.07),
                                bottomLeft: Radius.circular(screenWidth * 0.05),
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  days[dayIndex],
                                  style: Styles.textStyleLarge(
                                    context,
                                    color: dayIndex == 0
                                        ? AppColor.whiteColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex:
                                5, // Adjust flex to control width of the meals container
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: dayIndex == 0
                                    ? AppColor.mainTextColor
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(screenWidth * 0.07),
                                  bottomRight:
                                      Radius.circular(screenWidth * 0.07),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.3,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Wrap(
                                  spacing: screenWidth * 0.02,
                                  runSpacing: screenHeight * 0.01,
                                  children:
                                      List.generate(meals.length, (mealIndex) {
                                    return GestureDetector(
                                      onTap: () {
                                        _navigateToFoodPage(meals[mealIndex]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02,
                                          vertical: screenHeight * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              screenWidth * 0.03),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/icons/timing.png',
                                              height: screenHeight * 0.025,
                                              width: screenWidth * 0.05,
                                            ),
                                            SizedBox(width: screenWidth * 0.01),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                meals[mealIndex],
                                                style: Styles.textStyleMedium(
                                                    context,
                                                    color:
                                                        AppColor.mainTextColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                SizedBox(
                  height: 90,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
