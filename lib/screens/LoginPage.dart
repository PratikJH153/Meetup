import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/helper/utils/fire_auth.dart';
import '/helper/utils/validator.dart';
import '/widgets/ask_account_widget.dart';
import '/widgets/google_signin_button.dart';
import '/widgets/text_field_widget.dart';
import '/screens/HomePage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginpage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  void _submit() async {
    _focusEmail.unfocus();
    _focusPassword.unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      User? user = await FireAuth.signInUsingEmailPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 60,
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
                                CupertinoIcons.arrow_uturn_left,
                                color: Colors.grey[700],
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFd4d4d4),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Let's hop you in!",
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              wordSpacing: 2,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          const SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFieldWidget(
                                  editingController: _emailTextController,
                                  label: "Email",
                                  validatorHandler: (value) =>
                                      Validator.validateEmail(
                                    email: value,
                                  ),
                                  focus: _focusEmail,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFieldWidget(
                                  editingController: _passwordTextController,
                                  label: "Password",
                                  validatorHandler: (value) =>
                                      Validator.validatePassword(
                                    result: value,
                                  ),
                                  focus: _focusPassword,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
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
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GoogleSignInButton(
                                () {
                                  print("GOOGLE SIGNIN");
                                },
                              ),
                              GestureDetector(
                                onTap: _submit,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[400]!,
                                        blurRadius: 5,
                                        spreadRadius: 0.5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFee0979),
                                        Color(0xFFff6a00),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: askAccountWidget(
                                  title: "I don't have an account",
                                  tapHandler: () => Navigator.pushNamed(
                                    context,
                                    RegisterPage.routeName,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
