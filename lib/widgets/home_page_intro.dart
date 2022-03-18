// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:meetupapp/screens/SearchPage.dart';
// import 'package:meetupapp/widgets/button_widget.dart';

// class HomeIntro extends StatelessWidget {
//   const HomeIntro({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 25.0),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Text(
//               //   "Hello Pratik 👋",
//               //   style: TextStyle(
//               //     fontSize: 15,
//               //     fontWeight: FontWeight.w500,
//               //     color: Colors.grey[500],
//               //   ),
//               // ),
//               // const SizedBox(
//               //   height: 6,
//               // ),
//               // Text(
//               //   "Explore the Top Feeds!",
//               //   style: TextStyle(
//               //     color: Colors.grey[800],
//               //     fontSize: 16,
//               //     wordSpacing: 2,
//               //     fontFamily: "Raleway",
//               //     fontWeight: FontWeight.w700,
//               //   ),
//               // ),
//             ],
//           ),
//           const Spacer(),
//           ButtonWidget(
//             icon: CupertinoIcons.search,
//             tapHandler: () {
//               Navigator.of(context).pushNamed(SearchPage.routeName);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
