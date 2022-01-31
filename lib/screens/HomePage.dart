import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
import 'package:meetupapp/widgets/bottom_add_button.dart';
import 'package:meetupapp/widgets/bottom_nav_button.dart';
import 'package:provider/provider.dart';
import '/screens/FeedScreen.dart';
import '/providers/UserProvider.dart';
import '/screens/ProfilePage.dart';
import '/models/post.dart';
import '/models/user.dart';
import '/helper/APIS.dart';
import '/helper/loader.dart';
import 'LoginPage.dart';

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
    FeedPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
          borderRadius: BorderRadius.circular(30),
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
            const BottomNavButton(
              icon: CupertinoIcons.bolt_horizontal_fill,
              isSelected: true,
            ),
            BottomAddButton(tapHandler: () {
              Navigator.pushNamed(context, AddPost.routeName);
            }),
            const BottomNavButton(
              icon: CupertinoIcons.person_alt,
              isSelected: false,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const GlobalLoader()
          : _wentWrong
              ? const Center(
                  child: Text("Something went wrong!"),
                )
              : _widgetOptions[_selectedIndex],
    );
  }
}
