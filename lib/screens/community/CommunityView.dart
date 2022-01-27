import 'package:flutter/material.dart';
import 'package:meetupapp/utils/GlobalLoader.dart';
import '/helper/APIS.dart';
import '/models/post.dart';
import '/screens/post/AddPostPage.dart';
import '/models/community.dart';

class CommunityView extends StatefulWidget {
  Community community;

  CommunityView(this.community);

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  Map singleCommunityMap = {};
  List <Post>communityPosts = [];
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    community_apis()
        .getSingleCommunity(widget.community.communityID!)
        .then((value) {
      value["posts"]!.forEach((e){
        Post post = Post.fromJson(e);
        communityPosts.add(post);
      });
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.community.title.toString()),
        ),
        body: _isLoading
            ? GlobalLoader()
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        widget.community.desc.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.community.posts == null
                            ? 0
                            : communityPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          Post post =
                              communityPosts[index];

                          return ListTile(
                            title: Text(post.title.toString()),
                            subtitle: Text(post.desc.toString()),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            print(widget.community.title);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => AddPost(widget.community)));
          },
        ),
      ),
    );
  }
}
