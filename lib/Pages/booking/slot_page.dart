import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbits/Pages/booking/calender.dart';
import 'package:wellbits/route_generator.dart';

import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class SlotPage extends StatefulWidget {
  const SlotPage({super.key});

  @override
  State<SlotPage> createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> {
  DateTime? _selectedDate;
  String? selectedSlot; // Variable to store the selected slot

  final List<Map<String, dynamic>> doctors = [
    {
      'image': 'assets/image/Dr.AnjiReddy.jpg',
      'name': 'Dr. Anji Reddy',
      'rating': '4.8',
      'ratingCount': '107 rating',
      'address': 'Annasalai,Tamilnadu-88',
      'specialization': 'Diet Specialist - siddha doctor',
      'fees': '₹500',
    },
  ];

  // Callback to handle the date selection
  void _handleDateSelection(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(screenHeight, screenWidth),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ConstantImageKey.RegisterBg),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...doctors.map((doctor) => _buildImageCard(doctor)).toList(),
                CustomWeekCalendar(onDateSelected: _handleDateSelection),
                SizedBox(
                  height: 10,
                ),
                if (_selectedDate != null)
                  Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 10,
                                spreadRadius: 2),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: 'Available Slots :',
                                    style: Styles.textStyleMedium1(context,
                                        color: AppColor.fillColor),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          ' ${DateFormat('EEE dd MMM').format(_selectedDate!)}',
                                      style: Styles.textStyleMedium1(context,
                                          color: AppColor.yellowColor))
                                ])),
                            Divider(
                              color: Colors.grey.shade400,
                              thickness: 1, // Adjust thickness as needed
                            ),
                            buildSlotSection(
                              context,
                              'Morning',
                              ['10:00 AM', '10:30 AM'],
                            ),
                            Divider(
                              color: Colors.grey.shade400,
                              thickness: 1, // Adjust thickness as needed
                            ),
                            buildSlotSection(context, 'Afternoon', [
                              '12:00 PM',
                              '12:30 PM',
                              '01:00 PM',
                              '01:30 PM'
                            ]),
                            Divider(
                              color: Colors.grey.shade400,
                              thickness: 1, // Adjust thickness as needed
                            ),
                            buildSlotSection(context, 'Evening', [
                              '04:00 PM',
                              '04:30 PM',
                              '05:00 PM',
                              '05:30 PM'
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () =>
                                    AppRouteName.bookingConfirm.push(context),
                                child: Text(
                                  '₹500 Book Now',
                                  style: Styles.textStyleExtraLargeBold(context,
                                      color: AppColor.whiteColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.yellowColor,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                )
              ]),
        )),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double sh, double sw) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30.0),
        ),
        child: AppBar(
          leading: null, // Explicitly remove the default leading icon
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Row(
              children: [
                Container(
                  width: 35, // Diameter of the circle
                  height: 35, // Diameter of the circle
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.whiteColor, // Border color
                      width: 1, // Border thickness
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white, // Color of the icon
                      size: 30, // Size of the icon
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Select time slot",
                    style: Styles.textStyleLarge(
                      context,
                      color: AppColor.whiteColor,
                    ),
                    textScaleFactor: 1,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: AppColor.mainTextColor,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildImageCard(Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Image Section with fixed width
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    doctor['image'],
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Text Section (Right side)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'],
                        style: Styles.textStyleLarge(context),
                        textScaleFactor: 1,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 45,
                            decoration: BoxDecoration(
                                color: AppColor.fillColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doctor['rating'],
                                  style: Styles.textStyleSmall(context,
                                      color: AppColor.whiteColor),
                                  textScaleFactor: 1,
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.star,
                                    color: AppColor.whiteColor, size: 12),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            doctor['ratingCount'],
                            style: Styles.textStyleSmall(context),
                            textScaleFactor: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          doctor['specialization'],
                          style: Styles.textStyleLarge(context),
                          textScaleFactor: 1,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                doctor['address'],
                                style: Styles.textStyleMedium(context),
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fees Section (positioned at top right of the card)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.yellowColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text(
                    "fees",
                    style: Styles.textStyleSmall(context,
                        color: AppColor.whiteColor),
                    textScaleFactor: 1,
                  ),
                  Text(
                    doctor['fees'],
                    style: Styles.textStyleMedium1(context,
                        color: AppColor.blackColor),
                    textScaleFactor: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSlotSection(
      BuildContext context, String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              title == 'Morning'
                  ? Icons.wb_sunny_outlined
                  : title == 'Afternoon'
                      ? Icons.sunny
                      : Icons.nights_stay_outlined,
              color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textScaleFactor: 1,
            ),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSlot = slot; // Update the selected slot
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: selectedSlot == slot
                      ? Colors.orange
                      : Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textScaleFactor: 1,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
