import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/screens/post/AddPostPage.dart';
import '/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/helper/GlobalFunctions.dart';
import '/screens/post/CommentPage.dart';
import '/models/post.dart';
import 'feed_interact_button.dart';

class FeedTile extends StatefulWidget {
  final Post thePost;

  const FeedTile(this.thePost, {Key? key}) : super(key: key);

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    Map authorMap = widget.thePost.author ?? {};
    String id = authorMap["_id"];
    String username = authorMap["username"];
    String profileUrl = authorMap["profileURL"];
    bool isTheSameUser = id == userProvider.getUser()!.userID;

    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFf2f4f9),
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          profileUrl,
                        ),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${timeago.format(
                        DateTime.parse(
                          widget.thePost.createdAt!,
                        ),
                      )} . ${widget.thePost.timeReadCalc()} mins read",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (isTheSameUser)
                  PopupMenuButton(itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            Text("Delete Post"),
                          ],
                        ),
                        onTap: () async {
                          deletePost(context, widget.thePost);
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: const [
                            Icon(Icons.edit),
                            Text("Edit"),
                          ],
                        ),
                        onTap: (){
                          print("Hey");
                        },
                      ),
                    ];
                  })
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.thePost.title ?? "No title",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontFamily: "Ubuntu",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (widget.thePost.desc != null)
              Text(
                widget.thePost.desc!,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontFamily: "Raleway",
                  color: Color(0xFF5c5c5c),
                ),
              ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.thePost.tag == null
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6b7fff),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.thePost.tag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Raleway",
                            letterSpacing: 0.8,
                            fontSize: 11,
                          ),
                        ),
                      ),
                const Spacer(),
                VoteSection(context, widget.thePost),
                const SizedBox(
                  width: 5,
                ),
                FeedInteractButton(
                  icon: CupertinoIcons.chat_bubble_2,
                  label: '',
                  tapHandler: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: const Color(0xFF383838),
                      builder: (ctx) {
                        return CommentPage(
                          post: widget.thePost,
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ));
  }
}
