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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MeetUp",
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (ctx) => const LoginPage(),
        RegisterPage.routeName: (ctx) => const RegisterPage(),
        UserDetailsRegisterPage.routeName: (ctx) =>
            const UserDetailsRegisterPage(),
        HomePage.routeName: (ctx) => const HomePage(),
      },
    );
  }
}
