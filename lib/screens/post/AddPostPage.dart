import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/screens/SelectFilterPage.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '/helper/backend/database.dart';
import '/providers/UserProvider.dart';
import '/helper/utils/loader.dart';
import '/helper/utils/validator.dart';
import '/helper/backend/apis.dart';
import '/models/post.dart';
import '/widgets/constants.dart';

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

  bool _isLoading = false;
  String _selectedTag = "Tag";

  Future<void> _addPostApi(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    final addPost = await PostAPIS.addPost({
      "title": _titleController.text.trim(),
      "description": _descController.text.trim(),
      "author": userProvider.getUser()!.userID,
      "tag": _selectedTag,
      "createdAt": DateTime.now().toIso8601String(),
    });
    Map requestData = unPackLocally(addPost, toPrint: true);

    if (requestData["success"] == 1) {
      Map unpacked = requestData["unpacked"];
      Map addPostBody = {
        "_id": unpacked["_id"],
        "createdAt": unpacked["createdAt"],
        "title": unpacked["title"],
        "desc": unpacked["description"] ?? "",
        "tag": unpacked["tag"],
        "author": {
          "_id": unpacked["author"],
          "username": userProvider.getUser()!.username,
          "profileURL": userProvider.getUser()!.profileURL,
        },
        "comments": unpacked["comments"] ?? [],
        "upvotes": unpacked["upvotes"] ?? 0,
        "downvotes": unpacked["downvotes"] ?? 0,
      };

      userProvider.addSingleUserPost(addPostBody);
      Fluttertoast.showToast(msg: "Added Post successfully!");
    } else {
      Fluttertoast.showToast(msg: requestData["unpacked"]);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  static const Map _interests = {
    "Web development": true,
    "Flutter": true,
    "Android": true,
  };

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    setState(() {
      for (String city in _interests.keys.toList()) {
        items.add(DropdownMenuItem(value: city, child: Text(city)));
      }
    });
    return items;
  }

  Widget _filterBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          DropdownButton(
            hint: Text(_selectedTag),
            items: getDropDownMenuItems(),
            onChanged: (String? s) {
              setState(() {
                _selectedTag = s!;
              });
            },
          ),
        ]),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const GlobalLoader()
            : LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          UpperWidgetOfBottomSheet(
                            tapHandler: () async {
                              if (_selectedTag == "Tag") {
                                Fluttertoast.showToast(
                                    msg: "Select a tag to procced");
                                return;
                              }
                              if (_addPostFormKey.currentState!.validate()) {
                                _addPostApi(context);
                              }
                            },
                            toShow: true,
                            icon: CupertinoIcons.checkmark_alt,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 30,
                                left: kLeftPadding,
                                right: kLeftPadding,
                                bottom: 50,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Form(
                                key: _addPostFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     _selectedTag =
                                    //         await Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //         builder: (ctx) =>
                                    //             ChoiceChipDisplay(_selectedTag),
                                    //       ),
                                    //     );
                                    //     if (_selectedTag == Null) {
                                    //       _selectedTag = "Tag";
                                    //     }
                                    //   },
                                    //   child: Container(
                                    //     padding: const EdgeInsets.symmetric(
                                    //       horizontal: 15,
                                    //       vertical: 8,
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //       color: _selectedTag != "Tag"
                                    //           ? const Color(0xFF6b7fff)
                                    //           : Colors.grey,
                                    //       borderRadius:
                                    //           BorderRadius.circular(15),
                                    //     ),
                                    //     child: Text(
                                    //       _selectedTag,
                                    //       style: const TextStyle(
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w900,
                                    //         fontFamily: "Raleway",
                                    //         letterSpacing: 0.8,
                                    //         fontSize: 11,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    _filterBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      maxLines: null,
                                      controller: _titleController,
                                      style: TextStyle(
                                        height: 1.3,
                                        fontSize: 20,
                                        color: Colors.grey[800],
                                      ),
                                      validator: (value) =>
                                          Validator.validateTitle(
                                        result: value,
                                        message: "Enter a valid Title",
                                      ),
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
                                      style: TextStyle(
                                        height: 1.5,
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                      ),
                                      maxLength: 1000,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Give a description (Optional)",
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
                      ),
                    ),
                  ),
                );
              }),
      ),
    );
  }
}
