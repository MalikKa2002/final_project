import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayHoursSelector extends StatefulWidget {
  // Callback to pass back the updated hours.
  final void Function(Map<String, Map<String, String>>)? onHoursChanged;

  const DayHoursSelector({super.key, this.onHoursChanged});

  @override
  createState() => _DayHoursSelectorState();
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
      _notifyHoursChanged();
    }
  }

  // Notify parent widget of changes by calling the callback with a formatted map.
  void _notifyHoursChanged() {
    if (widget.onHoursChanged != null) {
      // Build a formatted map for each day. If a day is not open, both times are empty strings.
      Map<String, Map<String, String>> formattedHours = {};
      for (var day in days) {
        formattedHours[day] = {
          "open": (isOpen[day]! && openingTime[day] != null)
              ? openingTime[day]!.format(context)
              : "",
          "close": (isOpen[day]! && closingTime[day] != null)
              ? closingTime[day]!.format(context)
              : "",
        };
      }
      widget.onHoursChanged!(formattedHours);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
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
              // Day header and switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Switch(
                    value: isOpen[day]!,
                    onChanged: (value) {
                      setState(() {
                        isOpen[day] = value;
                        if (!value) {
                          // Clear times if the day is closed
                          openingTime[day] = null;
                          closingTime[day] = null;
                        }
                      });
                      _notifyHoursChanged();
                    },
                  ),
                ],
              ),
              if (isOpen[day]!)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeButton(day, true),
                    Text(local.to,
                        style: TextStyle(fontWeight: FontWeight.w500)),
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
    final local = AppLocalizations.of(context)!;
    final label = isStart ? local.open : local.close;
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
