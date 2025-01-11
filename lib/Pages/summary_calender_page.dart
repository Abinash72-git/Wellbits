import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbits/util/color_constant.dart';

class SummaryCalender extends StatefulWidget {
  const SummaryCalender({super.key});

  @override
  _SummaryCalenderState createState() => _SummaryCalenderState();
}

class _SummaryCalenderState extends State<SummaryCalender> {
  DateTime _currentDate = DateTime.now();

  // Get the start of the week (Sunday)
  DateTime get _startOfWeek {
    return _currentDate.subtract(Duration(days: _currentDate.weekday % 7));
  }

  // Move to the previous week
  void _previousWeek() {
    setState(() {
      _currentDate = _currentDate.subtract(Duration(days: 7));
    });
  }

  // Move to the next week
  void _nextWeek() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekDays =
        List.generate(7, (index) => _startOfWeek.add(Duration(days: index)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          // Top Month Display and Navigation Arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _previousWeek,
                color: AppColor.yellowColor,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentDate),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.yellowColor),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: _nextWeek,
                color: AppColor.yellowColor,
              ),
            ],
          ),
          SizedBox(height: 10),
          // Week Days Calendar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((date) {
              bool isToday = DateFormat('yyyy-MM-dd').format(today) ==
                  DateFormat('yyyy-MM-dd').format(date);

              return Column(
                children: [
                  Text(
                    DateFormat.E().format(date), // Day abbreviation (e.g., Sun)
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isToday
                          ? AppColor.fillColor // Highlight current date in red
                          : AppColor.whiteColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday ? AppColor.fillColor : AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                  color: AppColor.fillColor.withOpacity(0.5),
                                  blurRadius: 8)
                            ]
                          : [],
                    ),
                    child: Text(
                      date.day.toString(), // Day of the month
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? AppColor.whiteColor // Highlight current date
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
