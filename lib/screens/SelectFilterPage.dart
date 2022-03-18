// ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:meetupapp/widgets/constants.dart';
// import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';

// class ChoiceChipDisplay extends StatefulWidget {
//   final String selectedTag;

//   ChoiceChipDisplay(this.selectedTag);

//   @override
//   _ChoiceChipDisplayState createState() => _ChoiceChipDisplayState();
// }

// class _ChoiceChipDisplayState extends State<ChoiceChipDisplay> {
//   List<String> chipList = [
//     "Recycled",
//     "Vegetarian",
//     "Skilled",
//     "Energetic",
//     "Friendly",
//     "Luxurious"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             UpperWidgetOfBottomSheet(
//               backTapHandler: () {
//                 Navigator.of(context).pop();
//               },
//               tapHandler: () {},
//               icon: Icons.stop,
//               toShow: false,
//             ),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(
//                   top: 30,
//                   left: kLeftPadding,
//                   right: kLeftPadding,
//                   bottom: 50,
//                 ),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Select a Tag"),
//                     Wrap(
//                       spacing: 10.0,
//                       runSpacing: 5.0,
//                       children: <Widget>[
//                         choiceChipWidget(
//                           chipList,
//                           widget.selectedTag,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class choiceChipWidget extends StatefulWidget {
//   String _selectedTag;
//   final List<String> reportList;

//   choiceChipWidget(
//     this.reportList,
//     this._selectedTag,
//   );

//   @override
//   _choiceChipWidgetState createState() => _choiceChipWidgetState();
// }

// class _choiceChipWidgetState extends State<choiceChipWidget> {
//   _buildChoiceList() {
//     List<Widget> choices = [];
//     for (var item in widget.reportList) {
//       choices.add(Container(
//         padding: const EdgeInsets.all(2.0),
//         child: ChoiceChip(
//           label: Text(item),
//           labelStyle: const TextStyle(
//               color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//           backgroundColor: const Color(0xffededed),
//           selectedColor: const Color(0xffffc107),
//           selected: widget._selectedTag == item,
//           onSelected: (selected) {
//             setState(() {
//               widget._selectedTag = item;
//             });
//           },
//         ),
//       ));
//     }
//     return choices;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: _buildChoiceList(),
//     );
//   }
// }
