import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetupapp/screens/authentication/Register_1_page.dart';
import 'package:meetupapp/screens/authentication/Register_2_page.dart';
import 'package:meetupapp/screens/authentication/Register_3_page.dart';
import 'package:meetupapp/screens/authentication/Register_4_page.dart';
import 'package:meetupapp/screens/authentication/Register_5_page.dart';
import 'package:meetupapp/widgets/ask_account_widget.dart';
import 'package:meetupapp/widgets/authentication_button.dart';
import 'package:meetupapp/widgets/drop_down_widget.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
import 'package:meetupapp/widgets/text_field_widget.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '/helper/utils/fire_auth.dart';
import '/helper/utils/validator.dart';
import '/helper/backend/apis.dart';
import '/screens/HomePage.dart';
import 'LoginPage.dart';

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

  bool _isProcessing = false;
  int step = 1;

  String gendervalue = 'Male';
  int age = 20;

  final genders = const [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  List<String> _selectedInterests = [];

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _bioTextController.dispose();
  }

  void _submit() async {
    setState(() {
      _isProcessing = true;
    });

    if (step == 1) {
      if (_registerFormKey.currentState!.validate()) {
        print("GO FORWARD");
        setState(() {
          step += 1;
        });
      }
    } else if (step == 2) {
      if (_registerFormKey.currentState!.validate()) {
        print("GO FORWARD");
        setState(() {
          step += 1;
        });
      }
    } else if (step == 3 || step == 4) {
      setState(() {
        step += 1;
      });
    } else if (step == 5) {
      if (_selectedInterests.length < 5) {
        snackBarWidget("Please select atleast 5 Interests",
            const Color(0xFFff2954), context);
      } else {
        final user = await FireAuth.registerUsingEmailPassword(
          name: _nameTextController.text,
          email: _emailTextController.text,
          password: _passwordTextController.text,
        );
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
            "email": _emailTextController.text.trim(),
            "profileURL": url ??
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            "gender": gendervalue,
            "age": age,
            "bio": _bioTextController.text.trim() != ""
                ? _bioTextController.text.trim()
                : "A meetup user!",
            "interests": _selectedInterests,
          };

          Map result = await UserAPIS().addUser(userMap);
          print(result);
          if (result["local_status"] != 200) {
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
    PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);

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
      print("Done");
    });

    final url = await ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
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
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _isProcessing
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Color(0xFFff6a00),
                        ),
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
                    left: 25.0,
                    right: 25.0,
                    top: 30,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            CupertinoIcons.back,
                            color: Colors.grey[700],
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                      askUserAccountWidget(
                        title: "Already have an account?",
                        label: "Login Now.",
                        tapHandler: () => Navigator.pushNamed(
                          context,
                          LoginPage.routeName,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LinearPercentIndicator(
                            backgroundColor: const Color(0xFFe8e8e8),
                            barRadius: const Radius.circular(5),
                            lineHeight: 2,
                            percent: step / 5,
                            padding: EdgeInsets.zero,
                            progressColor: const Color(0xFFFF416C),
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
                                  text: "/ 5 Steps",
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
                                ? Register1(
                                    emailController: _emailTextController,
                                    passwordController: _passwordTextController,
                                  )
                                : step == 2
                                    ? Register2(
                                        firstNameController:
                                            _firstNameController,
                                        lastNameController: _lastNameController,
                                        nameController: _nameTextController,
                                      )
                                    : step == 3
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
                                        : step == 4
                                            ? Register4(
                                                image: image,
                                                tapHandler: _imagePicker,
                                              )
                                            : step == 5
                                                ? Register5(
                                                    selectedInterests:
                                                        _selectedInterests,
                                                    tapHandler: (val) {
                                                      if (_selectedInterests
                                                          .contains(val)) {
                                                        setState(() {
                                                          _selectedInterests
                                                              .remove(val);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _selectedInterests
                                                              .add(val);
                                                        });
                                                      }
                                                    },
                                                  )
                                                : SizedBox()
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