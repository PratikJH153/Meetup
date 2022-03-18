import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/helper/utils/loader.dart';
import '/widgets/tag_widget.dart';
import '/providers/UserProvider.dart';
import '/helper/GlobalFunctions.dart';
import '/screens/post/CommentPage.dart';
import '/models/post.dart';

class FeedTile extends StatefulWidget {
  final Post thePost;

  const FeedTile(this.thePost, {Key? key}) : super(key: key);

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  bool isLoading = false;
  bool isAddingInterests = false;

  void addInterest(BuildContext context, String id, String tag) async {
    setState(() {
      isAddingInterests = true;
    });
    await addInterests(context, id, tag);
    setState(() {
      isAddingInterests = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    Map authorMap = widget.thePost.author ?? {};
    String username = authorMap["username"] ?? "Unnamed";
    String profileUrl = authorMap["profileURL"] ?? placeholder;

    return Container(
        margin: const EdgeInsets.only(bottom: 26),
        padding: const EdgeInsets.all(18),
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
                SizedBox(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/placeholder.jpg",
                      image: profileUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
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
              ],
            ),
            const SizedBox(
              height: 10,
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
              height: 5,
            ),
            if (widget.thePost.desc != null &&
                widget.thePost.desc!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
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
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isAddingInterests
                    ? const GlobalLoader()
                    : TagWidget(
                        tag: widget.thePost.tag ?? "",
                        tapHandler: () {
                          UserProvider userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          addInterest(context, userProvider.getUser()!.userID!,
                              widget.thePost.tag!);
                        },
                        canAdd: !userProvider
                            .getUser()!
                            .interests!
                            .contains(widget.thePost.tag!),
                      ),
                Row(
                  children: [
                    VoteSection(context, widget.thePost),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => CommentPage(post: widget.thePost),
                          ),
                        );
                      },
                      child: const Icon(
                        CupertinoIcons.chat_bubble_2,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
