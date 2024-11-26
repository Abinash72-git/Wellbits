import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/styles.dart';

class SugarLevelRegister extends StatefulWidget {
  final void Function(double, double) onSugarLevelChanged;
  const SugarLevelRegister({super.key, required this.onSugarLevelChanged});

  @override
  State<SugarLevelRegister> createState() => _SugarLevelRegisterState();
}

class _SugarLevelRegisterState extends State<SugarLevelRegister> {
  @override
  final TextEditingController _prePrandialController = TextEditingController();
  final TextEditingController _postPrandialController = TextEditingController();
  double _sugarLevel = 144.0; // Initial sugar level

  void _updateSugarLevel() {
    double? prePrandial = double.tryParse(_prePrandialController.text);
    double? postPrandial = double.tryParse(_postPrandialController.text);
    if (prePrandial != null || postPrandial != null) {
      setState(() {
        // Update sugar level based on entered values
        _sugarLevel = ((prePrandial ?? 0) + (postPrandial ?? 0)) /
            2; // Example average calculation
      });
      widget.onSugarLevelChanged(prePrandial ?? 0, postPrandial ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Current Sugar Level ?",
            style: Styles.textStyleExtraLarge(
              context,
              color: AppColor.mainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),

        // Circular Sugar Level Indicator
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.4,
              height: screenWidth * 0.4,
              child: CircularProgressIndicator(
                value: _sugarLevel / 300, // Normalize based on max value
                strokeWidth: 20,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.fillColor),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${_sugarLevel.toStringAsFixed(0)}",
                    style: Styles.textStyleExtraLarge(
                      context,
                      color: AppColor.mainTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "mg/dl",
                    style: Styles.textStyleSmall(
                      context,
                      color: AppColor.mainTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Label
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Add your sugar level",
            style: Styles.textStyleLarge(
              context,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Preprandial and Postprandial Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildInputField(
                _prePrandialController,
                "Pre-prandial",
                "assets/icons/apple.png",
                screenWidth,
                screenHeight,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInputField(
                _postPrandialController,
                "Post-prandial",
                "assets/icons/apple2.png",
                screenWidth,
                screenHeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String imagePath,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      children: [
        Container(
          width: screenWidth * 0.2, // Allow it to expand within the row
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
            ),
            style: Styles.textStyleLarge(
              context,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            onChanged: (value) {
              _updateSugarLevel(); // Automatically update sugar level on change
            },
          ),
        ),
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "mg/dl", // Unit label
            style: Styles.textStyleSmall(
              context,
              color: AppColor.mainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),

        // Label Container with Icon and Text
        Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: screenHeight * 0.03,
                width: screenHeight * 0.03,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: Styles.textStyleSmall(context, color: Colors.grey),
                    overflow:
                        TextOverflow.ellipsis, // Handle long text by truncating
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
