// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/widgets/placeholder_widget.dart';
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
    // print("HOME PAGE BUILD");
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isLoadingComplete = userProvider.isUserDataLoaded;
    bool wentWrong = userProvider.wentWrongUser;

    return wentWrong
        ? const Scaffold(
            body: Center(
              child: PlaceholderWidget(
                imageURL: "assets/images/wentwrong.png",
                label: "Something went wrong.\nTry again later.",
              ),
            ),
          )
        : !isLoadingComplete
            ? const Scaffold(
                body: GlobalLoader(),
              )
            : Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                resizeToAvoidBottomInset: false,
                floatingActionButton: Container(
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
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: BottomNavButton(
                          icon: Icons.home_filled,
                          isSelected: _selectedIndex == 0,
                        ),
                        onTap: () {
                          if (_selectedIndex != 0) {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          }
                        },
                      ),
                      BottomAddButton(tapHandler: () async {
                        Navigator.of(context).pushNamed(AddPost.routeName);
                      }),
                      GestureDetector(
                        onTap: () {
                          if (_selectedIndex != 1) {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 24,
                            left: 15,
                          ),
                          child: Container(
                            height: 36,
                            width: 36,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/placeholder.jpg",
                                image: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .getUser()!
                                    .profileURL!,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: WillPopScope(
                  onWillPop: () async {
                    if (_selectedIndex == 1) {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: _widgetOptions[_selectedIndex],
                ),
              );
  }
}
