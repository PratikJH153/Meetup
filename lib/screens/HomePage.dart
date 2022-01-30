import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    final List<Widget> _widgetOptions = <Widget>[
      FeedPage(),
      ProfilePage(),
    ];
    return _isLoading
        ? const Scaffold(body: GlobalLoader())
        : _wentWrong
            ? const Scaffold(body: Center(child: Text("Something went wrong!")))
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Profile'),
                  actions: [
                    _isLoading
                        ? const Center(child: GlobalLoader())
                        : IconButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginPage()));
                            },
                            icon: const Icon(Icons.logout),
                            color: Colors.white)
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home, color: Colors.white),
                          label: 'Home',
                          backgroundColor: Colors.blue),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person, color: Colors.white),
                        label: 'Profile',
                        backgroundColor: Colors.blue,
                      ),
                    ],
                    type: BottomNavigationBarType.shifting,
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.black,
                    iconSize: 40,
                    onTap: _onItemTapped,
                    elevation: 5),
                body: _widgetOptions[_selectedIndex],
              );
  }
}
