import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/APIS.dart';
import 'package:meetupapp/utils/validator.dart';

class AddCommunity extends StatefulWidget {
  @override
  State<AddCommunity> createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  // community_apis().addCommunity(
  final _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  final _focusTitle = FocusNode();
  final _focusDesc = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Create New Community"),
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
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _tagsController,
                      validator: (value) => Validator.validateTextField(
                        result: value,
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
                            "title": "ShowerThoughts",
                            "description":
                                "A community to post that one thought you came across in the shower",
                            "tags": ["Statement", "interesting", "New"],
                            "levelCupCakes": 100
                          };

                          Map m1 =
                              await community_apis().addCommunity(postData);
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
