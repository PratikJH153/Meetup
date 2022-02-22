import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/screens/SearchPage.dart';
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
    const SearchPage(),
    Container(),
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
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                resizeToAvoidBottomInset: false,
                floatingActionButton: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
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
                    vertical: 14,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      InkWell(
                        child: BottomNavButton(
                          icon: CupertinoIcons.search,
                          isSelected: _selectedIndex == 1,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                      BottomAddButton(tapHandler: () async {
                        // showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   backgroundColor: Colors.transparent,
                        //   barrierColor: const Color(0xFF383838),
                        //   builder: (ctx) {
                        //     return const AddPost();
                        //   },
                        // );
                        Navigator.of(context).pushNamed(AddPost.routeName);
                      }),
                      InkWell(
                        child: BottomNavButton(
                          icon: CupertinoIcons.bookmark,
                          isSelected: _selectedIndex == 2,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300]!,
                                  blurRadius: 2,
                                  spreadRadius: 0.1,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              image: DecorationImage(
                                image: NetworkImage(
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .getUser()!
                                      .profileURL!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   child: BottomNavButton(
                      //     icon: CupertinoIcons.person_alt,
                      //     isSelected: _selectedIndex == 1,
                      //   ),
                      // ),
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
