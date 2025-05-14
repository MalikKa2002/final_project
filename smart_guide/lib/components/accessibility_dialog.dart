import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;

  const AccessibilitySettingsScreen({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<AccessibilitySettingsScreen> createState() =>
      _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState
    extends State<AccessibilitySettingsScreen> {
  late bool isWheelchairAccessible;

  @override
  void initState() {
    super.initState();
    isWheelchairAccessible = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(local.accessibilityOptions),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SwitchListTile(
                  title: const Text("Wheelchair Accessible Routes"),
                  subtitle: const Text(
                      "Only show routes suitable for wheelchair users"),
                  value: isWheelchairAccessible,
                  onChanged: (value) {
                    setState(() {
                      isWheelchairAccessible = value;
                    });
                    widget.onChanged(value); // Notify parent
                  },
                ),
              ),
            ),
            // Add more Card widgets for other options if needed
          ],
        ),
      ),
    );
  }
}
