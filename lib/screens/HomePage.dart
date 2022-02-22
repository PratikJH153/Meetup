import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/helper/GlobalFunctions.dart';
import '/helper/utils/loader.dart';
import '/screens/post/AddPostPage.dart';
import '/widgets/bottom_add_button.dart';
import '/widgets/bottom_nav_button.dart';
import '/screens/FeedScreen.dart';
import '/providers/UserProvider.dart';
import '/screens/ProfilePage.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/homepage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? user;

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const FeedPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // USER NOT LOADED
      Fluttertoast.showToast(msg: "Something went wrong!");
      return;
    }

    initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isLoadingComplete = userProvider.isUserDataLoaded;
    bool wentWrong = userProvider.wentWrongUser;

    return wentWrong
        ? const Scaffold(
            body: Center(
              child: Text("Something went wrong!"),
            ),
          )
        : !isLoadingComplete
            ? Scaffold(body: GlobalLoader())
            : Scaffold(
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: BottomNavButton(
                          icon: CupertinoIcons.bolt_horizontal_fill,
                          isSelected: _selectedIndex == 0,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      BottomAddButton(tapHandler: () async {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: const Color(0xFF383838),
                          builder: (ctx) {
                            return AddPost();
                          },
                        );
                      }),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: BottomNavButton(
                          icon: CupertinoIcons.person_alt,
                          isSelected: _selectedIndex == 1,
                        ),
                      ),
                    ],
                  ),
                ),
                body: RefreshIndicator(
                  child: _widgetOptions[_selectedIndex],
                  backgroundColor: Colors.red,
                  color: Colors.white,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        setState(() {
                          initialize(context);
                        });
                      },
                    );
                  },
                ),
              );
  }
}
