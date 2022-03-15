import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/providers/PostProvider.dart';
import 'package:meetupapp/providers/PostProvider.dart';
import 'package:meetupapp/widgets/ask_dialog_widget.dart';
import 'package:provider/provider.dart';

import '/widgets/upper_widget_bottom_sheet.dart';
import '/helper/backend/database.dart';
import '/providers/UserProvider.dart';
import '/helper/utils/loader.dart';
import '/helper/utils/validator.dart';
import '/helper/backend/apis.dart';
import '/widgets/constants.dart';

class AddPost extends StatefulWidget {
  static const routeName = "/addpost";

  const AddPost();

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _addPostFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  String _selectedTag = "Tag";

  Future<void> _addPostApi(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
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

      postProvider.addSingleUserPost(addPostBody);
      userProvider.addPostCount();
      Fluttertoast.showToast(msg: "Added Post successfully!");
      setState(() {
        _isLoading = false;
      });
      Navigator.of(_scaffoldKey.currentState!.context).pop();
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: requestData["unpacked"]);
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    List<DropdownMenuItem<String>> items = [];
    for (String city in userProvider.getUser()!.interests!) {
      items.add(
        DropdownMenuItem(
          value: city,
          child: Text(city),
        ),
      );
    }
    return items;
  }

  Widget _filterBox() {
    return DropdownButton(
      hint: Text(_selectedTag),
      elevation: 1,
      borderRadius: BorderRadius.circular(15),
      dropdownColor: Colors.white,
      items: getDropDownMenuItems(),
      underline: const SizedBox(),
      onChanged: (String? s) {
        setState(() {
          _selectedTag = s!;
        });
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<bool> showDiscardChangesWidget() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (ctx) => DiscardAskDialogWidget(
        tapHandler: () {
          return Navigator.of(context).pop(true);
        },
        title: "Discard Changes?",
        des: "Changes on this page will not be saved.",
      ),
    );
    return shouldPop;
  }

  bool lookForChanges() {
    return (_titleController.text.trim().isNotEmpty ||
        _descController.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    print("ADD POST PAGE BUILD");
    return WillPopScope(
      onWillPop: () async {
        if (lookForChanges()) {
          return showDiscardChangesWidget();
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: _isLoading
              ? const GlobalLoader()
              : LayoutBuilder(
                  builder: (context, constraint) {
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            UpperWidgetOfBottomSheet(
                              backTapHandler: () async {
                                if (lookForChanges()) {
                                  final shouldPop =
                                      await showDiscardChangesWidget();
                                  if (shouldPop) {
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
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
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: kLeftPadding + 10,
                                    right: kLeftPadding + 10,
                                    bottom: 50,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Form(
                                    key: _addPostFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          validator: (value) =>
                                              Validator.validateTitle(
                                            result: value!.trim(),
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
                                          maxLength: 5000,
                                          textCapitalization:
                                              TextCapitalization.sentences,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
