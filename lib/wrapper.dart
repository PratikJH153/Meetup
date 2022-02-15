import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/authentication/get_started_page.dart';
import 'screens/HomePage.dart';

class Wrapper extends StatefulWidget {
  static const routeName = "/wrapper";

  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late User? user;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          // FETCH USER
          return const HomePage();
        } else {
          return const GetStartedPage();
        }
      },
    );
  }
}
