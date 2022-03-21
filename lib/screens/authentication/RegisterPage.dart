// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/screens/authentication/Register_2_page.dart';
import '/screens/authentication/Register_3_page.dart';
import '/screens/authentication/Register_4_page.dart';
import '/screens/authentication/Register_5_page.dart';
import '/screens/HomePage.dart';
import '/widgets/authentication_button.dart';
import '/widgets/snackBar_widget.dart';
import '/helper/GlobalFunctions.dart';
import '/widgets/back_button.dart';
import '/helper/backend/apis.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/registerPage";

  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _bioTextController = TextEditingController();

  final String? googleUserProfileURL =
      FirebaseAuth.instance.currentUser!.photoURL;

  bool _isProcessing = false;
  int step = 1;

  String gendervalue = 'Male';
  int age = 20;

  final genders = const [
    'Male',
    'Female',
    'Other',
  ];

  Map _selectedInterests = {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _bioTextController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _isProcessing = true;
    });

    if (step == 1) {
      if (_registerFormKey.currentState!.validate()) {
        // print("GO FORWARD");
        final response = await checkUsernameExists(
          context,
          _nameTextController.text.trim().toLowerCase(),
        );
        if (response == 1) {
          snackBarWidget("Username Exists. Please try different username",
              const Color(0xFFff2954), context);
        } else if (response == 2) {
          setState(() {
            step += 1;
          });
        } else {}
      }
    } else if (step == 2 || step == 3) {
      setState(() {
        step += 1;
      });
    } else if (step == 4) {
      if (_selectedInterests.length < 5) {
        snackBarWidget("Please select atleast 5 Interests",
            const Color(0xFFff2954), context);
      } else {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String? url;
          if (image != null) {
            url = await uploadPic(user.uid);
          }
          Map userMap = {
            "id": user.uid.toString(),
            "firstname": _firstNameController.text.trim(),
            "lastname": _lastNameController.text.trim(),
            "username": _nameTextController.text.trim(),
            "email": user.email,
            "profileURL": url ?? user.photoURL,
            "gender": gendervalue,
            "age": age,
            "bio": _bioTextController.text.trim() != ""
                ? _bioTextController.text.trim()
                : "A Becapy user!",
            "interests": _selectedInterests.keys.toList(),
            "joinedAt": DateTime.now().toIso8601String(),
          };

          Map result = await UserAPIS.addUser(userMap);
          // print(result);
          if (result["local_status"] != 200) {
            // UserSharedPreferences.setLoginStatus();
            snackBarWidget("Sorry couldn't create your profile",
                const Color(0xFFff2954), context);
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routeName,
              (route) => false,
            );
          }
        } else {
          snackBarWidget("Sorry couldn't create your profile",
              const Color(0xFFff2954), context);
        }
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }

  File? image;

  void _imagePicker() async {
    ImagePicker _picker = ImagePicker();
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      File pickedImage = File(pickedFile.path);
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<String> uploadPic(String uid) async {
    final ref =
        FirebaseStorage.instance.ref().child("user_images").child(uid + ".jpg");

    await ref.putFile(image!).whenComplete(() {
      // print("Done");
    });

    final url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    // print("REGISTER PAGE BUILD");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 35),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _isProcessing
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Color(0xFF4776E6),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      step != 1
                          ? Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  elevation: 0.5,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (step == 3) {
                                      image = null;
                                    }
                                    step -= 1;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text(
                                  "Back",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      if (step != 1)
                        const SizedBox(
                          width: 10,
                        ),
                      Expanded(
                        child: AuthenticationButton(
                          tapHandler: _submit,
                          label: "Next",
                        ),
                      ),
                    ],
                  ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 28.0,
                    right: 28.0,
                    top: 30,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      backButton(context),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Welcome,",
                        style: TextStyle(
                          fontSize: 22,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const Text(
                        "To the Club!",
                        style: TextStyle(
                          fontSize: 30,
                          height: 1.3,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Please fill the details to continue.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          wordSpacing: 2,
                          color: Color(0xFF707070),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Quicksand",
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LinearPercentIndicator(
                            backgroundColor: const Color(0xFFe8e8e8),
                            barRadius: const Radius.circular(5),
                            lineHeight: 2,
                            percent: step / 4,
                            padding: EdgeInsets.zero,
                            progressColor: const Color(0xFF4776E6),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: step.toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: "/ 4 Steps",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          children: [
                            step == 1
                                ? Register2(
                                    firstNameController: _firstNameController,
                                    lastNameController: _lastNameController,
                                    nameController: _nameTextController,
                                  )
                                : step == 2
                                    ? Register3(
                                        genders: genders,
                                        genderValue: gendervalue,
                                        onAgeTapHandler: (val) {
                                          setState(() {
                                            age = val;
                                          });
                                        },
                                        age: age,
                                        onGenderTapHandler: (val) {
                                          setState(() {
                                            gendervalue = val;
                                          });
                                        },
                                        bioController: _bioTextController,
                                      )
                                    : step == 3
                                        ? Register4(
                                            image: image,
                                            tapHandler: _imagePicker,
                                            profileURL: googleUserProfileURL,
                                          )
                                        : step == 4
                                            ? Register5(
                                                selectedInterests:
                                                    _selectedInterests,
                                              )
                                            : const SizedBox()
                          ],
                        ),
                      ),
                    ],
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
