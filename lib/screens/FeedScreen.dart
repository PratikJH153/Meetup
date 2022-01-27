import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meetupapp/helper/APIS.dart';
import 'package:meetupapp/helper/ERROR_CODE_CUSTOM.dart';
import 'package:meetupapp/models/post.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:meetupapp/utils/GlobalLoader.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLoading = false;
  bool _wentWrong = false;
  List posts = [];

  Future<void> _loadAllPosts() async {
    UserProvider u = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    if(!u.isLoaded){
      // IF THE POSTS AREN'T LOADED PREVIOUSLY

      print("CALLING /getAllPosts");
      final data = await post_apis().getPosts();
      // FETCHING THE POSTS

      if(data["errCode"]!=null){
        // ERROR WHILE FETCHING POSTS AFTER SUCCESSFUL INITIALIZATION
        Fluttertoast.showToast(msg: data["message"]);
        setState(() {
          _wentWrong = true;
        });
      }
      else{
        // POSTS WERE NOT LOADED PREVIOUSLY BUT NOW HAVE BEEN LOADED SUCCESSFULLY
        List<Map> fetched_posts = [];
        data["result"].forEach((element) {fetched_posts.add(element);});
        // CONVERSION OF List<Dynamic> to List<Map>

        u.setPosts(fetched_posts);
        print(data);
        print("-------------");
      }
    }
    else{
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

    return _wentWrong
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
                });
  }
}
