import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: context.height,
        width: context.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.IntroBg),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
