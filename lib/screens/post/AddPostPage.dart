import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/APIS.dart';
import 'package:meetupapp/utils/validator.dart';
import '/models/community.dart';

class AddPost extends StatefulWidget {
  Community community;

  AddPost(this.community);

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add post to ${widget.community.title}"),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Column(children: [
            SizedBox(height: 10),
            Form(
              key: _registerFormKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      focusNode: _focusTitle,
                      validator: (value) => Validator.validatePostTitle(
                        title: value,
                      ),
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
                      validator: (value) => Validator.validatePostDesc(
                        desc: value,
                      ),
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
                    InkWell(
                      onTap: () async {
                        bool isValidInput =
                            _registerFormKey.currentState!.validate();

                        setState(() {
                          _isProcessing = true;
                        });

                        if (isValidInput) {
                          Map postData = {
                            "title": _titleController.text,
                            "description": _descController.text.trim(),
                            "author": FirebaseAuth.instance.currentUser!.uid,
                            "c_id": widget.community.communityID
                          };

                          Map m1 = await post_apis().addPost(postData);
                          print("Add post results!!");
                          print(m1);
                        }

                        setState(() {
                          _isProcessing = false;
                        });
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
