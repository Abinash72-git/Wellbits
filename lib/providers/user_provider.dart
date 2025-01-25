import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'dart:core';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/enums/enum.dart';
import 'package:wellbits/models/api_validation_model.dart';
import 'package:wellbits/models/lifestyle_model.dart';
import 'package:wellbits/models/login_model.dart';
import 'package:wellbits/models/medical_res_model.dart';
import 'package:wellbits/models/profile_model.dart';
import 'package:wellbits/services/api_service.dart';
import 'package:wellbits/services/device_info.dart';
import 'package:wellbits/util/app_constant.dart';
import 'package:wellbits/util/exception.dart';
import 'package:wellbits/util/global.dart';
import 'package:wellbits/util/url_path.dart';

class UserProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isAuthorized = true;
  bool isApiValidationError = false;

  Future<void> initialFetch() async {
    AppGlobal.deviceInfo = await DeviceInfoServices.getDeviceInfo();
  }

  Future<APIResp> sendOTP({
    required String mobile,
  }) async {
    // final String? firebaseToken = await FirebaseMessaging.instance.getToken();
    final resp = await APIService.post(UrlPath.loginUrl.sendOTP,
        data: {
          "phone": mobile,
        },
        showNoInternet: false,
        auth: false,
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 30));
    print(resp.statusCode);
    print("siki----------------------->");
    print(resp.status);
    print("viki------------------>");
    if (resp.status) {
      isApiValidationError = false;
      return resp;
    } else if (!resp.status && resp.data == "Validation Error") {
      AppConstants.apiValidationModel =
          ApiValidationModel.fromJson(resp.fullBody);
      isApiValidationError = true;
      notifyListeners();
      return resp;
    } else {
      throw APIException(
          type: APIErrorType.auth,
          message:
              resp.data?.toString() ?? "Invalid credential.please try again!");
    }
  }

  Future<APIResp> verifyOtpAndLogin({
    required String mobile,
    required String otp,
  }) async {
    final resp = await APIService.post(
      UrlPath.loginUrl.otpVerify,
      data: {
        "phone": mobile.replaceAll(RegExp(r'[^0-9]'), ''),
        "otp": otp,
      },
      showNoInternet: false,
      auth: false,
      forceLogout: false,
      console: true,
      timeout: const Duration(seconds: 30),
    );

    print(resp.statusCode);
    print(resp.status);

    if (resp.status) {
      // Parse the response into LoginModel
      LoginModel data = LoginModel.fromMap(resp.fullBody);

      // If the token exists, save it locally and return
      if (data.token != null && data.token!.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.token, data.token!);
      }

      return resp; // Return the API response
    } else if (!resp.status && resp.data == "Validation Error") {
      AppConstants.apiValidationModel =
          ApiValidationModel.fromJson(resp.fullBody);
      isApiValidationError = true;
      notifyListeners();
      return resp;
    } else {
      throw APIException(
        type: APIErrorType.toast,
        message:
            resp.data?.toString() ?? "Invalid credential. Please try again!",
      );
    }
  }

  Future<APIResp> createProfile({
    required String userName,
    required String dob,
    required String location,
    required String phone,
    required String gender,
    File? userImage,
  }) async {
    print("-----------------Create profile Entry---------------");
    final formattedDob = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(dob),
    );

    final formData = dio.FormData.fromMap({
      "user_name": userName,
      "dateofbirth": formattedDob,
      "location": location,
      "mobile_no": phone,
      "gender": gender,
      if (userImage != null)
        "user_image": await dio.MultipartFile.fromFile(
          userImage.path,
          filename: userImage.path.split('/').last,
        ),
    });

    final resp = await APIService.post(
      UrlPath.loginUrl.createProfile,
      data: formData,
      showNoInternet: false,
      auth: false,
      forceLogout: false,
      console: true,
      timeout: const Duration(seconds: 30),
    );

    print(resp.statusCode);
    print(resp.status);

    if (resp.status) {
      ProfileModel profile = ProfileModel.fromMap(resp.fullBody);

      // Save token locally
      if (profile.token != null && profile.token!.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.token, profile.token!);
      }

      return resp;
    } else {
      throw APIException(
        type: APIErrorType.toast,
        message: resp.data?.toString() ?? "Failed to create profile!",
      );
    }
  }

  Future<APIResp> createMedicalProfile({
    required String? token,
    required double height,
    required double weight,
    required double pressureSystolic,
    required double pressureDiastolic,
    required double triglycerides,
    required double ldl,
    required double hdl,
    required double sugarPre,
    required double sugarPost,
  }) async {
    print("Token from SharedPreferences: $token");
    // Log the token for debugging
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? savedToken = prefs.getString(AppConstants.token);
    // print("Token from SharedPreferences: $savedToken");
    // print("Token used in createMedicalProfile: $token");

    // Prepare the data payload for the request
    final Map<String, dynamic> data = {
      "height": height,
      "weight": weight,
      "pressure_systolic": pressureSystolic,
      "pressure_diastolic": pressureDiastolic,
      "triglycerides": triglycerides,
      "ldl": ldl,
      "hdl": hdl,
      "sugar_pre": sugarPre,
      "sugar_post": sugarPost,
    };

    final String url = '${UrlPath.loginUrl.createMedicalProfile}/$token';
    print("API URL: $url");

    try {
      // Make the POST request
      final APIResp response = await APIService.post(
        url,
        data: data,
        showNoInternet: true, // Enable better handling for no internet
        auth: true,
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      if (response.status) {
        // Parse and handle the success response
        MedicalProfileResponse profile =
            MedicalProfileResponse.fromMap(response.fullBody);

        // Save the total score locally if available
        if (profile.totalScore != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt(AppConstants.TotalScore, profile.totalScore!);
        }

        return response;
      } else {
        // Map the errors to user-friendly messages based on the status code
        switch (response.statusCode) {
          case 404:
            throw APIException(
              type: APIErrorType.toast,
              message: "User not found or token is invalid.",
            );
          case 409:
            throw APIException(
              type: APIErrorType.toast,
              message: "Medical profile already exists for this user.",
            );
          case 422:
            throw APIException(
              type: APIErrorType.toast,
              message: "Validation error: ${response.data?.toString()}",
            );
          case 500:
            throw APIException(
              type: APIErrorType.toast,
              message: "Internal server error. Please try again later.",
            );
          default:
            throw APIException(
              type: APIErrorType.toast,
              message:
                  response.data?.toString() ?? "An unknown error occurred.",
            );
        }
      }
    } catch (e) {
      // Handle unexpected exceptions
      throw APIException(
        type: APIErrorType.toast,
        message: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }

  Future<APIResp> createLifestyleProfile({
     required String? token, // Explicitly pass the token
    required String walking,
    required String workout,
    required String cycling,
    required String swimming,
    required String sports,
    required String smoking,
    required String drinking,
  }) async {
    print("-----------------Create Lifestyle Profile Entry---------------");

   
    final Map<String, dynamic> data = {
       "walking": walking,
      "workout": workout,
      "cycling": cycling,
      "swimming": swimming,
      "sports": sports,
      "smoking": smoking,
      "drinking": drinking,
    };

    final String url = '${UrlPath.loginUrl.creteLifeStyleProfile}/$token';
    print("API URL: $url");
    try {
      final resp = await APIService.post(
        url,
        data: data,
        showNoInternet: false,
        auth: true, // Ensure token is sent in the request headers
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Status: ${resp.status}");

      if (resp.status) {
        // Parse the response body using LifestyleModel
        LifestyleModel lifestyle = LifestyleModel.fromMap(resp.fullBody);

        print("Lifestyle profile created successfully: ${lifestyle.message}");
        print("Lifestyle score: ${lifestyle.lifestyleScore}");

        return resp;
      } else {
       // Map the errors to user-friendly messages based on the status code
        switch (resp.statusCode) {
          case 404:
            throw APIException(
              type: APIErrorType.toast,
              message: "User not found or token is invalid.",
            );
          case 409:
            throw APIException(
              type: APIErrorType.toast,
              message: "LifeStyle profile already exists for this user.",
            );
          case 422:
            throw APIException(
              type: APIErrorType.toast,
              message: "Validation error: ${resp.data?.toString()}",
            );
          case 500:
            throw APIException(
              type: APIErrorType.toast,
              message: "Internal server error. Please try again later.",
            );
          default:
            throw APIException(
              type: APIErrorType.toast,
              message:
                  resp.data?.toString() ?? "An unknown error occurred.",
            );
        }
      }
    } catch (e) {
      // Handle unexpected exceptions
      throw APIException(
        type: APIErrorType.toast,
        message: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }
}
