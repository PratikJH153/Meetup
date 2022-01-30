import 'package:flutter/material.dart';
import 'package:meetupapp/screens/LoginPage.dart';
import 'package:meetupapp/screens/RegisterPage.dart';

class GetStartedPage extends StatelessWidget {
  static const routeName = "/getstarted";
  const GetStartedPage({Key? key}) : super(key: key);

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
                    "Let's start a Meetup.",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Here is the place where the 'Magic' happens, surround yourselves with a mist of Like minds! JOIN US!",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF212121),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pushNamed(
                        RegisterPage.routeName,
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                          LoginPage.routeName,
                        ),
                        child: const Text(
                          "I already have an account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            fontSize: 15,
                          ),
                        ),
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
