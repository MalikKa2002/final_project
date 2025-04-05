import 'package:flutter/material.dart';

class DayHoursSelector extends StatefulWidget {
  @override
  createState() => _DayHoursSelectorState();
}

class Day {
  String name;
  bool isOpen;
  TimeOfDay openTime;
  TimeOfDay closeTime;

  Day({
    required this.name,
    this.isOpen = false,
    required this.openTime,
    required this.closeTime,
  });
}

class _DayHoursSelectorState extends State<DayHoursSelector> {
  List<Day> days = [
    Day(
      name: 'Sun',
      isOpen: false,
      openTime: TimeOfDay(hour: 0, minute: 0),
      closeTime: TimeOfDay(hour: 0, minute: 0),
    ),
    Day(
      name: 'Mon',
      isOpen: true,
      openTime: TimeOfDay(hour: 12, minute: 0),
      closeTime: TimeOfDay(hour: 23, minute: 0),
    ),
    Day(
      name: 'Tue',
      isOpen: true,
      openTime: TimeOfDay(hour: 10, minute: 0),
      closeTime: TimeOfDay(hour: 23, minute: 0),
    ),
    Day(
      name: 'Wed',
      isOpen: true,
      openTime: TimeOfDay(hour: 10, minute: 0),
      closeTime: TimeOfDay(hour: 23, minute: 0),
    ),
    Day(
      name: 'Thu',
      isOpen: true,
      openTime: TimeOfDay(hour: 10, minute: 0),
      closeTime: TimeOfDay(hour: 23, minute: 0),
    ),
    Day(
      name: 'Fri',
      isOpen: true,
      openTime: TimeOfDay(hour: 10, minute: 0),
      closeTime: TimeOfDay(hour: 2, minute: 0),
    ),
    Day(
      name: 'Sat',
      isOpen: true,
      openTime: TimeOfDay(hour: 12, minute: 0),
      closeTime: TimeOfDay(hour: 2, minute: 0),
    ),
  ];

  Future<void> selectTime(
      BuildContext context, Day day, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpeningTime ? day.openTime : day.closeTime,
    );
    if (picked != null) {
      setState(() {
        if (isOpeningTime) {
          day.openTime = picked;
        } else {
          day.closeTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          Day day = days[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(day.name),
                    ),
                    Switch(
                      value: day.isOpen,
                      onChanged: (bool value) {
                        setState(() {
                          day.isOpen = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(day.isOpen ? "Open" : "Closed"),
                    ),
                    if (day.isOpen) ...[
                      GestureDetector(
                        onTap: () => selectTime(context, day, true),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            day.openTime.format(context),
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(' - '),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => selectTime(context, day, false),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            day.closeTime.format(context),
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
