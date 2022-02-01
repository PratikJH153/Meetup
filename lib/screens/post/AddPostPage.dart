import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/ERROR_CODE_CUSTOM.dart';
import 'package:meetupapp/models/tag_item.dart';
import '/helper/APIS.dart';
import '/utils/validator.dart';

class AddPost extends StatefulWidget {
  static const routeName = "/addpost";
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final _focusTitle = FocusNode();
  final _focusDesc = FocusNode();

  bool _isProcessing = false;

  Future<Map> _addPostAPI(Map postData) async {
    setState(() {
      _isProcessing = true;
    });

    final m1 = await PostAPIS().addPost(postData);
    setState(() {
      _isProcessing = false;
    });

    if (m1["errCode"] != null) {
      Fluttertoast.showToast(msg: "Couldn't add the Post!Try again later.");
    }
    ;

    return m1;
  }

  List<TagItem> _dropdownItems = [
    TagItem(1, "First Value"),
    TagItem(2, "Second Item"),
    TagItem(3, "Third Item"),
    TagItem(4, "Fourth Item")
  ];

  List<DropdownMenuItem<TagItem>>? _dropdownMenuItems;
  TagItem? _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems![0].value;
  }

  List<DropdownMenuItem<TagItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<TagItem>> items = [];
    for (TagItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.7,
            maxChildSize: 1,
            builder: (_, controller) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 35,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.done_rounded),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 3,
                      width: 80,
                      color: Colors.white,
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 35,
                        left: 24,
                        right: 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    borderRadius: BorderRadius.circular(15),
                                    value: _selectedItem,
                                    items: _dropdownMenuItems,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedItem = value as TagItem?;
                                      });
                                    }),
                              ),
                            ),
                          ),
                          Container(
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
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add an Title",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            maxLines: 20,
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