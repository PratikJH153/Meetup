// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AboutAndHelpPage extends StatelessWidget {
  static const routeName = "aboutAndHelpPage";
  const AboutAndHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(child: Text("About and Help")),
      ),
    );
  }
}
