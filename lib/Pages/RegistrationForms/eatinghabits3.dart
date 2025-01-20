import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/styles.dart';

class Eatinghabits3 extends StatefulWidget {
  const Eatinghabits3({super.key});

  @override
  State<Eatinghabits3> createState() => _Eatinghabits3State();
}

class _Eatinghabits3State extends State<Eatinghabits3> {
    MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  double _progressValue = 0.0;
  String _portion = "0 spoon";
  double _previousAngle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
                height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Drag Your Intake Quantity level",style: Styles.textStyleExtraLarge(context,color: AppColor.mainTextColor),),
              SizedBox(height: 60,),
              CircularProgressIndicatorWidget(
                progressValue: _progressValue,
                onUpdateProgress: _updateProgress,
              ),
              const SizedBox(height: 50),
              Text(
                _portion,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to update progress
  void _updateProgress(Offset globalPosition, Offset center) {
    final double dx = globalPosition.dx - center.dx;
    final double dy = globalPosition.dy - center.dy;
    final double angle = (atan2(dy, dx) + pi) / (2 * pi);

    setState(() {
      // Determine the direction of the drag (clockwise or counterclockwise)
      if (angle > _previousAngle) {
        // Clockwise drag (Increase progress only if it's less than 1)
        if (_progressValue < 1.0) {
          _progressValue += (angle - _previousAngle);
        }
      } else {
        // Counterclockwise drag (Decrease progress)
        if (_progressValue > 0.0) {
          _progressValue -= (_previousAngle - angle);
        }
      }

      // Clamp the progress to be between 0 and 1
      _progressValue = _progressValue.clamp(0.0, 1.0);

      // Update the portion text based on progress
      if (_progressValue <= 0.25) {
        _portion = "¼ spoon";
      } else if (_progressValue <= 0.5) {
        _portion = "½ spoon";
      } else if (_progressValue <= 0.75) {
        _portion = "¾ spoon";
      } else {
        _portion = "1 spoon";
      }

      _previousAngle = angle;
    });
  }

  // Function to get the angle for the drag position
  double _getAngle(Offset globalPosition, Offset center) {
    final double dx = globalPosition.dx - center.dx;
    final double dy = globalPosition.dy - center.dy;
    return (atan2(dy, dx) + pi) / (2 * pi); // Return angle in normalized form [0, 1]
  }
}

// Custom progress indicator widget
class CircularProgressIndicatorWidget extends StatelessWidget {
  final double progressValue;
  final Function(Offset globalPosition, Offset center) onUpdateProgress;

  const CircularProgressIndicatorWidget({
    Key? key,
    required this.progressValue,
    required this.onUpdateProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = screenWidth * 0.5; // Size of the progress indicator

    return GestureDetector(
      onPanStart: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final center = box.size.center(box.localToGlobal(Offset.zero));
        onUpdateProgress(details.globalPosition, center);
      },
      onPanUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final center = box.size.center(box.localToGlobal(Offset.zero));
        onUpdateProgress(details.globalPosition, center);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Circle
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
            // Progress Arc
            CustomPaint(
              size: Size(size, size),
              painter: CircularProgressPainter(
                progress: progressValue,
                color: AppColor.fillColor,
              ),
            ),
            // Center Text
            Text(
              '${(progressValue * 100).toInt()}%',
              style: Styles.textStyleExtraHugeBold(
                context,
                color: AppColor.fillColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the progress arc
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.3;

    // Draw background arc
    final bgPaint = Paint()
      ..color = AppColor.mainTextColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 6, bgPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 6),
      -pi / 2, // Start from top
      progress * 2 * pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
