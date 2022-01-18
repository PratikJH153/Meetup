import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/views/authentication/login_page.dart';
import 'package:meetupapp/views/authentication/register_page.dart';
import 'package:meetupapp/views/authentication/user_details_register_page.dart';
import 'package:meetupapp/views/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "MeetUp",
            // initialRoute: LoginPage.routeName,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  return const HomePage();
                } else {
                  return const LoginPage();
                }
              },
            ),
            routes: {
              LoginPage.routeName: (ctx) => const LoginPage(),
              RegisterPage.routeName: (ctx) => RegisterPage(),
              UserDetailsRegisterPage.routeName: (ctx) =>
                  const UserDetailsRegisterPage(),
              HomePage.routeName: (ctx) => const HomePage(),
            },
          );
        });
  }
}
