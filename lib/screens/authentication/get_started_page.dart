import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/GlobalFunctions.dart';
import 'package:meetupapp/helper/backend/apis.dart';
import 'package:meetupapp/helper/backend/database.dart';
import 'package:meetupapp/helper/backend/rest_apis.dart';
import 'package:meetupapp/helper/utils/fire_auth.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/screens/HomePage.dart';
import 'package:meetupapp/widgets/google_signin_button.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import '/widgets/ask_account_widget.dart';

class GetStartedPage extends StatefulWidget {
  static const routeName = "/getstarted";

  const GetStartedPage({Key? key}) : super(key: key);

  // static const String _alreadyHaveAccount = "I already have an account";
  static const String _startAMeetup = "Let's start a Meetup!";
  static const String _descGetStarted =
      "Here is the place where the 'Magic' happens, surround yourselves with a mist of Like minds! JOIN US!";
  static const String _getStarted = "Get Started";
  static const String _fontFamily = "Nunito";

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  bool _isProcessing = false;

  void _signInGoogle() async {
    setState(() {
      _isProcessing = true;
    });

    User? user = await FireAuth.signInWithGoogle(
      context: context,
      label: "Error while Google sign in",
    );
    if (user != null) {
      checkUserExists(
        context,
        user.uid.toString(),
      );
    }
    setState(() {
      _isProcessing = false;
    });
  }

  void _signUpGoogle() async {
    setState(() {
      _isProcessing = true;
    });

    User? user = await FireAuth.signInWithGoogle(
      context: context,
      label: "Error while Google sign up",
    );
    if (user != null) {
      print("HELLO");
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 34,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/images/phone.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      GetStartedPage._startAMeetup,
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      GetStartedPage._descGetStarted,
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        wordSpacing: 1,
                        height: 1.5,
                        fontFamily: GetStartedPage._fontFamily,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    !_isProcessing
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 6,
                                    primary: const Color(0xFF212121),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                  onPressed: _signUpGoogle,
                                  child: const Text(
                                    GetStartedPage._getStarted,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              GoogleSignInButton(
                                _signInGoogle,
                              ),
                            ],
                          )
                        : const Center(
                            child: GlobalLoader(),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
