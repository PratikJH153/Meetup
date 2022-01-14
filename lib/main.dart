import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/view/home_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(BuildContext context) => HomePage()
    },
  ));
}
