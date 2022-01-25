import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/FeedScreen.dart';
import 'community/SearchCommunityScreen.dart';
import '/utils/fire_auth.dart';
import '/models/post.dart';
import '/models/user.dart';
import '/helper/APIS.dart';
import '/helper/loader.dart';
import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? user;
  List<UserClass> users = [];
  List<Post> posts = [];

  int _selectedIndex = 0;
  bool _isSigningOut = false;
  bool _isLoading = false;

  final user_apis _users = user_apis();
  final post_apis _posts = post_apis();

  List pages = [];

  void _onItemTapped(int index) {
    if(_selectedIndex!=index) {
      setState(() {
      _selectedIndex = index;
    });
    }
  }

  Future<void> _getPostsAndUsersForCurrentUser(String id) async {
    final u = await _users.getRecommendations(id);
    final p = await _posts.getPosts();

    var user_list = u["result"]??[];
    var post_list = p["result"]??[];

    for (int i = 0; i < user_list.length; i++) {
      Map userMap = user_list[i]["properties"];
      userMap["matched"] = user_list[i]["matched"];

      UserClass userObject = UserClass.fromJson(userMap);
      if (userObject.userID != user!.uid) {
        users.add(userObject);
      }
    }

    for (int i = 0; i < post_list.length; i++) {
      Map postmap = post_list[i];
      Post post = Post.fromJson(postmap);
      posts.add(post);
    }

    users = users.reversed.toList();
    posts = posts.reversed.toList();
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    user = FirebaseAuth.instance.currentUser;
    _getPostsAndUsersForCurrentUser(user!.uid).then((value) {
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
      FeedScreen(users: users, posts: posts),
      SearchCommunityScreen(),
      const Text('Profile Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          _isSigningOut
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
                            builder: (_)=> LoginPage()
                        )
                    );
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
                icon: Icon(Icons.search, color: Colors.white),
                label: 'Search',
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
      body: _isLoading
          ? const GlobalLoader()
          : _widgetOptions[_selectedIndex],
    );
  }
}
