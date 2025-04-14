import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_guide/Screens/settings_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar and Profile
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=5'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anne Adams',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Diector of Azrieli College\n Jerusalem ',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stats
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: const [
              //       _StatItem(label: 'Fans', value: '24K'),
              //       _StatItem(label: 'Following', value: '582'),
              //       _StatItem(label: 'Posts', value: '2129'),
              //       _StatItem(label: 'Stories', value: '91'),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 16),

              // // Buttons
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       _GradientButton(
              //           text: 'Follow',
              //           colors: [Colors.blue, Colors.blueAccent]),
              //       _GradientButton(
              //           text: 'Message',
              //           colors: [Colors.purple, Colors.deepPurple]),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 20),

              // Tabs
              TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Building'),
                  // Tab(text: 'Video'),
                  // Tab(text: 'About'),
                  // Tab(text: 'Favorite'),
                ],
              ),

              // Content
              Expanded(
                child: TabBarView(
                  children: [
                    _PhotoGrid(),
                    // Center(child: Text("Videos")),
                    // Center(child: Text("About")),
                    // Center(child: Text("Favorites")),
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final List<Color> colors;

  const _GradientButton({required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: colors),
        ),
        child: Center(
          child: Text(text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final List<String> images = const [
    'https://i.pravatar.cc/150?img=11',
    'https://i.pravatar.cc/150?img=12',
    'https://i.pravatar.cc/150?img=13',
    'https://i.pravatar.cc/150?img=14',
    'https://i.pravatar.cc/150?img=15',
    'https://i.pravatar.cc/150?img=16',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: images
          .map((url) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[300],
                  child: Image.network(url, fit: BoxFit.cover),
                ),
              ))
          .toList(),
    );
  }
}
