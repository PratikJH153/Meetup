import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar("Home"));
  }
}
