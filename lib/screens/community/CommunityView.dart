import 'package:flutter/material.dart';
import '/models/post.dart';
import '/screens/post/AddPostPage.dart';
import '/models/community.dart';

class CommunityView extends StatelessWidget {
  Community community;

  CommunityView(this.community);

  @override
  Widget build(BuildContext context) {

    print(community.admin);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              community.title.toString()
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  community.desc.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: community.posts==null?0:community.posts!.length,
                  itemBuilder: (BuildContext context, int index){
                    Post post = Post.fromJson(community.posts![index]);

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
          onPressed: (){
            print(community.title);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_)=> AddPost(community)
                )
            );
          },
        ),
      ),
    );
  }
}
