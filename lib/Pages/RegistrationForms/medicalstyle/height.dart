import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class HeightRegister extends StatefulWidget {
 final void Function(double, bool) onHeightChanged; // Callback to notify height and unit
  const HeightRegister({super.key, required this.onHeightChanged});

  @override
  State<HeightRegister> createState() => _HeightRegisterState();
}

class _HeightRegisterState extends State<HeightRegister> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  double currentHeightCM = 158;
  double currentHeightFt = 5.2; // Use this only for feet

  bool isCMSelected = true;

  String getHeightDisplay() {
    // Display either in cm or ft based on the selection
    if (isCMSelected) {
      return "${currentHeightCM.toStringAsFixed(1)} cm"; // Show accurate cm with decimals
    } else {
      int feet = currentHeightFt.floor();
      int inches = ((currentHeightFt - feet) * 12)
          .round(); // Convert decimal feet to inches
      return "$feet' $inches\""; // Show feet and inches
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double minImageHeight = screenHeight * 0.2; // minimum image height
    double maxImageHeight = screenHeight * 0.47; // maximum image height
    double imageHeight;

    if (isCMSelected) {
      imageHeight = minImageHeight +
          ((currentHeightCM - 80) / 120) *
              (maxImageHeight - minImageHeight); // Scale between min and max
    } else {
      imageHeight = minImageHeight +
          ((currentHeightFt - 3.0) / 6.0) *
              (maxImageHeight - minImageHeight); // Scale based on feet range
    }

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "What’s your Height?",
            style: Styles.textStyleExtraLarge(
              context,
              color: AppColor.mainTextColor,
            ).copyWith(fontSize: screenWidth * 0.06),
          ),
        ),
        const SizedBox(height: 20),
        ToggleSwitch(
          minWidth: screenWidth * 0.15,
          cornerRadius: 40.0,
          activeBgColors: [
            [AppColor.fillColor],
            [AppColor.fillColor]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: AppColor.mainTextColor,
          inactiveFgColor: Colors.white,
          initialLabelIndex: isCMSelected ? 0 : 1,
          totalSwitches: 2,
          labels: ['CM', 'FT'],
          radiusStyle: true,
          onToggle: (index) {
            setState(() {
              isCMSelected = index == 0;
            });
          },
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Image.asset(
                'assets/icons/men.png',
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 70),
            Flexible(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.18, // Responsive width
                    height: screenHeight * 0.45, // Responsive height
                    child: isCMSelected
                        ? CustomHeightScaler(
                            onHeightChanged: (height) {
                              setState(() {
                                currentHeightCM = height;
                              });
                             widget.onHeightChanged(height, true);
                            },
                          )
                        : CustomHeightScaler1(
                            onHeightChanged: (height) {
                              setState(() {
                                currentHeightFt = height;
                              });
                               widget.onHeightChanged(height, false);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomHeightScaler extends StatefulWidget {
  final Function(double) onHeightChanged;

  const CustomHeightScaler({Key? key, required this.onHeightChanged})
      : super(key: key);

  @override
  State<CustomHeightScaler> createState() => _CustomHeightScalerState();
}

class _CustomHeightScalerState extends State<CustomHeightScaler> {
  double valueCM = 158; // Initial value
  final double minHeight = 80; // Minimum height value
  final double maxHeight = 200; // Maximum height value
  final double tickSpacing = 10.0; // Spacing between each tick in pixels
  double lineYPosition = 15; // Initial position of the draggable line

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          lineYPosition += details.primaryDelta!; // Move the line with the drag
          lineYPosition = lineYPosition.clamp(
              0.0,
              context.size!
                  .height); // Clamp to prevent it from going out of bounds
          valueCM = maxHeight -
              ((maxHeight - minHeight) *
                  (lineYPosition /
                      context.size!.height)); // Reverse the height calculation
          valueCM = valueCM.clamp(minHeight,
              maxHeight); // Clamp the value between min and max heights
        });
        widget.onHeightChanged(
            valueCM); // Notify parent widget of the height change
      },
      child: CustomPaint(
        painter: RulerPainter(
          valueCM,
          minHeight,
          maxHeight,
          tickSpacing,
          lineYPosition,
          context,
        ),
        child: Container(
          height: 400,
          width: 70,
        ),
      ),
    );
  }
}

class RulerPainter extends CustomPainter {
  final double valueCM;
  final double minHeight;
  final double maxHeight;
  final double tickSpacing;
  final double lineYPosition;
  final BuildContext context;

  RulerPainter(
    this.valueCM,
    this.minHeight,
    this.maxHeight,
    this.tickSpacing,
    this.lineYPosition,
    this.context,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = 0.4;

    Paint bigLinePaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = 1;

    // Draw tick marks and height values in cm
    for (double i = minHeight; i <= maxHeight; i += 0.5) {
      double yPos = size.height -
          (i - minHeight) * (size.height / (maxHeight - minHeight));

      double lineLength;
      if (i % 10 == 0) {
        // Major tick for every 10 cm
        lineLength = size.width;
        canvas.drawLine(Offset(size.width - lineLength, yPos),
            Offset(size.width, yPos), bigLinePaint);

        double availableWidth = size.width * 0.2;
        double availableHeight = 20;

        double fontSize = 14; // Starting font size for text
        TextPainter textPainter;
        // Draw the centimeter values
        do {
          textPainter = TextPainter(
            text: TextSpan(
              text: "${i.toInt()} cm", // Display the centimeter values
              style: Styles.textStyleSmall(
                context,
                color: AppColor.mainTextColor,
              ).copyWith(fontSize: fontSize),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();

          // Reduce the font size if the text exceeds the available width or height
          fontSize -= 0.5;
        } while ((textPainter.width > availableWidth ||
                textPainter.height > availableHeight) &&
            fontSize > 15); // Limit to a minimum font size

// Paint the text at the desired position on the canvas
        textPainter.paint(
          canvas,
          Offset(size.width - lineLength - textPainter.width - 5,
              yPos - textPainter.height / 2),
        );
      } else if (i % 1 == 0) {
        // Minor tick for every 1 cm
        lineLength = size.width / 3;
        canvas.drawLine(Offset(size.width - lineLength, yPos),
            Offset(size.width, yPos), linePaint);
      }
    }

    // Horizontal draggable line
    Paint markerPaint = Paint()
      ..color = AppColor.fillColor
      ..strokeWidth = 2.0;

    double adjustedLineStartX = -70;
    canvas.drawLine(
      Offset(adjustedLineStartX, lineYPosition),
      Offset(size.width, lineYPosition),
      markerPaint,
    );

    // Draw the draggable circle with the arrow inside
    double circleRadius = 15.0;
    double circleCenterX = 20;

// Draw the shadow circle
    Paint shadowPaint = Paint()
      ..color =
          Colors.grey.withOpacity(0.2) // Shadow color with some transparency
      ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, 4); // Adds a blur effect to the shadow

    canvas.drawCircle(
      Offset(circleCenterX, lineYPosition),
      circleRadius + 5, // Make the shadow circle slightly larger
      shadowPaint,
    );

// Draw the main circle
    Paint circlePaint = Paint()..color = Colors.white;

    canvas.drawCircle(
      Offset(circleCenterX, lineYPosition),
      circleRadius,
      circlePaint,
    );

    Paint arrowPaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Path arrowPath = Path();
    arrowPath.moveTo(circleCenterX + 5, lineYPosition - 5);
    arrowPath.lineTo(circleCenterX - 5, lineYPosition);
    arrowPath.lineTo(circleCenterX + 5, lineYPosition + 5);
    canvas.drawPath(arrowPath, arrowPaint);

    // Display the height text (fixed at the top of the ruler)
    double availableWidth = size.width * 0.25; // Adjust as needed
    double availableHeight = 30; // Adjust as needed for the text height

// Define a base font size and decrease it until the text fits within the available space
    double fontSize = 20; // Starting font size
    TextPainter heightTextPainter;
    do {
      heightTextPainter = TextPainter(
        text: TextSpan(
          text: "${valueCM.toStringAsFixed(1)} cm", // Display cm
          style: Styles.textStyleLarge(
            color: AppColor.mainTextColor,
            context,
          ).copyWith(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      );
      heightTextPainter.layout();

      // Decrease font size if the text exceeds available width or height
      fontSize -= 1;
    } while ((heightTextPainter.width > availableWidth ||
            heightTextPainter.height > availableHeight) &&
        fontSize > 15); // Minimum font size limit

// Paint the text at a specific position on the canvas
    heightTextPainter.paint(canvas, Offset(-150, -20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomHeightScaler1 extends StatefulWidget {
  final Function(double) onHeightChanged;

  const CustomHeightScaler1({Key? key, required this.onHeightChanged})
      : super(key: key);

  @override
  State<CustomHeightScaler1> createState() => _CustomHeightScaler1State();
}

class _CustomHeightScaler1State extends State<CustomHeightScaler1> {
  double valueFt = 5.0; // Initial value in feet
  final double minHeight = 3.0; // Minimum height in feet
  final double maxHeight = 9.0; // Maximum height in feet (updated to 9 feet)
  double lineYPosition = 0; // Initial position of the draggable line

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          lineYPosition += details.primaryDelta!;
          lineYPosition = lineYPosition.clamp(
              0.0, context.size!.height); // Clamp the drag position

          // Correct the reverse calculation and update the feet based on drag position
          valueFt = minHeight +
              ((maxHeight - minHeight) *
                  (lineYPosition / context.size!.height));
          valueFt = valueFt.clamp(
              minHeight, maxHeight); // Clamp the value within the range
        });

        widget.onHeightChanged(
            valueFt); // Notify the parent widget of the height change
      },
      child: CustomPaint(
        painter: FeetScalePainter(
          valueFt: valueFt,
          minHeight: minHeight,
          maxHeight: maxHeight,
          lineYPosition: lineYPosition,
          onHeightChanged: widget.onHeightChanged,
          context: context,
        ),
        child: Container(
          height: 400,
          width: 70,
        ),
      ),
    );
  }
}

class FeetScalePainter extends CustomPainter {
  final double valueFt;
  final double minHeight;
  final double maxHeight;
  final double lineYPosition;
  final Function(double) onHeightChanged;
  final BuildContext context;

  FeetScalePainter({
    required this.valueFt,
    required this.minHeight,
    required this.maxHeight,
    required this.lineYPosition,
    required this.onHeightChanged,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = 0.5;

    Paint bigLinePaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = 1.5;

    double startX = size.width * 0.2;
    double endX = size.width;
    double lineSpacing = size.height /
        72; // 72 intervals for 6 feet (9 feet total with 12 inch intervals)

    // Draw foot and inch lines from 3 feet to 9 feet
    for (int i = 0; i <= 72; i++) {
      double yPosition = i * lineSpacing;

      if (i % 12 == 0) {
        // Major tick for each full foot (e.g., 3'0", 4'0", ..., 9'0")
        canvas.drawLine(
            Offset(startX, yPosition), Offset(endX, yPosition), bigLinePaint);

        double availableWidth = size.width * 0.2; // Adjust for desired fit
        double fontSize = 14; // Starting font size
        TextPainter tp;

        do {
          tp = TextPainter(
            text: TextSpan(
              text: "${(minHeight + (i ~/ 12)).toInt()}'",
              style: Styles.textStyleSmall(
                context,
                color: AppColor.mainTextColor,
              ).copyWith(fontSize: fontSize),
            ),
            textDirection: TextDirection.ltr,
          );
          tp.layout();

          fontSize -= 0.5;
        } while (tp.width > availableWidth && fontSize > 8);

        tp.paint(
            canvas, Offset(startX - 40, yPosition - 8)); // Adjust text position
      } else if (i % 1 == 0) {
        // Minor tick for each inch
        double shortEndX = size.width * 0.7;
        canvas.drawLine(
            Offset(startX, yPosition), Offset(shortEndX, yPosition), linePaint);
      }
    }

    // Draw the draggable line
    Paint markerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0;

    double adjustedLineStartX = -70;
    canvas.drawLine(
      Offset(adjustedLineStartX, lineYPosition),
      Offset(size.width, lineYPosition),
      markerPaint,
    );

    // Draw the draggable circle with the arrow inside
    double circleRadius = 15.0;
    double circleCenterX = 20;

// Draw the shadow circle
    Paint shadowPaint = Paint()
      ..color =
          Colors.grey.withOpacity(0.2) // Shadow color with some transparency
      ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, 4); // Adds a blur effect to the shadow

    canvas.drawCircle(
      Offset(circleCenterX, lineYPosition),
      circleRadius + 5, // Make the shadow circle slightly larger
      shadowPaint,
    );

// Draw the main circle
    Paint circlePaint = Paint()..color = Colors.white;

    canvas.drawCircle(
      Offset(circleCenterX, lineYPosition),
      circleRadius,
      circlePaint,
    );

    Paint arrowPaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Path arrowPath = Path();
    arrowPath.moveTo(circleCenterX + 5, lineYPosition - 5);
    arrowPath.lineTo(circleCenterX - 5, lineYPosition);
    arrowPath.lineTo(circleCenterX + 5, lineYPosition + 5);
    canvas.drawPath(arrowPath, arrowPaint);

    // Display the height text (fixed at the top of the ruler)
    double availableWidthHeightText = 70; // Adjust for available width
    double fontSizeHeightText = 18; // Starting font size for height text

    TextPainter heightTextPainter;
    do {
      heightTextPainter = TextPainter(
        text: TextSpan(
          text: "${getFeetAndInches(valueFt)} ft",
          style: Styles.textStyleLarge(
            context,
            color: AppColor.mainTextColor,
          ).copyWith(fontSize: fontSizeHeightText),
        ),
        textDirection: TextDirection.ltr,
      );
      heightTextPainter.layout();

      fontSizeHeightText -= 0.5;
    } while (heightTextPainter.width > availableWidthHeightText &&
        fontSizeHeightText > 10);

    heightTextPainter.paint(canvas, Offset(-135, -20));
  }

  // Helper function to convert feet and inches to string
  String getFeetAndInches(double feet) {
    int wholeFeet = feet.floor();
    int inches = ((feet - wholeFeet) * 12).round();
    return "$wholeFeet' $inches\'";
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
