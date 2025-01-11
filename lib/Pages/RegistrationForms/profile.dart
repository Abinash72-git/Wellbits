import 'dart:io';
import 'dart:math';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/Pages/intro_page.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/components/button.dart';
import 'package:wellbits/helpers/helper.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/util/app_constant.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/dilogs.dart';
import 'package:wellbits/util/exception.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';
import 'package:wellbits/util/validator.dart';
import 'package:wellbits/widgets/dilogue/dilogue.dart';

class ProfileRegister extends StatefulWidget {
  const ProfileRegister({super.key});

  @override
  State<ProfileRegister> createState() => _ProfileRegisterState();
}

class _ProfileRegisterState extends State<ProfileRegister> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isMaleSelected = true;
  final picker = ImagePicker();
  File? localprofilepic;
  String img64 = '';
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController mobile = TextEditingController();

  bool isLoading = false;

  UserProvider get provider => context.read<UserProvider>();

  void initState() {
    super.initState();
    hp = Helper.of(context);
    getdata();
  }

  Future<void> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile.text = prefs.getString(AppConstants.USERMOBILE) ?? '';
    });
    print(mobile.text);
  }

  void dispose() {
    // Dispose of the controller when not needed
    dateController.dispose();
    location.dispose();
    name.dispose();
    super.dispose();
  }

  bool areAllFieldsFilled() {
    return name.text.isNotEmpty &&
        location.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        (isMaleSelected != null); // Gender must still be selected
  }

  void validateAndContinue() {
    if (formKey.currentState!.validate() && areAllFieldsFilled()) {
      // All fields are valid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterAppPages(tabNumber: 1),
        ),
      );
    } else {
      List<String> missingFields = [];

      // Check individual fields and add to the missing list
      if (name.text.isEmpty) {
        missingFields.add("Name");
      }
      if (dateController.text.isEmpty) {
        missingFields.add("Date of Birth");
      }
      if (location.text.isEmpty) {
        missingFields.add("Location");
      }
      if (localprofilepic == null) {
        missingFields.add("Profile Picture");
      }

      // Display a message if any fields are missing
      Dialogs.snackbar(
        'Please fill all fields: ${missingFields.join(', ')}',
        context,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 'Score' text
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Pro',
                              style: Styles.textStyleHBugeBold(
                                context,
                                color: AppColor.mainTextColor,
                              ).copyWith(fontSize: screenWidth * 0.09),
                              children: [
                                TextSpan(
                                  text: 'file',
                                  style: Styles.textStyleHBugeBold(
                                    context,
                                    color: AppColor.fillColor,
                                  ).copyWith(fontSize: screenWidth * 0.09),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: constraints.maxWidth * 0.4,
                                width: constraints.maxWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: localprofilepic != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          localprofilepic!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Image.asset(
                                          'assets/icons/upload your photo.png',
                                          height: constraints.maxWidth * 0.25,
                                          fit: BoxFit.cover,
                                          color: Colors.black,
                                        ),
                                      ),
                              ),
                              Positioned(
                                right: constraints.maxWidth * 0.02,
                                bottom: constraints.maxWidth * 0.02,
                                child: GestureDetector(
                                  onTap: () {
                                    bottomSheetImage();
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: screenHeight * 0.03,
                                    color: AppColor.mainTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: height / 35,
                  ),

                  TextFormField(
                    controller: name,
                    validator: Validator.notEmpty,
                    style: Styles.textStyleMedium(
                      context,
                      color: AppColor.blackColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColor.mainTextColor,
                        size: 25,
                      ),
                      hintText: 'Enter your Name',
                      hintStyle: Styles.textStyleMedium(
                        context,
                        color: AppColor.hintTextColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey, // Always grey border color
                          width: .5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Always grey border color when enabled
                          width: .5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey, // Grey border when focused
                          width: .5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color:
                              Colors.grey, // Grey border when there's an error
                          width: .5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Grey border when focused and there's an error
                          width: .5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: height / 30,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: mobile,
                    // validator: Validator.notEmpty,
                    style: Styles.textStyleMedium(
                      context,
                      color: AppColor.blackColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColor.mainTextColor,
                        size: 25,
                      ),
                      hintText: 'Enter your Number',
                      hintStyle: Styles.textStyleMedium(
                        context,
                        color: AppColor.hintTextColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey, // Always grey border color
                          width: .5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Always grey border color when enabled
                          width: .5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey, // Grey border when focused
                          width: .5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color:
                              Colors.grey, // Grey border when there's an error
                          width: .5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Grey border when focused and there's an error
                          width: .5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: height / 30,
                  ),
                  // Date of Birth Field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Date of Birth',
                          style: Styles.textStyleExtraLarge(
                            context,
                            color: AppColor.mainTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Open date picker on tap
                      final DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        // Format the selected date as DD/MM/YYYY
                        String formattedDate =
                            "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
                        // Update the controller with the formatted date
                        dateController.text = formattedDate;
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: AppColor.mainTextColor,
                            size: 25,
                          ),
                          hintText: 'DD/MM/YYYY',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType:
                            TextInputType.none, // Disable manual typing
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Gender',
                          style: Styles.textStyleExtraLarge(
                            context,
                            color: AppColor.mainTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Male Selection
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isMaleSelected = true;
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: isMaleSelected
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isMaleSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/MAN.png', // Replace with your female image asset path
                                  height: 40,
                                ),
                                const SizedBox(height: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Male',
                                    style: Styles.textStyleMedium(
                                      context,
                                      color: AppColor.mainTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          width: 10), // Spacing between Male and Female

                      // Female Selection
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isMaleSelected = false;
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: !isMaleSelected
                                  ? Colors.pink.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: !isMaleSelected
                                    ? Colors.pink
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/woman.png',
                                  height: 40,
                                ),
                                const SizedBox(height: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Female',
                                    style: Styles.textStyleMedium(
                                      context,
                                      color: AppColor.mainTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 20,
                  ),

                  // Location Field
                  TextFormField(
                    controller: location,
                    validator: Validator.notEmpty,
                    style: Styles.textStyleMedium(
                      context,
                      color: AppColor.blackColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColor.mainTextColor,
                        size: 25,
                      ),
                      hintText: 'Location',
                      hintStyle: Styles.textStyleMedium(
                        context,
                        color: AppColor.hintTextColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey, // Always grey border color
                          width: .5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: .5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: .5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: .5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: .5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  MyButton(
                    text: isLoading ? 'Loading...' : "next".toUpperCase(),
                    textcolor: AppColor.whiteColor,
                    textsize: 23 * (screenWidth / 375),
                    fontWeight: FontWeight.w600,
                    letterspacing: 0.7,
                    buttoncolor: AppColor.fillColor,
                    borderColor: AppColor.fillColor,
                    buttonheight: 65 * (screenHeight / 812),
                    buttonwidth: screenWidth,
                    radius: 40,
                    // onTap: () async {
                    //   if (formKey.currentState!.validate() &&
                    //       areAllFieldsFilled()) {
                    //     FocusScope.of(context).unfocus();
                    //     try {
                    //       await AppDialogue.openLoadingDialogAfterClose(
                    //         context,
                    //         text: "Creating Profile...",
                    //         load: () async {
                    //           String gender =
                    //               isMaleSelected ? "male" : "female";
                    //           return await provider.createProfile(
                    //             userName: name.text,
                    //             dob: dateController.text,
                    //             location: location.text,
                    //             phone: mobile.text,
                    //             gender: gender,
                    //             userImage: localprofilepic,
                    //           );
                    //         },
                    //         afterComplete: (resp) async {
                    //           if (resp.status) {
                    //             print("Profile created successfully!");
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     RegisterAppPages(tabNumber: 1),
                    //               ),
                    //             );
                    //           } else {
                    //             AppDialogue.toast(
                    //                 "Failed to create profile. Please try again!");
                    //           }
                    //         },
                    //       );
                    //     } on Exception catch (e) {
                    //       ExceptionHandler.showMessage(context, e);
                    //     }
                    //   } else {
                    //     AppDialogue.toast("Please fill all fields!");
                    //   }
                    // },
                    onTap: () async {
                      //validateAndContinue();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterAppPages(tabNumber: 1),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomSheetImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: AppColor.fillColor,
                      ),
                      title: Text(
                        'Photo Library',
                        style: Styles.textStyleLarge(context,
                            color: AppColor.mainTextColor),
                      ),
                      onTap: () {
                        getPicFromGallery();
                      }),
                  ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: AppColor.fillColor,
                      ),
                      title: Text(
                        'Camera',
                        style: Styles.textStyleLarge(context,
                            color: AppColor.mainTextColor),
                      ),
                      onTap: () {
                        getPicFromCam();
                      }),
                ],
              ),
            ),
          );
        });
  }

  Future getPicFromCam() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        localprofilepic = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
    _cropImage();
  }

  Future getPicFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        localprofilepic = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
    _cropImage();
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: localprofilepic!.path,
      // cropStyle: CropStyle.rectangle, // You can change this to circle if needed
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColor.mainTextColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColor.mainTextColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        localprofilepic = File(croppedFile.path);
      });

      // Convert image to bytes if needed
      final bytes = await Io.File(localprofilepic!.path).readAsBytes();
    }
  }
}
