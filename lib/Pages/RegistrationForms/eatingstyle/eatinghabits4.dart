import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_balloon_slider/flutter_balloon_slider.dart";
import "package:wellbits/util/color_constant.dart";
import "package:wellbits/util/constant_image.dart";
import "package:wellbits/util/styles.dart";

class Eatinghabits4 extends StatefulWidget {
  const Eatinghabits4({super.key});

  @override
  State<Eatinghabits4> createState() => _Eatinghabits4State();
}

class _Eatinghabits4State extends State<Eatinghabits4> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  final ValueNotifier<double> _sliderValue = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Set Your Chewing Time For Your Each Intake",
              style: Styles.textStyleExtraLarge(
                context,
                color: AppColor.mainTextColor,
              ),
            ),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                "assets/image/chewing.jpg",
                width: 150.0,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // BalloonSlider Widget
            _balloonSlider(
              sliderValue: _sliderValue,
              color: AppColor.fillColor,
              showRope: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _balloonSlider({
    required ValueNotifier<double> sliderValue,
    required Color color,
    required bool showRope,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 260,
          height: 200,
          child: BalloonSlider(
            value: sliderValue.value,
            onChanged: (val) {
              sliderValue.value = val;
            },
            showRope: showRope,
            ropeLength: 64.0,
            color: color,
          ),
        ),
        Positioned(
          bottom: 0,
          child: ValueListenableBuilder<double>(
            valueListenable: sliderValue,
            builder: (context, value, child) {
              // Scale the value to range from 0 to 10
              int progress = (value * 10).round();
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: AppColor.mainTextColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  '$progress mins',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
