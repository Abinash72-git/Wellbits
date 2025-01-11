import 'package:flutter/material.dart';
import 'package:wellbits/Pages/RegistrationForms/eatingstyle.dart';
import 'package:wellbits/Pages/RegistrationForms/workstyle.dart';
import 'package:wellbits/Pages/intro_page.dart';
import 'package:wellbits/Pages/RegistrationForms/lifestyle_app_pages.dart';
import 'package:wellbits/Pages/RegistrationForms/medical_app_pages.dart';
import 'package:wellbits/Pages/RegistrationForms/profile.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

class RegisterAppPages extends StatefulWidget {
  final int tabNumber;
  const RegisterAppPages({required this.tabNumber});

  @override
  State<RegisterAppPages> createState() => _RegisterAppPagesState();
}

class _RegisterAppPagesState extends State<RegisterAppPages> {
  @override
  late int index;
  late Widget page;
  bool ispageset = false;

  List<bool> selected = [false, false, false, false, false];
  List<String> iconPaths = [
    'assets/icons/profile.png',
    'assets/icons/medical.png',
    'assets/icons/life-style2.png',
    'assets/icons/work-type.png',
    'assets/icons/eatingstyle.png',
  ];
  List<String> labels = [
    'Profile',
    'Medical',
    'Lifestyle',
    'Workstyle',
    'Eatingstyle'
  ];

  @override
  void initState() {
    super.initState();
    index = widget.tabNumber;
    updateSelectedList(index);
    page = getPage(index);
  }

  void updateSelectedList(int selectedIndex) {
    setState(() {
      for (int i = 0; i < selected.length; i++) {
        selected[i] =
            i == selectedIndex; // Update the selected state based on index
      }
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return ProfileRegister();
      case 1:
        return MedicalRegister();
      case 2:
        return LifestyleAppPages();
      case 3:
        return Workstyle();
      case 4:
        return EatingStyle();
      default:
        return ProfileRegister();
    }
  }

  void select(int n) {
    setState(() {
      for (int i = 0; i < selected.length; i++) {
        selected[i] = i == n;
      }
      index = n;
      page = getPage(index);
      updateSelectedList(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: context.height,
        width: context.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            // Vertical Navigation
            Container(
              height: screenHeight * 0.75, // 85% of the screen height
              width: screenWidth * 0.25, // 25% of the screen width
              decoration: BoxDecoration(
                color: AppColor.mainTextColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconPaths
                    .asMap()
                    .entries
                    .map(
                      (entry) => NavBarItem(
                        iconPath: entry.value,
                        label: labels[entry.key],
                        selected: selected[entry.key],
                        onTap: () {
                          select(entry.key);
                        },
                        index: entry.key,
                      ),
                    )
                    .toList(),
              ),
            ),

            // Page Content
            Expanded(
              child: page,
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final String iconPath;
  final String label;
  final Function onTap;
  final bool selected;
  final int index;

  NavBarItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
    required this.selected,
    required this.index,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  late Animation<double> _anim1;
  late Animation<double> _anim2;
  late Animation<double> _anim3;

  bool hovered = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 275),
    );

    _anim1 = Tween(begin: 101.0, end: 75.0).animate(_controller1);
    _anim2 = Tween(begin: 101.0, end: 25.0).animate(_controller2);
    _anim3 = Tween(begin: 101.0, end: 50.0).animate(_controller2);

    _controller1.value = widget.selected ? 1.0 : 0.0;
    _controller2.value = widget.selected ? 1.0 : 0.0;

    _controller1.addListener(() {
      setState(() {});
    });
    _controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.selected) {
      _controller1.reverse();
      _controller2.reverse();
    } else {
      _controller1.forward();
      _controller2.forward();
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to make responsive sizes
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (widget.selected)
              CustomPaint(
                size: Size(
                  screenWidth * 0.3,
                  screenHeight * 0.12,
                ),
                painter: CurvePainter(
                  selected: widget.selected,
                ),
              ),
            Container(
              width: screenWidth * 0.3,
              height: screenHeight * 0.13,
              decoration: BoxDecoration(
                color: widget.selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.iconPath,
                    width: screenWidth * 0.15, // Adjust icon size to fit better
                    height: screenHeight * 0.08,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.label,
                        style: Styles.textStyleMedium(
                          context,
                          color: widget.selected
                              ? AppColor.mainTextColor
                              : Colors.white,
                        ).copyWith(
                          fontSize: screenHeight * 0.015,
                        ), // Adjust font size based on height
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final bool selected;

  CurvePainter({
    required this.selected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    if (selected) {
      path.moveTo(0, size.height * 0.35);
      path.quadraticBezierTo(
          size.width * 0.5, size.height * 0.4, size.width, size.height * 0.25);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
// Placeholder Pages

