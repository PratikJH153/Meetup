import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/screens/FeedScreen.dart';
import 'package:meetupapp/screens/HomePage.dart';
import 'package:meetupapp/screens/LoginPage.dart';
import 'package:meetupapp/screens/ProfilePage.dart';
import 'package:meetupapp/screens/RegisterPage.dart';
import 'package:meetupapp/screens/get_started_page.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
import 'providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (c) => UserProvider())],
      child: MaterialApp(
        title: 'Flutter Authentication',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFfafbff),
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 24.0,
                fontFamily: "Ubuntu",
              ),
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            ),
          ),
          fontFamily: "Ubuntu",
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 46.0,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
            bodyText1: const TextStyle(fontSize: 18.0),
          ),
        ),
        initialRoute: Wrapper.routeName,
        routes: {
          Wrapper.routeName: (ctx) => const Wrapper(),
          HomePage.routeName: (ctx) => const HomePage(),
          LoginPage.routeName: (ctx) => const LoginPage(),
          RegisterPage.routeName: (ctx) => const RegisterPage(),
          GetStartedPage.routeName: (ctx) => const GetStartedPage(),
          ProfilePage.routeName: (ctx) => const ProfilePage(),
          FeedPage.routeName: (ctx) => const FeedPage(),
          AddPost.routeName: (ctx) => const AddPost(),
        },
      ),
    );
  }
}
