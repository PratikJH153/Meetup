import 'package:flutter/material.dart';
import '/screens/LoginPage.dart';
import '/screens/RegisterPage.dart';
import '/widgets/ask_account_widget.dart';

class GetStartedPage extends StatelessWidget {
  static const routeName = "/getstarted";

  const GetStartedPage({Key? key}) : super(key: key);

  static const String _alreadyHaveAccount = "I already have an account";
  static const String _startAMeetup = "Let's start a Meetup!";
  static const String _descGetStarted = "Here is the place where the 'Magic' happens, surround yourselves with a mist of Like minds! JOIN US!";
  static const String _getStarted = "Get Started";
  static const String _fontFamily = "Quicksand";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/space.gif",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    _startAMeetup,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
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
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
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
    );
  }
}
