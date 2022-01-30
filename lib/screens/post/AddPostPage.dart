import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/ERROR_CODE_CUSTOM.dart';
import '/helper/APIS.dart';
import '/utils/validator.dart';

class AddPost extends StatefulWidget {
  AddPost();

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Add post"),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Column(children: [
            const SizedBox(height: 10),
            Form(
              key: _registerFormKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      focusNode: _focusTitle,
                      validator: (value) => Validator.validateTextField(
                          result: value, message: "Check Post title!"),
                      decoration: InputDecoration(
                        hintText: "Post Title",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descController,
                      focusNode: _focusDesc,
                      maxLines: 5,
                      validator: (value) => Validator.validateTextField(
                          result: value, message: "Invalid Description!"),
                      decoration: InputDecoration(
                        hintText: "Description",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    _isProcessing
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () async {
                              bool isValidInput =
                                  _registerFormKey.currentState!.validate();

                              if (isValidInput) {
                                Map postData = {
                                  "title": _titleController.text,
                                  "description": _descController.text.trim(),
                                  "author":
                                      FirebaseAuth.instance.currentUser!.uid,
                                };

                                print("going for posting");
                                await _addPostAPI(postData);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
