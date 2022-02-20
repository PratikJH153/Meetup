import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/widgets/authentication_button.dart';

import '/helper/GlobalFunctions.dart';
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

  bool _isProcessing = false;

  void _submit() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      setState(() {
        _isProcessing = true;
      });

      User? user = await FireAuth.signInUsingEmailPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
        context: context,
      );

      if (user != null) {
        await initialize(context).then((v) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            (route) => false,
          );
        });
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _signInGoogle() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isProcessing = true;
    });

    User? user = await FireAuth.signInWithGoogle(context: context);
    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (route) => false,
      );
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
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
            margin: const EdgeInsets.only(bottom: 35),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _isProcessing
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Color(0xFF4776E6),
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthenticationButton(
                        tapHandler: _submit,
                        label: "Sign in",
                      ),
                      GoogleSignInButton(_signInGoogle),
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            CupertinoIcons.arrow_turn_up_left,
                            color: Colors.grey[700],
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Hey,\nLogin Now.",
                        style: TextStyle(
                          fontSize: 32,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito",
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      askUserAccountWidget(
                        title: "Want to create a account?",
                        label: "Create one.",
                        tapHandler: () => Navigator.pushNamed(
                          context,
                          RegisterPage.routeName,
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
                              icon: CupertinoIcons.mail_solid,
                              inputType: TextInputType.emailAddress,
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
                              icon: CupertinoIcons.lock,
                              inputType: TextInputType.visiblePassword,
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
        ),
      ),
    );
  }
}
