import 'package:flutter/material.dart';
import '/models/post.dart';
import 'HomePage.dart';

class FeedScreen extends StatefulWidget{
  List users;
  List posts;

  FeedScreen({required this.users, required this.posts,Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>{
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended for You",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          widget.users.isEmpty
              ? const Text("No suggestions found!")
              : Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 100,
            width: s.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.users.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Text(widget.users[index].username.toString()),
                      const SizedBox(height: 10),
                      Text(widget.users[index].gender.toString()),
                      const SizedBox(height: 10),
                      Text(widget.users[index].matched.toString()),
                    ],
                  ),
                );
              },
            ),
          ),
          const Text(
            "Your Feed",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          widget.posts.isEmpty
              ? const Center(
              child: Text("No posts to show!",
                  style: TextStyle(fontWeight: FontWeight.bold)))
              : Expanded(
            child: ListView.builder(
                itemCount: widget.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  Post currPost = widget.posts[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        Text(currPost.title.toString()),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
