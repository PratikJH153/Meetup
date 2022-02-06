class Post {
  final String? postID;
  final String? title;
  final String? desc;
  var author;
  final int? votes;
  final List? comments;

  Post(
      {this.postID,
      this.author,
      this.desc,
      this.title,
      this.votes,
      this.comments});

  factory Post.fromJson(Map<dynamic, dynamic> data) {
    return Post(
        postID: data["_id"],
        title: data["title"],
        desc: data["description"],
        author: data["author"],
        comments: data["comments"],
        votes: data["votes"]);
  }

  static Map<String, dynamic> toJson(Post post) {
    return {
      "postID": post.postID,
      "title": post.title,
      "desc": post.desc,
      "author": post.author,
      "comments": post.comments,
      "votes": post.votes,
    };
  }
}
