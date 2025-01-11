import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wellbits/Pages/app_pages.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/color_constant.dart';
import 'package:wellbits/util/constant_image.dart';
import 'package:wellbits/util/extension.dart';
import 'package:wellbits/util/styles.dart';

class ChewTimeFood extends StatefulWidget {
  final String selectedMeal;
  final String selectedCuisine;
  final String selectedType;

  const ChewTimeFood({
    required this.selectedMeal,
    required this.selectedCuisine,
    required this.selectedType,
    Key? key,
  }) : super(key: key);

  @override
  State<ChewTimeFood> createState() => _ChewTimeFoodState();
}

class _ChewTimeFoodState extends State<ChewTimeFood> {
  @override
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<String> images = [
    "assets/icons/slider.png",
    "assets/icons/slider.png",
    "assets/icons/slider.png",
  ];
  int myCurrentIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;
  bool isPlaying = false;
  bool isSoundOn = true;
  int totalTimeInSeconds = 30 * 60; // 30 minutes in seconds
  int cycleTimeInSeconds = 35; // Each cycle (30s chew + 5s swallow)
  int elapsedCycleSeconds = 0;
  int elapsedOverallSeconds = 0;
  Timer? cycleTimer;
  Timer? overallTimer;
  final List<Map<String, String>> audioFiles = [
    {"name": "Music1", "path": "audio/audio6.mp3"},
    {"name": "Music2", "path": "audio/audio13.mp3"},
    {"name": "Music3", "path": "audio/audio7.mp3"},
    {"name": "Music4", "path": "audio/audio8.mp3"},
    {"name": "Music5", "path": "audio/audio9.mp3"},
    {"name": "Music6", "path": "audio/audio10.mp3"},
    {"name": "Music7", "path": "audio/audio11.mp3"},
    {"name": "Music8", "path": "audio/audio14.mp3"},
  ];

  Map<String, String> selectedAudio = {
    "name": "Music1",
    "path": "audio/audio6.mp3"
  };
  Map<String, String> cuisineImages = {
    "South Indian Veg": "assets/food/south-indian-veg.png",
    "South Indian Non-Veg": "assets/food/south-indian-Nonveg.png",
    "North Indian Veg": "assets/food/north-indian-veg.png",
    "North Indian Non-Veg": "assets/food/north-indian-nveg.png",
    "Continental Veg": "assets/food/continental-veg.png",
    "Continental Non-Veg": "assets/food/continental-Non-veg.png",
  };
  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio file
    // _audioPlayer.setSource(AssetSource(
    //     "audio/mixkit-eating-crunchy-food-with-mouth-open-120.wav")); // Set your audio file
  }

  void startTimer() {
    if (isPlaying) return;

    // Start the audio
    startAudio();

    setState(() {
      isPlaying = true;
    });

    // Reinitialize the overall timer
    overallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (elapsedOverallSeconds < totalTimeInSeconds) {
          elapsedOverallSeconds++;
        } else {
          // Stop timers and reset states when the total time is reached
          overallTimer?.cancel();
          cycleTimer?.cancel();
          overallTimer = null;
          cycleTimer = null;
          isPlaying = false;
        }
      });
    });

    // Reinitialize the cycle timer
    cycleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (elapsedCycleSeconds < cycleTimeInSeconds - 1) {
          elapsedCycleSeconds++;
        } else {
          elapsedCycleSeconds = 0; // Reset the cycle progress
        }
      });
    });
  }

  void pauseTimer() {
    if (isPlaying) {
      // Pause the audio
      pauseAudio();

      // Cancel the timers but keep the elapsed states intact
      overallTimer?.cancel();
      cycleTimer?.cancel();
      overallTimer = null;
      cycleTimer = null;

      setState(() {
        isPlaying = false; // Mark as not playing
      });
    }
  }

  void resetTimer() {
    overallTimer?.cancel();
    cycleTimer?.cancel();
    setState(() {
      elapsedCycleSeconds = 0;
      elapsedOverallSeconds = 0;
      isPlaying = false;
    });
  }

  void startAudio() async {
    if (!isAudioPlaying) {
      // Dynamically set the source here based on the selected audio
      await _audioPlayer.setSource(AssetSource(selectedAudio["path"]!));
      await _audioPlayer.resume(); // Start or resume audio
      isAudioPlaying = true;
    }
  }

  void pauseAudio() async {
    await _audioPlayer.pause();
    isAudioPlaying = false;
  }

  void toggleMute() {
    setState(() {
      isSoundOn = !isSoundOn;
      _audioPlayer
          .setVolume(isSoundOn ? 1.0 : 0.0); // Set volume based on sound state
    });
  }

  @override
  void dispose() {
    overallTimer?.cancel();
    cycleTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    int remainingMinutes =
        ((totalTimeInSeconds - elapsedOverallSeconds) / 60).floor();
    double cycleProgress = elapsedCycleSeconds / cycleTimeInSeconds;
    double overallProgress = elapsedOverallSeconds / totalTimeInSeconds;
    String imageKey = "${widget.selectedCuisine} ${widget.selectedType}";
    String imagePath =
        cuisineImages[imageKey] ?? "assets/food/south-indian-veg.png";
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImageKey.RegisterBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: CarouselSlider.builder(
                //     itemCount: images.length,
                //     options: CarouselOptions(
                //       viewportFraction: 1, // Set the height of the slider
                //       autoPlay: true,
                //       enlargeCenterPage: true,

                //       onPageChanged: (index, reason) {
                //         setState(() {
                //           myCurrentIndex = index;
                //         });
                //       },
                //     ),
                //     itemBuilder: (context, index, realIndex) {
                //       return Container(
                //         margin: EdgeInsets.symmetric(
                //             horizontal: screenWidth * 0.025),
                //         decoration: BoxDecoration(
                //           borderRadius:
                //               BorderRadius.circular(screenHeight * 0.02),
                //           image: DecorationImage(
                //             image: AssetImage(images[index]),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),

                // // Dots Indicator
                // const SizedBox(
                //   height: 10,
                // ),
                // AnimatedSmoothIndicator(
                //   activeIndex: myCurrentIndex,
                //   count: images.length, // Use the length of your images list
                //   effect: const WormEffect(
                //     activeDotColor: AppColor.mainTextColor,
                //     dotColor: Colors.white,
                //     dotHeight: 7,
                //     dotWidth: 7,
                //     paintStyle: PaintingStyle.fill,
                //     spacing: 5,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: screenWidth * 0.18,
                            height: screenHeight * 0.08,
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            decoration: BoxDecoration(
                              color: AppColor.fillColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(screenHeight * 0.025),
                                bottomLeft:
                                    Radius.circular(screenHeight * 0.025),
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/icons/timing.png",
                                fit: BoxFit.cover,
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.1,
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.66,
                            height: screenHeight * 0.05,
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            // padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColor.mainTextColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(screenHeight * 0.025),
                                bottomRight:
                                    Radius.circular(screenHeight * 0.025),
                              ),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.selectedMeal.toUpperCase(),
                                    style: Styles.textStyleLarge(
                                      context,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.004,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Map<String, String>>(
                            value: audioFiles.firstWhere(
                              (audio) => audio["path"] == selectedAudio["path"],
                              orElse: () => audioFiles.first,
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconEnabledColor: Colors.blue.shade900,
                            items: audioFiles.map((audio) {
                              return DropdownMenuItem<Map<String, String>>(
                                value: audio,
                                child: Text(
                                  audio["name"]!,
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 14, // Smaller font size
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: isPlaying
                                ? null // Disable dropdown when the timer is running
                                : (Map<String, String>? newAudio) {
                                    if (newAudio != null &&
                                        newAudio != selectedAudio) {
                                      setState(() {
                                        selectedAudio = newAudio;
                                      });
                                    }
                                  },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // Background color for the container
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isSoundOn ? Icons.volume_up : Icons.volume_off,
                          color: Colors.blue.shade900,
                        ),
                        onPressed: toggleMute,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${remainingMinutes} min",
                            style: Styles.textStyleMedium(
                              context,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: cycleProgress,
                            strokeWidth: 20,
                            color: Colors.orange,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              imagePath, // Replace with your food image
                              height: 180,
                            ),
                          ],
                        ),
                        // Positioned(
                        //   top: 10,
                        //   right: 10,
                        //   bottom: 140,
                        //   left: 200,
                        //   child: IconButton(
                        //     icon: Icon(
                        //       isSoundOn ? Icons.volume_up : Icons.volume_off,
                        //       color: Colors.blue.shade900,
                        //     ),
                        //     onPressed: toggleMute,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  "${elapsedCycleSeconds} sec",
                  style: Styles.textStyleMedium(
                    context,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isPlaying ? pauseTimer : startTimer,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: width * 0.05,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            isPlaying ? "Pause" : "Start",
                            style: Styles.textStyleMedium(
                              context,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.yellowColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.03),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: screenWidth * 0.02), // Spacer between buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouteName.summarypage.push(context);
                        },
                        // onPressed: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AppPages(tabNumber: 0),
                        //     ),
                        //   );
                        // },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.03),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Finished",
                            style: Styles.textStyleMedium(
                              context,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
