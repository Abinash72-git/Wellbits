import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wellbits/Pages/chew_time_food.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

class FoodPage extends StatefulWidget {
  final String selectedMeal;
  const FoodPage({required this.selectedMeal, Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<String> images = [
    "assets/bg/Banner_1.png",
    "assets/bg/Banner_2.png",
  ];
  int myCurrentIndex = 0;
  String? selectedCuisine;
  String? selectedPrepared;
  String? selectedType;
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
                  height: 70,
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
                    dotColor: Colors.white,
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
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: screenWidth * 0.2,
                            height: screenHeight * 0.08,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            //  padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColor.fillColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(screenWidth * 0.05),
                                bottomLeft: Radius.circular(screenWidth * 0.05),
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/icons/timing.png",
                                fit: BoxFit.cover,
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.1,
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.5,
                            //height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            // padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColor.mainTextColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(screenWidth * 0.05),
                                bottomRight:
                                    Radius.circular(screenWidth * 0.05),
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.selectedMeal.toUpperCase(),
                                  style: Styles.textStyleLarge(
                                    context,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                // Cuisine Dropdown
                _buildDropdownRow(
                  iconPath: "assets/icons/cuisine.png",
                  label: "CUISINE",
                  items: ["South Indian", "North Indian", "Continental"],
                  value: selectedCuisine,
                  onChanged: (value) {
                    setState(() {
                      selectedCuisine = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                _buildDropdownRow(
                  iconPath: "assets/icons/cooking.png",
                  label: "Prepared",
                  items: ["Home", "Restaurant"],
                  value: selectedPrepared,
                  onChanged: (value) {
                    setState(() {
                      selectedPrepared = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                _buildDropdownRow(
                  iconPath: "assets/icons/cooking.png",
                  label: "Type",
                  items: ["Veg", "Non-Veg"],
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Plate Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Plate Image
                    Image.asset(
                      "assets/icons/food.png",
                      height: screenHeight * 0.12,
                      fit: BoxFit.cover,
                    ),
                    Flexible(
                      child: MyButton(
                        text: isLoading
                            ? 'Loading...'
                            : "Start Eating to as Beats",
                        textcolor: AppColor.whiteColor,
                        textsize: 23 * (screenWidth / 375),
                        fontWeight: FontWeight.w600,
                        letterspacing: 0.7,
                        buttoncolor: AppColor.fillColor,
                        borderColor: AppColor.fillColor,
                        buttonheight: 65 * (screenHeight / 812),
                        buttonwidth: screenWidth,
                        radius: 40,
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChewTimeFood(
                                selectedMeal: widget.selectedMeal,
                                selectedCuisine:
                                    selectedCuisine ?? "South Indian",
                                selectedType: selectedType ?? "Veg",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Start Eating Slider Button
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: screenWidth * 0.02),
                    //     child: ActionSlider.standard(
                    //       sliderBehavior: SliderBehavior.move,
                    //       width: double.infinity,
                    //       backgroundColor: AppColor.fillColor,
                    //       toggleColor: Colors.white,
                    //       icon: Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: AppColor.mainTextColor,
                    //       ),
                    //       action: (controller) async {
                    //         controller.loading(); // starts loading animation
                    //         await Future.delayed(const Duration(seconds: 2));
                    //         controller.success(); // starts success animation
                    //         await Future.delayed(const Duration(seconds: 1));
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => ChewTimeFood(
                    //                 selectedMeal: widget
                    //                     .selectedMeal), // replace `NextPage` with your actual page
                    //           ),
                    //         );
                    //         controller.reset(); // resets the slider
                    //       },
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const SizedBox(width: 40),
                    //           Flexible(
                    //             child: Text(
                    //               "Start Eating to as Beats",
                    //               style: Styles.textStyleSmall(
                    //                 context,
                    //                 color: Colors.white,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownRow({
    required String iconPath,
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    // Set the initial selected value to the first item if value is null
    String selectedValue = value ?? items.first;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Fixed-width container for the icon and label
        Container(
          width: 170, // Adjust this width to fit all labels equally
          child: Row(
            children: [
              Image.asset(iconPath, height: 30, width: 30),
              const SizedBox(
                width: 5,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: Styles.textStyleLarge(
                    context,
                    color: AppColor.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10), // Adjust spacing as needed
        // Dropdown container wrapped in Flexible for dynamic width
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                width: .3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: AppColor.mainTextColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
