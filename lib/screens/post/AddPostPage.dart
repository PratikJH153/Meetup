import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/models/post.dart';
import 'package:provider/provider.dart';
import '/helper/backend/database.dart';
import '/providers/UserProvider.dart';
import '/helper/utils/loader.dart';
import '/helper/utils/validator.dart';
import '/helper/backend/apis.dart';
import '/screens/post/AddInterestTagPage.dart';
import '/widgets/constants.dart';
import '/widgets/upper_widget_bottom_sheet.dart';

class AddPost extends StatefulWidget {
  final String? title;
  final String? description;
  final String? tag;
  final bool isEdit;
  final Post? post;
  static const routeName = "/addpost";

  AddPost(
      {this.isEdit = false, this.post, this.title, this.description, this.tag});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _post = PostAPIS();
  final _addPostFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  String _selectedTag = "Tag";

  bool isEdit = false;
  bool _toOpen = false;

  Future<void> _addPostApi(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    final addPost = await _post.addPost({
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

  //! NOT DONE YET
  Future<void> _updatePostAPI(Map body) async {
    setState(() {
      _isLoading = true;
    });

    final Map requestData = await unPackLocally(body);

    if (requestData["success"] == 1) {
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
    if (widget.post!=null) {
      _titleController.text = widget.post!.title!;
      _descController.text = widget.post!.desc??"";
      _selectedTag = widget.tag!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final interests =
        Provider.of<UserProvider>(context, listen: false).getUser()!.interests;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: SafeArea(
        child: Scaffold(
          body: _isLoading
              ? GlobalLoader(color: Colors.white)
              : GestureDetector(
                  onTap: () {},
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
                            if (!isEdit) {
                              _addPostApi(context);
                            } else {
                              Map data = {
                                "title": _titleController.text.trim(),
                                "description": _descController.text.trim(),
                                "tag": _selectedTag
                              };
                              _updatePostAPI(data);
                            }
                          }
                        },
                        icon: CupertinoIcons.checkmark_alt,
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
                                GestureDetector(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   backgroundColor: Colors.transparent,
                                    //   builder: (ctx) {
                                    //     return AddInterestTagPage(
                                    //       selectedTag: _selectedTag,
                                    //       tapHandler: (val) {
                                    //         setState(() {
                                    //           _selectedTag = val;
                                    //         });
                                    //       },
                                    //     );
                                    //   },
                                    // );
                                    setState(() {
                                      _toOpen = !_toOpen;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedTag != "Tag"
                                          ? const Color(0xFF6b7fff)
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      _selectedTag,
                                      style: const TextStyle(
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
                                if (_toOpen)
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: interests!.length,
                                      itemBuilder: (ctx, index) {
                                        return ChoiceChip(
                                          selected: true,

                                          // onSelected: (val) {
                                          //   setState(() {
                                          //     _selectedTag = val;
                                          //   });
                                          // },
                                          label: Text(interests[index]),
                                        );
                                      },
                                    ),
                                  ),
                                TextFormField(
                                  maxLines: null,
                                  controller: _titleController,
                                  style: const TextStyle(height: 1.3),
                                  validator: (value) =>
                                      Validator.validateTextField(
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
