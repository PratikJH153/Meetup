import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/providers/PostProvider.dart';
import '/helper/utils/validator.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';

class AddCommentPage extends StatefulWidget {
  Post? post;
  static const routeName = "/addComment";

  AddCommentPage({this.post});

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final _post = PostAPIS();
  final _addPostFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  bool _isLoading = false;

  Future<Map> unPackLocally() async {
    print("CALLING /addComment");

    Map addCommentBody = {
      "message": _titleController.text,
      "userID": FirebaseAuth.instance.currentUser!.uid
    };

    final data = await _post.addComment(widget.post!.postID.toString(), addCommentBody);

    bool receivedResponseFromServer = data["local_status"] == 200;
    Map localData = data["local_result"];

    if (receivedResponseFromServer) {
      bool dataReceivedSuccessfully = localData["status"] == 200;
      print(localData);

      if (dataReceivedSuccessfully) {
        Map? requestedSuccessData = localData["data"];
        print("SUCCESS DATA:");
        print(requestedSuccessData);
        print("-----------------\n\n");

        return {"success": 1, "unpacked": requestedSuccessData};
      } else {
        Map? requestFailedData = localData["data"];
        print("INCORRECT DATA:");
        print(requestFailedData);
        print("-----------------\n\n");
        return {
          "success": 0,
          "unpacked": "Internal Server error!Wrong request sent!"
        };
      }
    } else {
      print(localData);
      print("Server Down! Status:$localData");
      print("-----------------\n\n");

      return {"success": 0, "unpacked": "Couldn't reach the servers!"};
    }
  }

  Future<void> _addComment() async {
    setState(() {
      _isLoading = true;
    });
    final res = await unPackLocally();
    setState(() {
      _isLoading = false;
    });
    if (res["success"] == 1) {
      print("ADD COMMENT RESULT");
      Map _data = res["unpacked"];
      Fluttertoast.showToast(msg: "Comment added successfully!");
      PostProvider postProvider =
          Provider.of<PostProvider>(context, listen: false);
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      Map readableCommentJSON = {
        "_id": _data["_id"],
        "message": _data["message"],
        "userID": {
          // THE USER FORMAT AS RETURNED FROM THE BACKEND
          "username": userProvider.getUser()!.username,
          "_id": userProvider.getUser()!.userID,
          "profileURL": userProvider.getUser()!.profileURL
        },
        "username": userProvider.getUser()!.username,
        "timestamp": _data["timestamp"],
        "userProfile": userProvider.getUser()!.profileURL
      };

      postProvider.addSingleComment(readableCommentJSON);
      Navigator.pop(context);
    }
    else{
      Fluttertoast.showToast(msg: "Failed to add comment!");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
            _isLoading
                ? const Icon(Icons.more_horiz, color: Colors.black)
                : IconButton(
                    icon: const Icon(Icons.check, color: Colors.black),
                    onPressed: () async {
                      bool isValidCommentEntered =
                          _addPostFormKey.currentState!.validate();
                      if (isValidCommentEntered) {
                        _addComment();
                      }
                    },
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
