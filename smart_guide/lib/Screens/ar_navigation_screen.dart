// import 'package:flutter/material.dart';

// class ArNavigationScreen extends StatefulWidget {
//   const ArNavigationScreen({super.key});

//   @override
//   createState() => _ArNavigationScreenState();
// }

// class _ArNavigationScreenState extends State<ArNavigationScreen> {
//   void _onARViewCreated() {
//     print("qqqqqqqqqqqq");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Camera background or AR
//         // /ARView(onARViewCreated: __onARViewCreated),

//         // Top navigation step
//         Positioned(
//           top: 50,
//           left: 20,
//           right: 20,
//           child: Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.teal,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Rue de Toul st.",
//                     style: TextStyle(color: Colors.white, fontSize: 16)),
//                 Icon(Icons.arrow_upward, color: Colors.white),
//               ],
//             ),
//           ),
//         ),

//         // Bottom estimated time info
//         Positioned(
//           bottom: 30,
//           left: 20,
//           right: 20,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("12 min",
//                       style: TextStyle(color: Colors.white, fontSize: 24)),
//                   Text("650m • 8:37am",
//                       style: TextStyle(color: Colors.white70)),
//                 ],
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: Icon(Icons.close),
//                 label: Text("Exit"),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               )
//             ],
//           ),
//         ),

//         // Navigation Path (fake 3D with transparent PNG or animated widget)
//         Positioned.fill(
//           child: Center(
//             child: Image.asset(
//                 "assets/path_overlay.png"), // Make this a semi-transparent arrow/path image
//           ),
//         )
//       ],
//     );
//   }
// }
