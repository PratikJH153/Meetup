import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import '/widgets/ask_account_widget.dart';

class GetStartedPage extends StatelessWidget {
  static const routeName = "/getstarted";

  const GetStartedPage({Key? key}) : super(key: key);

  static const String _alreadyHaveAccount = "I already have an account";
  static const String _startAMeetup = "Let's start a Meetup!";
  static const String _descGetStarted =
      "Here is the place where the 'Magic' happens, surround yourselves with a mist of Like minds! JOIN US!";
  static const String _getStarted = "Get Started";
  static const String _fontFamily = "Nunito";

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
                      _startAMeetup,
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
                      _descGetStarted,
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        wordSpacing: 1,
                        height: 1.5,
                        fontFamily: _fontFamily,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
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
                        onPressed: () => Navigator.of(context).pushNamed(
                          RegisterPage.routeName,
                        ),
                        child: const Text(
                          _getStarted,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: askAccountWidget(
                        title: _alreadyHaveAccount,
                        tapHandler: () => Navigator.pushNamed(
                          context,
                          LoginPage.routeName,
                        ),
                      ),
                    ),
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
