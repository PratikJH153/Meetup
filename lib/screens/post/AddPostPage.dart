import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/helper/backend/database.dart';
import '/providers/UserProvider.dart';
import '/helper/utils/loader.dart';
import '/helper/utils/validator.dart';
import '/helper/backend/apis.dart';
import '/models/post.dart';
import '/widgets/constants.dart';

class AddPost extends StatefulWidget {
  final Post? post;
  static const routeName = "/addpost";

  AddPost({this.post});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _addPostFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  String _selectedTag = "Flutter";

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
      "tag": _selectedTag
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
      Navigator.of(context).pop();
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
    "Web development":true,
    "Flutter":true,
    "Android":true,
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: SafeArea(
        child: Scaffold(
          body: _isLoading
              ? const GlobalLoader()
              : GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: kLeftPadding,
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
                                    onPressed: () async {
                                      _addPostApi(context);
                                    },
                                    icon: const Icon(Icons.check)
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 30,
                            left: kLeftPadding,
                            right: kLeftPadding,
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
                                _filterBox(),
                                TextFormField(
                                  maxLines: null,
                                  controller: _titleController,
                                  style: const TextStyle(height: 1.3),
                                  validator: (value) => Validator.validateTitle(
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
                                  style: const TextStyle(height: 1.5),
                                  maxLength: 1000,
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
                  ),
                ),
        ),
      ),
    );
  }
}
