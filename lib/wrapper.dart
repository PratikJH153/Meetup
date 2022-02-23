import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/GlobalFunctions.dart';
import 'package:meetupapp/screens/authentication/RegisterPage.dart';
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
      builder: (context, AsyncSnapshot snapshot) {
        print("CALLED AGAIN WRAPPER!");
        if (snapshot.hasData) {
          return FutureBuilder(
            future: checkUserExists(context, snapshot.data!.uid!),
            builder: (ctx, snap) {
              if (snap.hasData) {
                final data = snap.data;
                if (data == 1) {
                  return const HomePage();
                } else if (data == 2) {
                  return const RegisterPage();
                } else {
                  return const GetStartedPage();
                }
              }
              return const GetStartedPage();
            },
          );
        }
        return const GetStartedPage();
      },
    );
  }
}
