import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:wellbits/Pages/otp.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/util/app_constant.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';
import 'package:wellbits/util/validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController mobile = TextEditingController();
  bool isChecked = false;
  bool isLoading = false;
  bool isManualInput = false;

  void initState() {
    super.initState();
    getPhoneNumbers();
  }

  Future<void> getPhoneNumbers() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? phoneNumber = await SmsAutoFill().hint;
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        _showPhoneNumberDialog([phoneNumber]);
      } else {
        setState(() {
          isManualInput = true;
        });
      }
    } catch (e) {
      print("Failed to get phone number: $e");
      setState(() {
        isManualInput = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to show a dialog with detected phone numbers
  void _showPhoneNumberDialog(List<String> phoneNumbers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Your Number'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...phoneNumbers.map((phone) {
                  String phoneWithoutCountryCode = phone.length > 10
                      ? phone.substring(phone.length - 10)
                      : phone;

                  return ListTile(
                    title: Text(phoneWithoutCountryCode),
                    onTap: () {
                      setState(() {
                        mobile.text = phoneWithoutCountryCode;
                        isManualInput = false;
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  );
                }).toList(),
                ListTile(
                  title: Text(
                    'None of the above',
                    style: Styles.textStyleMedium(
                      context,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isManualInput = true;
                      mobile.clear(); // Clear text for manual input
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.loginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.45,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          //  textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Mobile\nVerification',
                            style: Styles.textStyleAnimation(
                              context,
                              color: AppColor.mainTextColor,
                            ),
                            children: <TextSpan>[],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Please enter your 10 digit mobile number ',
                              style: Styles.textStyleMedium(
                                context,
                                color: AppColor.hintTextColor,
                              ),
                              children: <TextSpan>[],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment:
                              Alignment.center, // Center the loading indicator
                          children: [
                            TextFormField(
                              textAlign: TextAlign.center,
                              controller: mobile,
                              validator: Validator.validateMobile,
                              keyboardType: TextInputType.number,
                              readOnly: !isManualInput,
                              obscureText: false,
                              onTap: () async {
                                // When the user taps the field, start phone number detection
                                setState(() {
                                  isLoading = true;
                                });
                                await getPhoneNumbers(); // Fetch phone numbers when the field is tapped
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: isManualInput
                                    ? 'Enter your mobile number'
                                    : 'Select your number...',
                                hintStyle: Styles.textStyleLarge(
                                  context,
                                  color: AppColor.whiteColor,
                                ),
                                filled: true,
                                fillColor: AppColor.fillColor,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 30.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide:
                                      BorderSide(color: AppColor.fillColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide(
                                      color: AppColor.fillColor, width: .5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide(
                                      color: AppColor.fillColor, width: .5),
                                ),
                              ),
                              style: Styles.textStyleLarge(
                                context,
                                color: AppColor.whiteColor,
                              ),
                            ),
                            if (isLoading)
                              Positioned(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.06,
                  ),
                  MyButton(
                    text: isLoading ? 'Loading...' : "next".toUpperCase(),
                    textcolor: AppColor.whiteColor,
                    textsize: 23 * (screenWidth / 375),
                    fontWeight: FontWeight.w600,
                    letterspacing: 0.7,
                    buttoncolor: AppColor.mainTextColor,
                    borderColor: AppColor.mainTextColor,
                    buttonheight: 65 * (screenHeight / 812),
                    buttonwidth: screenWidth,
                    radius: 40,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading ? null : login();
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

  login() async {
    // setState(() {
    //   isloading = true;
    // });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.USERMOBILE, mobile.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Otp()),
    );
    // await _con.mobileSendOTP(mobile.text);
    // setState(() {
    //   _con.isloading = false;
    // });
  }
}
