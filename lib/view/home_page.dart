import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String id= "HomePage";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Home"),
      ),
    );
  }
}
