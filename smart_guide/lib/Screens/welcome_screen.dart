import 'package:flutter/material.dart';
import 'package:smart_guide/Buttons/main_button.dart';
import 'package:smart_guide/Language/language_switcher.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/Screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // 👈 Wraps everything
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: LanguageSwitcher(),
              ),
              const SizedBox(height: 20),
              HeadingText(local.welcome, 50),
              const SizedBox(height: 5),
              BodyText(text: local.startANew, fontSize: 14),
              BodyText(text: local.socialAdvantage, fontSize: 14),
              const SizedBox(height: 50),
              Image.asset(
                'assets/app.png',
                height: 400,
                width: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              MainButton(
                child: Text(local.getStarted, style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
