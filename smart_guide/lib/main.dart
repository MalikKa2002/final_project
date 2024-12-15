import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const ARCampusGuideApp());
}

class ARCampusGuideApp extends StatelessWidget {
  const ARCampusGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CampusGuideHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CampusGuideHome extends StatelessWidget {
  final List<Map<String, String>> locations = [
    {
      "title": "Azrieli College",
      "status": "Sparsely Crowded",
      "distance": "2.8km away",
      "time": "32 mins"
    },
    {
      "title": "Hebrew University",
      "status": "Crowded",
      "distance": "3.2km away",
      "time": "35 mins"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        "Jerusalem, IL",
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_none, size: 28),
                      const SizedBox(width: 10),
                      CircleAvatar(backgroundColor: Colors.grey, radius: 20),
                    ],
                  )
                ],
              ),
            ),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  Text("Welcome To", style: GoogleFonts.roboto(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("AR Campus Guide",
                  style: GoogleFonts.roboto(
                      fontSize: 28, fontWeight: FontWeight.bold)),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.mic),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Universities & Colleges",
                    style: GoogleFonts.roboto(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: Text("See all")),
                ],
              ),
            ),

            // Horizontal Scrollable Cards
            // SizedBox(
            //   height: 200,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: locations.length,
            //     itemBuilder: (context, index) {
            //       final location = locations[index];
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Stack(
            //           children: [
            //             Container(
            //               width: 160,
            //               decoration: BoxDecoration(
            //                 color: Colors.blueGrey[100],
            //                 borderRadius: BorderRadius.circular(12),
            //               ),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Text(
            //                       location["title"]!,
            //                       style: GoogleFonts.roboto(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.white),
            //                     ),
            //                   ),
            //                   Text(
            //                     "${location["distance"]} • ${location["time"]}",
            //                     style:
            //                         GoogleFonts.roboto(color: Colors.white70),
            //                   ),
            //                   const SizedBox(height: 10),
            //                 ],
            //               ),
            //             ),
            //             Positioned(
            //               top: 8,
            //               left: 8,
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 8, vertical: 4),
            //                 decoration: BoxDecoration(
            //                   color: Colors.black54,
            //                   borderRadius: BorderRadius.circular(12),
            //                 ),
            //                 child: Text(
            //                   location["status"]!,
            //                   style: GoogleFonts.roboto(
            //                       fontSize: 12, color: Colors.white),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
