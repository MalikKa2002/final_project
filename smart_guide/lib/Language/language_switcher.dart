import 'package:flutter/material.dart';
import 'package:smart_guide/main.dart';

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: Localizations.localeOf(context),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          ARGuideApp.setLocale(context, newLocale);
        }
      },
      items: const [
        DropdownMenuItem(value: Locale('en'), child: Text('English')),
        DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
        DropdownMenuItem(value: Locale('he'), child: Text('עברית')),
      ],
    );
  }
}
