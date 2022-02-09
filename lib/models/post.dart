class Post {
  final String? postID;
  final String? title;
  final String? desc;
  final String? createdAt;
  final String? tag;
  final Map? author;
  final int? votes;
  final List? comments;

  Post(
      {this.postID,
      this.author,
        this.tag,
      this.desc,
        this.createdAt,
      this.title,
      this.votes,
      this.comments});

  factory Post.fromJson(Map<dynamic, dynamic> data) {
    return Post(
        postID: data["_id"],
        createdAt: data["createdAt"],
        title: data["title"],
        desc: data["description"],
        tag: data["tag"],
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
      "tag": post.tag,
      "comments": post.comments,
      "votes": post.votes,
      "createdAt": post.createdAt,
    };
  }
}
