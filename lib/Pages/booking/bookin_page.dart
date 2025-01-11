import 'package:flutter/material.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class BookinPage extends StatefulWidget {
  const BookinPage({super.key});

  @override
  State<BookinPage> createState() => _BookinPageState();
}

class _BookinPageState extends State<BookinPage> {
  // List of doctor data with all required information
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
    {
      'image': 'assets/image/doctor.jpg',
      'name': 'Dr. Sarah Smith',
      'rating': '4.5',
      'ratingCount': '75 rating',
      'address': 'AnnaNagar,Tamilnadu-10',
      'specialization': 'Diet Specialist - MBBS',
      'fees': '₹700',
    },
    {
      'image': 'assets/image/Dr.AnjiReddy.jpg',
      'name': 'Dr. Anji Reddy',
      'rating': '4.8',
      'ratingCount': '107 rating',
      'address': 'Annasalai,Tamilnadu-88',
      'specialization': 'Diet Specialist - siddha doctor',
      'fees': '₹500',
    },
    {
      'image': 'assets/image/doctor.jpg',
      'name': 'Dr. Sarah Smith',
      'rating': '4.5',
      'ratingCount': '75 rating',
      'address': 'AnnaNagar,Tamilnadu-10',
      'specialization': 'Diet Specialist - MBBS',
      'fees': '₹700',
    },
    {
      'image': 'assets/image/Dr.AnjiReddy.jpg',
      'name': 'Dr. Anji Reddy',
      'rating': '4.8',
      'ratingCount': '107 rating',
      'address': 'Annasalai,Tamilnadu-88',
      'specialization': 'Diet Specialist - siddha doctor',
      'fees': '₹500',
    },
    {
      'image': 'assets/image/doctor.jpg',
      'name': 'Dr. Sarah Smith',
      'rating': '4.5',
      'ratingCount': '75 rating',
      'address': 'AnnaNagar,Tamilnadu-10',
      'specialization': 'Diet Specialist - MBBS',
      'fees': '₹700',
    },
    {
      'image': 'assets/image/Dr.AnjiReddy.jpg',
      'name': 'Dr. Anji Reddy',
      'rating': '4.8',
      'ratingCount': '107 rating',
      'address': 'Annasalai,Tamilnadu-88',
      'specialization': 'Diet Specialist - siddha doctor',
      'fees': '₹500',
    },
    {
      'image': 'assets/image/doctor.jpg',
      'name': 'Dr. Sarah Smith',
      'rating': '4.5',
      'ratingCount': '75 rating',
      'address': 'AnnaNagar,Tamilnadu-10',
      'specialization': 'Diet Specialist - MBBS',
      'fees': '₹700',
    },
    {
      'image': 'assets/image/Dr.AnjiReddy.jpg',
      'name': 'Dr. Anji Reddy',
      'rating': '4.8',
      'ratingCount': '107 rating',
      'address': 'Annasalai,Tamilnadu-88',
      'specialization': 'Diet Specialist - siddha doctor',
      'fees': '₹500',
    },
    {
      'image': 'assets/image/doctor.jpg',
      'name': 'Dr. Sarah Smith',
      'rating': '4.5',
      'ratingCount': '75 rating',
      'address': 'AnnaNagar,Tamilnadu-10',
      'specialization': 'Diet Specialist - MBBS',
      'fees': '₹700',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(screenHeight, screenWidth),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ConstantImageKey.RegisterBg),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return _buildImageCard(doctors[index]);
          },
        ),
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
                  Image.asset(
                    'assets/icons/operator.png',
                    height: 40,
                    width: 40,
                    color: AppColor.whiteColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Book an Experts",
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
        ));
  }

  // Modified method to accept doctor data
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
                    height: 160,
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
                        style: Styles.textStyleMedium1(context),
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
                                  style: Styles.textStyleExtraSmall(context,
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
                          style: Styles.textStyleMedium(context),
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
                                style: Styles.textStyleSmall1(context),
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => AppRouteName.slotPage.push(context),
                        child: Text(
                          'Book Appointment',
                          style: Styles.textStyleSmall(context,
                              color: AppColor.whiteColor),
                          textScaleFactor: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.mainTextColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Reduce the radius here
                          ),
                        ),
                      )
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
}
