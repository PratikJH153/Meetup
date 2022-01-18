import 'package:flutter/material.dart';
import 'package:meetupapp/helper/auth.dart';
import 'package:meetupapp/views/authentication/login_page.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Home"),
      body: Center(
        child: TextButton(
          child: const Text("Logout"),
          onPressed: () {
            try {
              AuthService.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginPage.routeName, (route) => false);
            } catch (err) {
              print("ERROR FROM LOGOUT");
            }
          },
        ),
      ),
    );
  }
}
