import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Wellbits';

  //API URL Constants
  // static const String BASE_URL = 'https://new.dev-healthplanner.xyz/api/'; //Dev
  static const String BASE_URL =
      'https://upgrade.test-healthplanner.xyz/api/'; //Prod

  // static final String BASE_URL = AppConfig.instance.baseUrl;

  static Map<String, String> headers = {
    //"X-API-KEY": "OpalIndiaKeysinUse",
    'Charset': 'utf-8',
    'Accept': 'application/json',
  };
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static const String USERMOBILE = 'user_mobile';
   static const String APPPAGES = '/app_pages';
}
