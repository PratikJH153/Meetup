import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/helper/backend/apis.dart';
import '/helper/utils/loader.dart';
import '/screens/post/AddPostPage.dart';
import '/widgets/bottom_add_button.dart';
import '/widgets/bottom_nav_button.dart';
import '/screens/FeedScreen.dart';
import '/providers/UserProvider.dart';
import '/screens/ProfilePage.dart';
import '/models/post.dart';
import '/models/user.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/homepage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? user;
  List<UserClass> users = [];
  List<Post> posts = [];

  bool _wentWrong = false;
  bool _isLoading = false;

  final UserAPIS _users = UserAPIS();

  int _selectedIndex = 0;
  List pages = [];

  final List<Widget> _widgetOptions = <Widget>[
    const FeedPage(),
    const ProfilePage(),
  ];

  Future<void> _initialize(String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    print("CALLING /getSingleUserData");
    final data = await _users.getSingleUserData(id);

    if (data["errCode"] != null) {
      // AN ERROR CAUSED WHILE CALLING API
      Fluttertoast.showToast(msg: data["message"]);
      setState(() {
        _wentWrong = true;
      });
    } else {
      // EVERY THING WENT WELL!
      userProvider.setUser(data);
      setState(() {
        _isLoading = false;
      });
      print(data);
      print("-------------");
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _wentWrong = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _initialize(user!.uid).then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
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
            BottomAddButton(tapHandler: ()async{
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: const Color(0xFFf1e2d2),
                builder: (ctx) {
                  return const AddPost();
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
      body: _isLoading
          ? GlobalLoader()
          : _wentWrong
              ? const Center(
                  child: Text("Something went wrong!"),
                )
              : _widgetOptions[_selectedIndex],
    );
  }
}
