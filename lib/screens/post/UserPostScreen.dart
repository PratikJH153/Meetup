import 'package:flutter/material.dart';
import '/models/post.dart';
import '/providers/UserProvider.dart';
import '/screens/post/ViewPostPage.dart';
import '/widgets/feed_tile.dart';
import 'package:provider/provider.dart';

class UserPosts extends StatelessWidget {
  static const String routeName = "UserPosts";
  const UserPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List userPosts = userProvider.getUser()!.posts??[];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (){Navigator.of(context).pop();},
          ),
          title: const Text(
            "Your Posts",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              bottom: 200,
              top: 30,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: userPosts.length,
            itemBuilder: (ctx, index) {
              Post currPost = Post.fromJson(userPosts[index]);
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: const Color(0xFF383838),
                    builder: (ctx) {
                      return ViewPostPage(currPost);
                    },
                  );
                },
                child: Text(currPost.title!),
              );
            },
          ),
        ),
      ),
    );
  }
}
