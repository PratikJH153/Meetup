class Post {
  final String? postID;
  final String? title;
  final String? desc;
  final Map? author;

  Post({
    this.postID,
    this.author,
    this.desc,
    this.title
  });

  factory Post.fromJson(Map<dynamic, dynamic> data) {
    return Post(
      postID: data["id"],
      title: data["title"],
      desc: data["description"],
      author: data["author"]
    );
  }

  static Map<String, dynamic> toJson(Post post) {
    return {
      "postID": post.postID,
      "title": post.title,
      "desc": post.desc,
      "author": post.author
    };
  }
}
