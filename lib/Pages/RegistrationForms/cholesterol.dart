import 'package:flutter/material.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class Cholesterol extends StatefulWidget {
  final void Function(double triglycerides, double ldl, double hdl)
      onCholesterolChanged;
  const Cholesterol({super.key, required this.onCholesterolChanged});
  @override
  State<Cholesterol> createState() => _CholesterolState();
}

class _CholesterolState extends State<Cholesterol> {
  final TextEditingController triglyceridesController = TextEditingController();
  final TextEditingController ldlController = TextEditingController();
  final TextEditingController hdlController = TextEditingController();

  // Initial levels for each type
  double triglyceridesLevel = 120.0;
  double ldlLevel = 120.0;
  double hdlLevel = 120.0;

  @override
  void initState() {
    super.initState();

    // Initialize text fields with default values
    triglyceridesController.text = triglyceridesLevel.toStringAsFixed(0);
    ldlController.text = ldlLevel.toStringAsFixed(0);
    hdlController.text = hdlLevel.toStringAsFixed(0);
  }

  void _updateCholesterolLevel(double triglycerides, double ldl, double hdl) {
    widget.onCholesterolChanged(triglycerides, ldl, hdl);
  }

 void _updateLevel(String value, String type) {
    double? enteredValue = double.tryParse(value);
    if (enteredValue != null && enteredValue >= 80 && enteredValue <= 150) {
      setState(() {
        if (type == "triglycerides") {
          triglyceridesLevel = enteredValue;
        } else if (type == "ldl") {
          ldlLevel = enteredValue;
        } else if (type == "hdl") {
          hdlLevel = enteredValue;
        }
      });
      widget.onCholesterolChanged(triglyceridesLevel, ldlLevel, hdlLevel);
    } else {
      setState(() {
        if (type == "triglycerides") {
          triglyceridesController.text = triglyceridesLevel.toStringAsFixed(0);
        } else if (type == "ldl") {
          ldlController.text = ldlLevel.toStringAsFixed(0);
        } else if (type == "hdl") {
          hdlController.text = hdlLevel.toStringAsFixed(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildCholesterolCard(
            title: "Triglycerides",
            type: "triglycerides",
            level: triglyceridesLevel,
            controller: triglyceridesController,
          ),
          buildCholesterolCard(
            title: "LDL Cholesterol",
            type: "ldl",
            level: ldlLevel,
            controller: ldlController,
          ),
          buildCholesterolCard(
            title: "HDL Cholesterol",
            type: "hdl",
            level: hdlLevel,
            controller: hdlController,
          ),
        ],
      ),
    );
  }

  Widget buildCholesterolCard({
    required String title,
    required String type,
    required double level,
    required TextEditingController controller,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Styles.textStyleExtraLarge(
                    context,
                    color: AppColor.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Center(
          //   child: FittedBox(
          //     fit: BoxFit.scaleDown,
          //     child: Text(
          //       "${level.toStringAsFixed(0)} mg",
          //       style: Styles.textStyleExtraLarge(
          //         context,
          //         color: AppColor.mainTextColor,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: AppColor.mainTextColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    // Calculate the new width based on the drag
                    double dragWidth = ((level - 80) / 70) * screenWidth * 0.7;
                    dragWidth += details.primaryDelta ?? 0;

                    // Convert dragWidth back to a cholesterol level
                    double newLevel =
                        80 + ((dragWidth / (screenWidth * 0.7)) * 70);
                    newLevel = newLevel.clamp(80, 150);

                    // Update the level and the text field
                    if (type == "triglycerides") {
                      triglyceridesLevel = newLevel;
                      controller.text = triglyceridesLevel.toStringAsFixed(0);
                    } else if (type == "ldl") {
                      ldlLevel = newLevel;
                      controller.text = ldlLevel.toStringAsFixed(0);
                    } else if (type == "hdl") {
                      hdlLevel = newLevel;
                      controller.text = hdlLevel.toStringAsFixed(0);
                    }
                  });
                   widget.onCholesterolChanged(triglyceridesLevel, ldlLevel, hdlLevel);
                },
                child: Container(
                  width: ((level - 80) / 70) *
                      screenWidth *
                      0.7, // Adjust width based on range
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColor.fillColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              8,
              (index) => Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${80 + (index * 10)}", // Labels for increments of 10
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColor.mainTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Cholesterol Level",
                  style: Styles.textStyleSmall(
                    context,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 100,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.mainTextColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    suffixText: "mg",
                    suffixStyle: Styles.textStyleLarge(
                      context,
                      color: Colors.white,
                    ),
                  ),
                  style: Styles.textStyleLarge(
                    context,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  onSubmitted: (value) => _updateLevel(value, type),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
