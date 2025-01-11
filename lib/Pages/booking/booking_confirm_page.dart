import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class BookingConfirmPage extends StatefulWidget {
  const BookingConfirmPage({super.key});

  @override
  State<BookingConfirmPage> createState() => _BookingConfirmPageState();
}

class _BookingConfirmPageState extends State<BookingConfirmPage> {
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  doctorDetailsCard(context),
                  SizedBox(
                    height: 25,
                  ),
                  slottiming(context),
                  SizedBox(
                    height: 25,
                  ),
                  feesDetails(context)
                ],
              ),
            ),
          ),
        ));
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

  Widget doctorDetailsCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 227, 227),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(10), // Add padding around the text
          child: Text(
            "Doctor Details",
            style: Styles.textStyleLarge(context),
          ),
        ),
        Container(
          height: 1, // Height of the line
          color: const Color.fromARGB(
              255, 179, 177, 177), // Same color as above container
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/image/Dr.AnjiReddy.jpg',
                  width: 80, // adjust the size of the image
                  height: 80, // adjust the size of the image
                  fit: BoxFit
                      .cover, // ensures the image covers the circle properly
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr.G.Sivaraman",
                    style: Styles.textStyleExtraLarge(context),
                  ),
                  Text(
                    "Diet Specialist",
                    style: Styles.textStyleMedium(context),
                  ),
                  Text(
                    "-Ayurvedha Siddhartha Doctor",
                    style: Styles.textStyleMedium(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget slottiming(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 227, 227),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(10), // Add padding around the text
          child: Text(
            "Slot Date / Time",
            style: Styles.textStyleLarge(context),
          ),
        ),
        Container(
          height: 1, // Height of the line
          color: const Color.fromARGB(
              255, 179, 177, 177), // Same color as above container
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "30 November 2024",
                style: Styles.textStyleLarge(context),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.sunny,
                    size: 30,
                  ),
                  Text(
                    "Morning",
                    style: Styles.textStyleMedium1(context),
                  ),
                  Text(
                    "- 10.00 Am",
                    style: Styles.textStyleMedium1(context),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget feesDetails(BuildContext context) {
    Widget feeRow(String label, String amount, TextStyle style) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Text(label, style: style),
            Spacer(),
            Text(amount, style: style),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 227, 227),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            "Fees Details",
            style: Styles.textStyleLarge(context),
          ),
        ),
        Container(
          height: 1,
          color: const Color.fromARGB(255, 179, 177, 177),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              feeRow("Consultation Fee", "-   928.00",
                  Styles.textStyleMedium1(context)),
              feeRow("GST(5%)", "-   50.00", Styles.textStyleMedium1(context)),
              feeRow(
                  "Service Tax", "-   12.00", Styles.textStyleMedium1(context)),
              Row(
                children: [
                  Text("Total Fees",
                      style: Styles.textStyleExtraLarge(context)),
                  Spacer(),
                  Text('=', style: Styles.textStyleExtraLarge(context)),
                  Spacer(),
                  Column(
                    children: [
                      Container(height: 1, width: 80, color: Colors.black),
                      Text("1000.00",
                          style: Styles.textStyleExtraLarge(context)),
                      Container(height: 1, width: 80, color: Colors.black),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              customButton(
                context,
                "Pay Now",
                () {
                  // Handle button press
                  print("Pay Now button pressed");
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget customButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.yellowColor,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 90),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: onPressed,
        child: Text(label,
            style: Styles.textStyleExtraLarge(context,
                color: AppColor.whiteColor)),
      ),
    );
  }
}
