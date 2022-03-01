import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/GlobalFunctions.dart';
import 'package:meetupapp/screens/authentication/RegisterPage.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
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
    print("WRAPPER CALLED");
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot snapshot) {
        print("STREAM AND FUTURE WRAPPER CALLED");
        if (snapshot.hasData) {
          return FutureBuilder(
            future: checkUserExists(context, snapshot.data!.uid!),
            builder: (ctx, AsyncSnapshot snap) {
              if (snap.hasData) {
                final data = snap.data;
                if (data == 1) {
                  return const HomePage();
                } else {
                  // Fluttertoast.showToast(msg: "Error while Authenticating");
                  return const GetStartedPage();
                }
              } else if (snap.hasError) {
                Fluttertoast.showToast(msg: "Error while Authenticating");
                return const GetStartedPage();
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
        return const GetStartedPage();
      },
    );
  }
}
