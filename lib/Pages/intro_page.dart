import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wellbits/Pages/login.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> with SingleTickerProviderStateMixin {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _dragValue = 0.0;
  bool _isUserDragging = false; // To track if the user has started dragging
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Create an animation that moves back and forth automatically
    _animation = Tween<double>(begin: 0, end: 0.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (!_isUserDragging) {
          // Repeat the animation if the user hasn't started dragging
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _animationController.forward();
            HapticFeedback.vibrate(); // Provide haptic feedback while moving
          }
        }
      });

    // Start the automatic animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonWidth = screenWidth - 80;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.IntroBg),
            fit: BoxFit.cover,
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                 SizedBox(height: screenHeight*0.8),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background container for the slider
                        Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                AppColor.fillColor, // Keep your original color
                          ),
                        ),
                        // Moving circle arrow
                        Positioned(
                          left: (_isUserDragging
                                  ? _dragValue
                                  : _animation.value) *
                              (buttonWidth - 50), // Automatic or manual drag
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                _isUserDragging =
                                    true; // Stop automatic movement
                                _dragValue +=
                                    details.primaryDelta! / buttonWidth;
                                // Clamp the drag value to ensure it stays within bounds
                                if (_dragValue < 0) _dragValue = 0;
                                if (_dragValue > 1) _dragValue = 1;
                              });
                            },
                            onHorizontalDragEnd: (details) {
                              if (_dragValue >= 0.1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              } else {
                                // If not dragged far enough, reset and resume auto movement
                                setState(() {
                                  _dragValue = 0; // Reset drag value
                                  _isUserDragging =
                                      false; // Resume automatic movement
                                  _animationController
                                      .forward(); // Restart animation
                                });
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(
                                      0.3), // Semi-transparent circle
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color:
                                      AppColor.whiteColor, // Your custom color
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Centered text
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Let's Start",
                            style: Styles.textStyleExtraLargeBold(context,
                              color:
                                  AppColor.whiteColor, // Your custom text color
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Text(
                //         'Dont have an account ?',
                //         style: Styles.textStyleLarge(
                //           color: AppColor.mainTextColor,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Text(
                //         'Register now ',
                //         style: Styles.textStyleLarge(
                //           color: AppColor.fillColor,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
