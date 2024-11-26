import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class PressureRegister extends StatefulWidget {
  final void Function(double, double, double) onPressureChanged;
  const PressureRegister({super.key, required this.onPressureChanged});

  @override
  State<PressureRegister> createState() => _PressureRegisterState();
}

class _PressureRegisterState extends State<PressureRegister> {
  @override
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  double _systolicLevel = 120.0;
  double _diastolicLevel = 80.0;
  final TextEditingController cholesterol = TextEditingController();
  double _cholesterolLevel = 120.0; // Initial cholesterol level

  @override
  void initState() {
    super.initState();

    systolicController.text = _systolicLevel.toStringAsFixed(0);
    diastolicController.text =
        _diastolicLevel.toStringAsFixed(0); // Set initial value
    cholesterol.text =
        _cholesterolLevel.toStringAsFixed(0); // Set initial value
  }

  void _updateValues() {
    widget.onPressureChanged(
        _systolicLevel, _diastolicLevel, _cholesterolLevel);
  }

  void _updateSystolicLevel(String value) {
    double? enteredValue = double.tryParse(value);
    if (enteredValue != null && enteredValue >= 80 && enteredValue <= 200) {
      setState(() {
        _systolicLevel = enteredValue;
        systolicController.text = _systolicLevel.toStringAsFixed(0);
      });
      _updateValues();
    } else {
      systolicController.text = _systolicLevel.toStringAsFixed(0);
    }
  }

  void _updateDiastolicLevel(String value) {
    double? enteredValue = double.tryParse(value);
    if (enteredValue != null && enteredValue >= 40 && enteredValue <= 120) {
      setState(() {
        _diastolicLevel = enteredValue;
        diastolicController.text = _diastolicLevel.toStringAsFixed(0);
      });
      _updateValues();
    } else {
      diastolicController.text = _diastolicLevel.toStringAsFixed(0);
    }
  }

  void _updateCholesterolLevel(String value) {
    // Parse and update cholesterol level if within range
    double? enteredValue = double.tryParse(value);
    if (enteredValue != null && enteredValue >= 80 && enteredValue <= 150) {
      setState(() {
        _cholesterolLevel = enteredValue;
        cholesterol.text =
            _cholesterolLevel.toStringAsFixed(0); // Update without "mg"
      });
    } else {
      // Revert to previous valid value if out of range
      cholesterol.text = _cholesterolLevel.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Pressure Level ?",
            style: Styles.textStyleExtraLarge(
              context,
              color: AppColor.mainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Container(
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
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${_systolicLevel.toStringAsFixed(0)} / ${_diastolicLevel.toStringAsFixed(0)} mm Hg",
                  style: Styles.textStyleExtraLarge(
                    context,
                    color: AppColor.mainTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Alternating Labels for 0, 20, 40, ...
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  8, // Generates labels: 0, 40, 80, ...
                  (index) => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${index * 40}", // Top labels increment by 40
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColor.mainTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

// Draggable Scale
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Background scale bar
                  Container(
                    height: 30,
                    width:
                        screenWidth, // Full width for the background scale bar
                    decoration: BoxDecoration(
                      color: AppColor.mainTextColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        // Calculate the current width based on _systolicLevel
                        double currentWidth =
                            ((_systolicLevel - 20) / (300 - 20)) *
                                screenWidth *
                                0.8;
                        double newWidth = currentWidth + details.primaryDelta!;

                        // Clamp the new width to ensure it stays within valid bounds
                        newWidth = newWidth.clamp(0.0, screenWidth * 0.8);

                        // Update systolic level based on the new width
                        _systolicLevel = 20 +
                            ((newWidth / (screenWidth * 0.8)) * (300 - 20));
                        _systolicLevel = _systolicLevel.clamp(20, 300);

                        // Update diastolic level proportionally
                        _diastolicLevel =
                            40 + ((_systolicLevel - 20) / 280) * (120 - 40);
                        _diastolicLevel = _diastolicLevel.clamp(40, 120);

                        // Update text fields
                        systolicController.text =
                            _systolicLevel.toStringAsFixed(0);
                        diastolicController.text =
                            _diastolicLevel.toStringAsFixed(0);
                      });
                       _updateValues();
                    },
                    child: Container(
                      width: ((_systolicLevel - 0) / (300 - 20)) *
                          screenWidth *
                          0.8, // Ensure width starts at a minimum
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

// Scale Labels for 20 increments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  8, // Generates labels: 20, 60, 100, ...
                  (index) => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${20 + (index * 40)}", // Bottom labels increment by 40, starting from 20
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColor.mainTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Pressure Level Input with "mm" Label
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Systolic",
                            style: Styles.textStyleSmall(context,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: screenWidth * 0.25,
                          child: TextField(
                            controller: systolicController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.mainTextColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              suffixText: "mm",
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
                            onSubmitted: _updateSystolicLevel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Diastolic",
                            style: Styles.textStyleSmall(context,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: screenWidth * 0.25,
                          child: TextField(
                            controller: diastolicController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.mainTextColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              suffixText: "mm",
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
                            onSubmitted: _updateDiastolicLevel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
      
        const SizedBox(height: 30),
      ],
    );
  }
}
