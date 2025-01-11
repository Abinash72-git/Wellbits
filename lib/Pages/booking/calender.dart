import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbits/util/color_constant.dart';

class CustomWeekCalendar extends StatefulWidget {
  final Function(DateTime)
      onDateSelected; // Callback to pass selected date back to parent

  const CustomWeekCalendar({super.key, required this.onDateSelected});

  @override
  _CustomWeekCalendarState createState() => _CustomWeekCalendarState();
}

class _CustomWeekCalendarState extends State<CustomWeekCalendar> {
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;

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

  // Select a specific day
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date); // Notify parent widget with the selected date
  }

  @override
  Widget build(BuildContext context) {
    final weekDays =
        List.generate(7, (index) => _startOfWeek.add(Duration(days: index)));

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          // Top Month Display and Navigation Arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _previousWeek,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentDate),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.mainTextColor),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: _nextWeek,
              ),
            ],
          ),
          SizedBox(height: 10),
          // Week Days Calendar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((date) {
              bool isSelected = _selectedDate != null &&
                  DateFormat('yyyy-MM-dd').format(_selectedDate!) ==
                      DateFormat('yyyy-MM-dd').format(date);

              return GestureDetector(
                onTap: () => _selectDate(date),
                child: Column(
                  children: [
                    Text(
                      DateFormat.E()
                          .format(date), // Day abbreviation (e.g., Sun)
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.green : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    blurRadius: 8)
                              ]
                            : [],
                      ),
                      child: Text(
                        date.day.toString(), // Day of the month
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
