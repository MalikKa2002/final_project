import 'package:flutter/material.dart';
import 'package:smart_guide/components/custom_app_bar.dart';
import 'package:smart_guide/Screens/home_body.dart';
import 'package:smart_guide/components/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.30; // 25% of screen height

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight), // Dynamic height
        child: CustomAppBar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: HomeBody(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Widgets with padding
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Top Section: Location and Profile
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.location_on,
//                                   color:
//                                       const Color.fromARGB(255, 250, 100, 100)),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Jerusalem, IL",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.notifications,
//                                     color: Colors.black),
//                                 onPressed: () {},
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const SettingsScreen()),
//                                   );
//                                 },
//                                 child: CircleAvatar(
//                                   radius: 20,
//                                   backgroundImage:
//                                       AssetImage('assets/profile.png'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),

//                       // Welcome Text
//                       Text(
//                         "Welcome To",
//                         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                       ),
//                       Text(
//                         "AR Campus Guide",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 20),

//                       // Search Bar
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.search, color: Colors.grey),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   hintText: "Search",
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             Icon(Icons.mic, color: Colors.grey),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20),

//                       // Universities & Colleges Section
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Universities & Colleges",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           // GestureDetector(
//                           //   onTap: () {
//                           //     // Handle "See All" tap
//                           //   },
//                           //   child: Text(
//                           //     "See all",
//                           //     style: TextStyle(
//                           //       fontSize: 14,
//                           //       color: Colors.green,
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),

//                 // Horizontal Cards Section
//                 SizedBox(
//                   height: 200,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       GestureDetector(
//                         onTap: () => updateInfo(
//                           "Azrieli College: A leading institution in technology and innovation.",
//                         ),
//                         child: UniversityCard(
//                           imagePath: 'assets/azrieli_college.png',
//                           title: 'Azrieli College',
//                           distance: '2.8km away',
//                           time: '32 mins',
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => updateInfo(
//                           "Hebrew University: Known for excellence in education and research.",
//                         ),
//                         child: UniversityCard(
//                           imagePath: 'assets/hebrew_university.png',
//                           title: 'Hebrew University',
//                           distance: '2.8km away',
//                           time: '32 mins',
//                         ),
//                       ),
//                       AddCampusCard(), // Add Campus button styled as a card
//                       SizedBox(width: 16), // Add space at the end
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 // Information Display Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "About",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         displayedInfo,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
