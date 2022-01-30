import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
import '/helper/APIS.dart';
import '/helper/ERROR_CODE_CUSTOM.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/utils/GlobalLoader.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  static const routeName = "/feedpage";
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isLoading = false;
  bool _wentWrong = false;
  List posts = [];

  Future<void> _loadAllPosts() async {
    UserProvider u = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    if (!u.isLoaded) {
      // IF THE POSTS AREN'T LOADED PREVIOUSLY

      print("CALLING /getAllPosts");
      final data = await PostAPIS().getPosts();
      // FETCHING THE POSTS

      if (data["errCode"] != null) {
        // ERROR WHILE FETCHING POSTS AFTER SUCCESSFUL INITIALIZATION
        Fluttertoast.showToast(msg: data["message"]);
        setState(() {
          _wentWrong = true;
        });
      } else {
        // POSTS WERE NOT LOADED PREVIOUSLY BUT NOW HAVE BEEN LOADED SUCCESSFULLY
        List<Map> fetched_posts = [];
        data["result"].forEach((element) {
          fetched_posts.add(element);
        });
        // CONVERSION OF List<Dynamic> to List<Map>

        u.setPosts(fetched_posts);
        print(data);
        print("-------------");
      }
    } else {
      print("Loaded existing posts!");
      setState(() {
        posts = u.loadedPosts;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    UserProvider up = Provider.of<UserProvider>(context);
    print(up.loadedPosts);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddPost()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _wentWrong
          ? const Center(child: Text("An error occurred!"))
          : _isLoading
              ? GlobalLoader()
              : ListView.builder(
                  itemCount: up.loadedPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Post currPost = Post.fromJson(up.loadedPosts[index]);
                    return ListTile(
                      title: Text(currPost.title.toString()),
                      subtitle: Text(currPost.desc.toString()),
                    );
                  }),
    );
  }
}
