// lib/components/details.dart

import 'package:flutter/material.dart';
import 'package:smart_guide/Texts/heading_title.dart';
import 'package:smart_guide/icons/bordered_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPart extends StatelessWidget {
  final String collegeName;
  final String location;
  final String phoneNumber;
  final String website;
  final bool isOpen;
  final String description;
  final Map<String, dynamic> openingHours;

  const DetailsPart({
    required this.collegeName,
    required this.location,
    required this.phoneNumber,
    required this.website,
    required this.isOpen,
    required this.description,
    required this.openingHours,
    super.key,
  });

  Future<void> _launchPhone(String number) async {
    final telUri = Uri(scheme: 'tel', path: number);
    try {
      await launchUrl(telUri);
    } catch (e) {
      debugPrint('Could not launch dialer for $number: $e');
    }
  }

  Future<void> _launchWebsite(String rawUrl) async {
    String urlString = rawUrl.trim();
    if (!urlString.startsWith('http://') &&
        !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }
    final uri = Uri.parse(urlString);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('Could not launch browser for $uri: $e');
    }
  }

  String _formatStatus() => isOpen ? 'OPEN' : 'CLOSED';

  String _formatHourRange(String dayKey) {
    final dayMap = openingHours[dayKey];
    if (dayMap == null || dayMap is! Map) return 'Closed';
    final openStr = (dayMap['open'] as String?)?.trim();
    final closeStr = (dayMap['close'] as String?)?.trim();
    if (openStr == null || openStr.isEmpty || closeStr == null || closeStr.isEmpty) {
      return 'Closed';
    }
    return '$openStr – $closeStr';
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    const weekdayOrder = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];
    String _capitalize(String s) =>
        s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              HeadingTitle(collegeName, 24),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(child: Text(location)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  BorderedIconButton(
                    icon: Icons.phone,
                    onPressed: () {
                      if (phoneNumber.isNotEmpty) {
                        _launchPhone(phoneNumber);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  BorderedIconButton(
                    icon: Icons.language,
                    onPressed: () {
                      if (website.isNotEmpty) {
                        _launchWebsite(website);
                      }
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      _formatStatus(),
                      style: TextStyle(
                        fontSize: 20,
                        color: isOpen ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(text: local.details),
                  Tab(text: local.daysAndHours),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(description)],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Status: ${_formatStatus()}"),
                          const SizedBox(height: 8),
                          Text("Working Hours:"),
                          const SizedBox(height: 8),
                          for (var day in weekdayOrder)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(_capitalize(day)),
                                  ),
                                  Text(_formatHourRange(day)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
