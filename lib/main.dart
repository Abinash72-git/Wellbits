import 'package:flutter/material.dart';
import 'package:wellbits/app.dart';
import 'package:wellbits/config/app_intialize.dart';

Future<void> main() async {
  await AppInitialize.start();
  runApp( MyApp());
}

