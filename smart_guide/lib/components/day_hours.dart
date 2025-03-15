import 'package:flutter/material.dart';

class DayHoursSelector extends StatefulWidget {
  @override
  _DayHoursSelectorState createState() => _DayHoursSelectorState();
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
    Day(
      name: 'Sun',
      isOpen: false,
      openTime: TimeOfDay(hour: 0, minute: 0),
      closeTime: TimeOfDay(hour: 0, minute: 0),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Standard Hours'),
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          Day day = days[index];
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(day.name),
                ),
                Row(
                  children: [
                    Switch(
                      value: day.isOpen,
                      onChanged: (bool value) {
                        setState(() {
                          day.isOpen = value;
                        });
                      },
                    ),
                    Text(day.isOpen ? "Open" : "Closed"),
                  ],
                ),
                Row(
                  children: [
                    if (day.isOpen) ...[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: GestureDetector(
                          onTap: () => selectTime(context, day, true),
                          child: Text(
                            day.openTime.format(context),
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      Text(' - '),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: GestureDetector(
                          onTap: () => selectTime(context, day, false),
                          child: Text(
                            day.closeTime.format(context),
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
