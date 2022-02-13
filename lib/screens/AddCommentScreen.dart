// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '/providers/PostProvider.dart';
// import '/helper/utils/validator.dart';
// import '/models/post.dart';
// import '/providers/UserProvider.dart';
// import 'package:provider/provider.dart';
// import '/helper/backend/apis.dart';

// class AddCommentPage extends StatefulWidget {
//   Post? post;
//   static const routeName = "/addComment";

//   AddCommentPage({this.post});

//   @override
//   State<AddCommentPage> createState() => _AddCommentPageState();
// }

// class _AddCommentPageState extends State<AddCommentPage> {
//   final _post = PostAPIS();
//   final _addPostFormKey = GlobalKey<FormState>();

//   final TextEditingController _titleController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = Provider.of<UserProvider>(context);
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Your comment",
//               style: TextStyle(
//                   color: Colors.grey[800], fontWeight: FontWeight.bold)),
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           shadowColor: Colors.white,
//           leading: IconButton(
//             icon: const Icon(Icons.close, color: Colors.black),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           actions: [
//             _isLoading
//                 ? const Icon(Icons.more_horiz, color: Colors.black)
//                 : IconButton(
//                     icon: const Icon(Icons.check, color: Colors.black),
//                     onPressed: () async {
//                       bool isValidCommentEntered =
//                           _addPostFormKey.currentState!.validate();
//                       if (isValidCommentEntered) {
//                         _addComment();
//                       }
//                     },
//                   )
//           ],
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(15.0),
//           child: Form(
//             key: _addPostFormKey,
//             child: Column(
//               children: [
//                 // Row(
//                 //   children: [
//                 //     Icon(Icons.android),
//                 //     Text(userProvider.getUser()!.username!),
//                 //   ],
//                 // ),
//                 TextFormField(
//                   controller: _titleController,
//                   validator: (value) =>
//                       Validator.validateTextField(result: value),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
