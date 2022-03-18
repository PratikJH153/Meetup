import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/CurrentPostProvider.dart';
import 'screens/EditProfilePage.dart';
import 'screens/post/UserPostScreen.dart';
import 'helper/custom_route.dart';
import 'providers/PostProvider.dart';
import 'providers/UserProvider.dart';
import 'widgets/constants.dart';
import 'screens/FeedScreen.dart';
import 'screens/HomePage.dart';
import 'screens/ProfilePage.dart';
import 'screens/authentication/RegisterPage.dart';
import 'screens/SearchPage.dart';
import 'screens/authentication/get_started_page.dart';
import 'screens/post/AddPostPage.dart';
import 'package:provider/provider.dart';
import 'wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await UserSharedPreferences.init();

  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (c) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (c) => CurrentPostProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'BeCapy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFfafbff),
          brightness: Brightness.light,
          primaryColor: const Color(0xFFee0979),
          colorScheme: const ColorScheme.light(
            primary: kPrimaryColor,
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
            },
          ),
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
          UserPosts.routeName: (ctx) => const UserPosts(),
          HomePage.routeName: (ctx) => const HomePage(),
          RegisterPage.routeName: (ctx) => const RegisterPage(),
          GetStartedPage.routeName: (ctx) => const GetStartedPage(),
          ProfilePage.routeName: (ctx) => const ProfilePage(),
          FeedPage.routeName: (ctx) => const FeedPage(),
          AddPost.routeName: (ctx) => const AddPost(),
          SearchPage.routeName: (ctx) => const SearchPage(),
          EditProfilePage.routeName: (ctx) => const EditProfilePage(),
        },
      ),
    );
  }
}
