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

  Future<Map> unPackLocally(String id) async {
    print("CALLING /getUserInfoAdmin");
    final data = await _users.getSingleUserData(id);

    bool receivedResponseFromServer = data["local_status"] == 200;
    Map localData = data["local_result"];

    if (receivedResponseFromServer) {
      bool dataReceivedSuccessfully = localData["status"] == 200;
      print("Server responded! Status:${localData["status"]}");

      if (dataReceivedSuccessfully) {
        Map? requestedSuccessData = localData["data"];
        print("SUCCESS DATA:");
        print(requestedSuccessData);
        print("-----------------\n\n");

        return {"success": 1, "unpacked": requestedSuccessData};
      } else {
        Map? requestFailedData = localData["data"];
        print("INCORRECT DATA:");
        print(requestFailedData);
        print("-----------------\n\n");
        return {
          "success": 0,
          "unpacked": "Internal Server error!Wrong request sent!"
        };
      }
    } else {
      print(localData);
      print("Server Down! Status:$localData");
      print("-----------------\n\n");

      return {"success": 0, "unpacked": "Couldn't reach the servers!"};
    }
  }

  Future<void> _initialize(String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool didGoWrong = false;

    setState(() {
      _isLoading = true;
    });

    final Map requestData = await unPackLocally(id);

    if (requestData["success"] == 1) {
      userProvider.setUser(requestData["unpacked"]);
    } else {
      didGoWrong = true;
      Fluttertoast.showToast(msg: requestData["unpacked"]);
    }

    setState(() {
      _isLoading = false;
      _wentWrong = didGoWrong;
    });
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // USER NOT LOADED
      Fluttertoast.showToast(msg: "Something went wrong!");
      setState(() {
        _wentWrong = true;
      });
      return;
    }

    _initialize(user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return _isLoading
        ? Scaffold(body: GlobalLoader())
        : _wentWrong
            ? const Scaffold(
                body: Center(child: Text("Something went wrong!")),
              )
            : Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
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
                body: _widgetOptions[_selectedIndex],
              );
  }
}
