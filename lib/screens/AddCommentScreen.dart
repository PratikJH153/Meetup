import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/helper/backend/database.dart';
import '/providers/CurrentPostProvider.dart';
import '/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import '/helper/utils/validator.dart';
import '/models/post.dart';
import '/helper/backend/apis.dart';

class AddCommentPage extends StatefulWidget {
  final Post? post;
  static const routeName = "/addComment";

  const AddCommentPage({this.post});

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final _post = PostAPIS();
  final _addPostFormKey = GlobalKey<FormState>();

  bool _isAdding = false;
  bool _wentWrong = false;

  final TextEditingController _titleController = TextEditingController();

  Future<void> _addComment() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    CurrentPostProvider currentPostProvider =
        Provider.of<CurrentPostProvider>(context, listen: false);

    Map addCommentBody = {
      "message": _titleController.text,
      "userID": FirebaseAuth.instance.currentUser!.uid
    };

    final addCommentData =
        await _post.addComment(widget.post!.postID!, addCommentBody);
    Map unpackedAddCommentData = unPackLocally(addCommentData);

    if (unpackedAddCommentData["success"] == 1) {
      Map receivedData = unpackedAddCommentData["unpacked"];
      Fluttertoast.showToast(msg: "Added Comment Successfully!");

      Map comment = {
        "_id": receivedData["_id"],
        "message": receivedData["message"],
        "userID": {
          "_id": receivedData["userID"],
          "username": userProvider.getUser()!.username,
          "profileURL": userProvider.getUser()!.profileURL,
        },
        "timestamp": receivedData["timestamp"],
        "__v": 0
      };

      currentPostProvider.addSingleComment(comment);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }

    setState(() {
      _isAdding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your comment",
              style: TextStyle(
                  color: Colors.grey[800], fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(15),
              child: _isAdding
                  ? const SizedBox(child: CircularProgressIndicator())
                  : IconButton(
                      icon: const Icon(Icons.check, color: Colors.black),
                      onPressed: () async {
                        bool isValidCommentEntered =
                            _addPostFormKey.currentState!.validate();
                        if (isValidCommentEntered) {
                          _addComment();
                        }
                      },
                    ),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _addPostFormKey,
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Icon(Icons.android),
                //     Text(userProvider.getUser()!.username!),
                //   ],
                // ),
                TextFormField(
                  controller: _titleController,
                  validator: (value) =>
                      Validator.validateTextField(result: value),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
