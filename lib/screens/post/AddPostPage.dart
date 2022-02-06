import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/helper/utils/loader.dart';
import '/helper/utils/validator.dart';
import '/helper/backend/apis.dart';
import '/screens/post/AddInterestTagPage.dart';
import '/widgets/constants.dart';
import '/widgets/upper_widget_bottom_sheet.dart';

class AddPost extends StatefulWidget {
  static const routeName = "/addpost";

  const AddPost();

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _addPostFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isProcessing = false;
  String _selectedTag = "";

  Future<Map> _addPostAPI(Map postData) async {
    setState(() {
      _isProcessing = true;
    });

    print("CALLING ADD POST//");
    final m1 = await PostAPIS().addPost({
      "title": _titleController.text,
      "desc": _descController.text,
      "author": FirebaseAuth.instance.currentUser!.uid,
    });
    print("ADD POST RESULT:");
    print(m1);
    print("----------------");

    setState(() {
      _isProcessing = false;
    });

    if (m1["errCode"] != null) {
      Fluttertoast.showToast(msg: "Couldn't add the Post!Try again later.");
    }
    else{
      Fluttertoast.showToast(msg: "Added Post Successfully!");
      Navigator.pop(context);
    }
    return m1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: _isProcessing
          ? GlobalLoader(color: Colors.white)
          : GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.7,
            maxChildSize: 1,
            builder: (_, controller) {
              return Column(
                children: [
                  UpperWidgetOfBottomSheet(
                    tapHandler: () async {
                      if (_addPostFormKey.currentState!.validate()) {
                        Map data = {
                          "title": _titleController.text.toString(),
                          "description": "test_desc",
                          "author": FirebaseAuth.instance.currentUser!.uid
                        };
                        _addPostAPI(data);
                      }
                    },
                    icon: CupertinoIcons.checkmark_alt,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: kTopPadding,
                        left: kLeftPadding,
                        right: kLeftPadding,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Form(
                        key: _addPostFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (ctx) {
                                    return AddInterestTagPage(
                                      selectedTag: _selectedTag,
                                      tapHandler: (val) {
                                        setState(() {
                                          _selectedTag = val;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  "Tag",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Raleway",
                                    letterSpacing: 0.8,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              maxLines: null,
                              controller: _titleController,
                              style: const TextStyle(height: 1.3),
                              validator: (value) => Validator.validateTextField(
                                  result: value,
                                  message: "Enter a valid Title"),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add an Title",
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            TextFormField(
                              maxLines: null,
                              controller: _descController,
                              style: const TextStyle(height: 1.5),
                              decoration: InputDecoration(
                                hintText: "Give a description (Optional)",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

// SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text("Add post"),
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//             ),
//           ),
//           body: Column(children: [
//             const SizedBox(height: 10),
//             Form(
//               key: _registerFormKey,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _titleController,
//                       focusNode: _focusTitle,
//                       validator: (value) => Validator.validateTextField(
//                           result: value, message: "Check Post title!"),
//                       decoration: InputDecoration(
//                         hintText: "Post Title",
//                         errorBorder: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.0),
//                           borderSide: const BorderSide(
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     TextFormField(
//                       controller: _descController,
//                       focusNode: _focusDesc,
//                       maxLines: 5,
//                       validator: (value) => Validator.validateTextField(
//                           result: value, message: "Invalid Description!"),
//                       decoration: InputDecoration(
//                         hintText: "Description",
//                         errorBorder: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.0),
//                           borderSide: const BorderSide(
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 50.0),
//                     _isProcessing
//                         ? const CircularProgressIndicator()
//                         : InkWell(
//                             onTap: () async {
//                               bool isValidInput =
//                                   _registerFormKey.currentState!.validate();

//                               if (isValidInput) {
//                                 Map postData = {
//                                   "title": _titleController.text,
//                                   "description": _descController.text.trim(),
//                                   "author":
//                                       FirebaseAuth.instance.currentUser!.uid,
//                                 };

//                                 print("going for posting");
//                                 await _addPostAPI(postData);
//                               }
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(10)),
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 15, horizontal: 30),
//                               child: const Text(
//                                 "Add",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           )
//                   ],
//                 ),
//               ),
//             )
//           ])),
//     );
