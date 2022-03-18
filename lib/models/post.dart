class Post {
  final String? postID;
  final String? title;
  final String? desc;
  final String? createdAt;
  final String? tag;
  Map? author;
  int upvotes;
  int downvotes;
  bool? vote;
  final List? comments;

  int timeReadCalc() {
    String descRefined = desc ?? "";
    return (((title! + " " + descRefined).split(" ").length) / 180).round() + 1;
  }

  Post({
    this.postID,
    this.author,
    this.tag,
    this.desc,
    this.createdAt,
    this.title,
    this.upvotes = 0,
    this.downvotes = 0,
    this.comments,
  });

  factory Post.fromJson(Map<dynamic, dynamic> data) {
    return Post(
      postID: data["_id"],
      createdAt: data["createdAt"],
      title: data["title"],
      desc: data["description"],
      tag: data["tag"],
      author: data["author"],
      comments: data["comments"] ?? [],
      upvotes: data["upvotes"] ?? 0,
      downvotes: data["downvotes"] ?? 0,
    );
  }

  static Map<String, dynamic> toJson(Post post) {
    return {
      "postID": post.postID,
      "title": post.title,
      "desc": post.desc,
      "author": post.author,
      "tag": post.tag,
      "comments": post.comments,
      "upvotes": post.upvotes,
      "downvotes": post.downvotes,
      "createdAt": post.createdAt,
    };
  }
}
