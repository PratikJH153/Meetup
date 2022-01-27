import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/APIS.dart';
import 'package:meetupapp/screens/HomePage.dart';
import '/utils/fire_auth.dart';
import '/utils/validator.dart';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  static const id = "/registerPage";

  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _interestTextController = TextEditingController();
  final _genderTextController = TextEditingController();
  final _bioTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusAge = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusInterest = FocusNode();
  final _focusGender = FocusNode();
  final _focusBio = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[ 
                        TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateTextField(
                            result: value,
                            message: "Enter a valid name!"
                          ),
                          decoration: InputDecoration(
                            hintText: "Username",
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
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
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
                          controller: _ageTextController,
                          focusNode: _focusAge,
                          keyboardType: TextInputType.number,
                          validator: (value) => Validator.validateTextField(
                              result: value, message: "Enter a valid age"),
                          decoration: InputDecoration(
                            hintText: "Enter your age",
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
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            result: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
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
                          controller: _interestTextController,
                          focusNode: _focusInterest,
                          validator: (value) => Validator.validateTextField(
                            result: value,
                            message: "Enter valid interests!",
                          ),
                          decoration: InputDecoration(
                            hintText: "Interests(Space separated)",
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
                          controller: _bioTextController,
                          focusNode: _focusBio,
                          validator: (value) => Validator.validateTextField(
                              result: value, message: "Invalid Bio entered!"),
                          decoration: InputDecoration(
                            hintText: "Bio(Description)",
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
                          controller: _genderTextController,
                          focusNode: _focusGender,
                          validator: (value) => Validator.validateTextField(
                            result: value,
                            message: "Enter a valid gender",
                          ),
                          decoration: InputDecoration(
                            hintText: "Gender",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        _isProcessing
                            ? const CircularProgressIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        bool correctValuesEntered =
                                            _registerFormKey.currentState!
                                                .validate();

                                        if (correctValuesEntered) {
                                          // IF THE FORM HAS BEEN VALIDATED
                                          final user = await FireAuth
                                              .registerUsingEmailPassword(
                                            name: _nameTextController.text,
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text,
                                          );

                                          // if (false) {
                                          if (user == null) {
                                            Fluttertoast.showToast(
                                                msg: "Couldn't create user!");
                                            return;
                                          } else {
                                            Map userMap = {
                                              "id": user.uid.toString(),
                                              "username": _nameTextController
                                                  .text
                                                  .toString(),
                                              "email": _emailTextController.text
                                                  .toString(),
                                              "gender": _genderTextController
                                                  .text
                                                  .toString(),
                                              "age": _ageTextController.text
                                                  .toString(),
                                              "bio": _bioTextController.text
                                                  .toString(),
                                              "interests":
                                                  _interestTextController.text
                                                      .split(" ")
                                                      .toList()
                                            };

                                            await user_apis().addUser(userMap);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        HomePage()));
                                          }
                                        } else {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }

                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
