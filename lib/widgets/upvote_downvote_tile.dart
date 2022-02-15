// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '/helper/backend/apis.dart';
// import '/models/post.dart';
// import '/screens/post/CommentPage.dart';
// import '/models/user.dart';
// import '/providers/UserProvider.dart';
// import 'package:provider/provider.dart';
// import 'feed_interact_button.dart';
//
// class UpvoteDownvoteTile extends StatefulWidget {
//   Post post;
//
//   UpvoteDownvoteTile({required this.post});
//
//   @override
//   State<UpvoteDownvoteTile> createState() => _UpvoteDownvoteTileState();
// }
//
// class _UpvoteDownvoteTileState extends State<UpvoteDownvoteTile> {
//   int upvotes = 0;
//   int downvotes = 0;
//
//   final PostAPIS _post = PostAPIS();
//
//   @override
//   void initState() {
//     upvotes = widget.post.upvotes;
//     downvotes = widget.post.downvotes;
//
//     UserClass? currUser = Provider.of<UserProvider>(context, listen: false).getUser();
//
//     if (currUser != null) {
//       // vote = currUser.votes![widget.post.postID];
//       widget.post.vote = currUser.votes![widget.post.postID];
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Color upvoteColor = Colors.grey;
//     Color downvoteColor = Colors.grey;
//
//     if (widget.post.vote == true) {
//       upvoteColor = Colors.red;
//       downvoteColor = Colors.grey;
//     } else if (widget.post.vote == false) {
//       upvoteColor = Colors.grey;
//       downvoteColor = Colors.blue;
//     }
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         widget.post.tag == null
//             ? const SizedBox()
//             : Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6b7fff),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Text(
//                   widget.post.tag!,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w900,
//                     fontFamily: "Raleway",
//                     letterSpacing: 0.8,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//         const Spacer(),
//         FeedInteractButton(
//           icon: CupertinoIcons.arrowtriangle_up_circle,
//           label: upvotes.toString(),
//           color: upvoteColor,
//           tapHandler: () async {
//             /// UPVOTE PRESSED
//             setState(() {
//               if (widget.post.vote == true) {
//                 // CANCEL UPVOTE
//                 upvotes -= 1;
//                 widget.post.vote = null;
//                 _cancelVote(isCancelUpvote: true);
//               } else if (widget.post.vote == false) {
//                 // FIRST DOWNVOTED NOW UPVOTED
//                 widget.post.vote = true;
//                 upvotes += 1;
//                 downvotes -= 1;
//                 _cancelVote(isCancelUpvote: false);
//                 _vote(isUpvote: true);
//               } else if (widget.post.vote == null) {
//                 // HAD NOT VOTED NOW UPVOTING
//
//                 upvotes += 1;
//                 widget.post.vote = true;
//                 _vote(isUpvote: true);
//               }
//             });
//           },
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         FeedInteractButton(
//           icon: CupertinoIcons.arrowtriangle_down_circle,
//           label: downvotes.toString(),
//           color: downvoteColor,
//           tapHandler: () async {
//             /// DOWNVOTE PRESSED
//             if (widget.post.vote == false) {
//               // CANCEL DOWNVOTE
//               downvotes -= 1;
//               widget.post.vote = null;
//               _cancelVote(isCancelUpvote: false);
//             } else if (widget.post.vote == null) {
//               // NOT VOTED NOW DOWNVOTING
//               downvotes += 1;
//               widget.post.vote = false;
//               _vote(isUpvote: false);
//             } else if (widget.post.vote == true) {
//               // HAD PREVIOUSLY UPVOTED DOWN DOWNVOTING
//               upvotes -= 1;
//               downvotes += 1;
//               widget.post.vote = false;
//               _cancelVote(isCancelUpvote: true);
//               _vote(isUpvote: false);
//             }
//             setState(() {});
//           },
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         FeedInteractButton(
//           icon: CupertinoIcons.chat_bubble_2,
//           label: '',
//           tapHandler: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               backgroundColor: Colors.transparent,
//               barrierColor: const Color(0xFF383838),
//               builder: (ctx) {
//                 return CommentPage(widget.post.comments ?? [], widget.post);
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
