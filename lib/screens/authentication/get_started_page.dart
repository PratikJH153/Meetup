import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/helper/GlobalFunctions.dart';
import '/helper/utils/fire_auth.dart';
import '/helper/utils/loader.dart';
import '/screens/HomePage.dart';
import '/widgets/google_signin_button.dart';
import '/widgets/snackBar_widget.dart';
import 'RegisterPage.dart';

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

  void _signInGoogle(BuildContext ctx) async {
    setState(() {
      _isProcessing = true;
    });

    User? user = await FireAuth.signInWithGoogle(
      context: ctx,
      label: "Error while Google sign in",
    );
    if (user != null) {
      final status = await checkUserExists(
        context,
        user.uid.toString(),
      );
      if (status == 1) {
        Navigator.of(ctx, rootNavigator: true)
            .pushReplacementNamed(HomePage.routeName);
        return;
      } else if (status == 2) {
        Navigator.of(ctx, rootNavigator: true)
            .pushReplacementNamed(RegisterPage.routeName);
        return;
      } else {
        snackBarWidget(
          "Error while Authenticating",
          const Color(0xFFff2954),
          ctx,
        );
        return;
      }
    }
    setState(() {
      _isProcessing = false;
    });
  }

  void _signUpGoogle(BuildContext ctx) async {
    setState(() {
      _isProcessing = true;
    });

    User? user = await FireAuth.signInWithGoogle(
      context: ctx,
      label: "Error while Google sign up",
    );
    if (user != null) {
      final status = await checkUserExists(
        ctx,
        user.uid.toString(),
      );
      if (status == 1) {
        Navigator.of(ctx, rootNavigator: true)
            .pushReplacementNamed(HomePage.routeName);
        return;
      } else if (status == 2) {
        Navigator.of(ctx, rootNavigator: true)
            .pushReplacementNamed(RegisterPage.routeName);
        return;
      } else {
        snackBarWidget(
          "Error while Authenticating",
          const Color(0xFFff2954),
          ctx,
        );
        return;
      }
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("GET STARTED BUILD");
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
                                  onPressed: () => _signUpGoogle(context),
                                  child: const Text(
                                    GetStartedPage._getStarted,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              GoogleSignInButton(
                                () => _signInGoogle(context),
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
