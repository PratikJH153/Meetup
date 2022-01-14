import 'package:flutter/material.dart';
import 'package:meetupapp/view/home_page.dart';

Future<void> main() async {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(BuildContext context) => HomePage()
    },
  ));
}
