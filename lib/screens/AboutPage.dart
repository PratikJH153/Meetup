import 'package:flutter/material.dart';

class AboutAndHelpPage extends StatelessWidget {
  static const routeName = "aboutAndHelpPage";
  const AboutAndHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text("About and Help")),
      ),
    );
  }
}
