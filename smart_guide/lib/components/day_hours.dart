import 'package:flutter/material.dart';

class DayHoursSelector extends StatefulWidget {
  @override
  _DayHoursSelectorState createState() => _DayHoursSelectorState();
}

class _DayHoursSelectorState extends State<DayHoursSelector> {
  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  Map<String, bool> isOpen = {};
  Map<String, TimeOfDay?> openingTime = {};
  Map<String, TimeOfDay?> closingTime = {};

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      isOpen[day] = false;
      openingTime[day] = null;
      closingTime[day] = null;
    }
  }

  Future<void> _pickTime(String day, bool isStart) async {
    final initialTime = TimeOfDay.now();
    final picked =
        await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      setState(() {
        if (isStart) {
          openingTime[day] = picked;
        } else {
          closingTime[day] = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: days.map((day) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(day,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Switch(
                    value: isOpen[day]!,
                    onChanged: (value) {
                      setState(() {
                        isOpen[day] = value;
                        if (!value) {
                          openingTime[day] = null;
                          closingTime[day] = null;
                        }
                      });
                    },
                  ),
                ],
              ),
              if (isOpen[day]!)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeButton(day, true),
                    Text("to", style: TextStyle(fontWeight: FontWeight.w500)),
                    _buildTimeButton(day, false),
                  ],
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeButton(String day, bool isStart) {
    final label = isStart ? "Open" : "Close";
    final time = isStart ? openingTime[day] : closingTime[day];
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey[300]!),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _pickTime(day, isStart),
      child: Text(
        time != null ? time.format(context) : "$label Time",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
