import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/Pages/login.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/helpers/helper.dart';
import 'package:wellbits/util/app_constant.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController otp = TextEditingController();
  TextEditingController mobile = TextEditingController();
  late Timer _timer;
  int _start = 90;
  late Helper hp;
  bool haserror = false;
  bool isLoading = false;
  void initState() {
    super.initState();
    hp = Helper.of(context);
    getdata();
    startTimer();
  }

  getdata() async {
    // Retrieve the mobile number from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMobile = prefs.getString(AppConstants.USERMOBILE);
    print("storedMobile------------------->$storedMobile");
    setState(() {
      mobile.text = storedMobile ?? '';
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String maskMobileNumber(String number) {
    if (number.length >= 10) {
      return '******' + number.substring(6);
    }
    return number;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: context.height,
        width: context.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.OtpBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(
                    height: 300.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          //  textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'OTP\nVerification',
                            style: Styles.textStyleanimation(
                              color: AppColor.mainTextColor,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          //  textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Enter the Otp Sent to  ',
                            style: Styles.textStyleLarge(
                              color: AppColor.hintTextColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: maskMobileNumber(mobile.text),
                                style: Styles.textStyleLarge(
                                  color: AppColor.hintTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      // alignment: Alignment.topCenter,
                      child: PinCodeTextField(
                        pinBoxHeight: 65,
                        pinBoxWidth: 65,
                        pinBoxRadius: 10,
                        autofocus: true,
                        controller: otp,
                        hideCharacter: true,
                        highlight: true,
                        highlightColor: AppColor.fillColor,
                        defaultBorderColor: Colors.grey.withAlpha(1),
                        hasTextBorderColor: Colors.grey.shade300,
                        errorBorderColor: Colors.red,
                        maxLength: 4,
                        hasError: haserror,
                        maskCharacter: "*", //😎
                        onTextChanged: (text) {},
                        onDone: (text) async {},
                        wrapAlignment: WrapAlignment.spaceEvenly,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.roundedPinBoxDecoration,
                        pinTextStyle: const TextStyle(
                          fontSize: 35.0,
                          color: AppColor.whiteColor,
                        ),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinBoxColor: AppColor.fillColor,
                        pinTextAnimatedSwitcherDuration:
                            const Duration(milliseconds: 300),
                        //                    highlightAnimation: true,
                        //highlightPinBoxColor: Colors.red,
                        highlightAnimationBeginColor: Colors.red,
                        highlightAnimationEndColor: Colors.white12,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  GestureDetector(
                    onTap: _start == 0
                        ? () {
                            print(mobile.text);
                            //   _con.resendOTP(mobile.text);
                            setState(() {
                              _start = 90;
                              startTimer();
                            });
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Did not get OTP? ",
                          style: Styles.textStyleMedium(
                            color: AppColor.hintTextColor,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          " Resend Code !",
                          style: Styles.textStyleMedium(
                            color: _start == 0
                                ? AppColor.mainTextColor
                                : Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_start > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '($_start s)',
                              style: Styles.textStyleMedium(
                                  color: AppColor.mainTextColor),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  MyButton(
                    text: isLoading ? 'Loading...' : "next".toUpperCase(),
                    textcolor: AppColor.whiteColor,
                    textsize: 23,
                    fontWeight: FontWeight.w600,
                    letterspacing: 0.7,
                    buttoncolor: AppColor.mainTextColor,
                    borderColor: AppColor.mainTextColor,
                    buttonheight: 65,
                    buttonwidth: context.width,
                    radius: 40,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading
                            ? null
                            : Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Otp()),
                              );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
