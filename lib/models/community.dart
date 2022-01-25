class Community {
  final String? communityID;
  final String? title;
  final String? desc;
  final List? tags;
  final List? posts;
  final String? admin;
  final List? members;

  Community(
      {this.posts,
      this.title,
      this.desc,
      this.admin,
      this.communityID,
      this.members,
      this.tags});

  factory Community.fromJson(Map<dynamic, dynamic> data) {
    return Community(
        communityID: data["_id"],
        title: data["title"],
        desc: data["description"],
        tags: data["tags"],
        posts: data["posts"],
        admin: data["admin"],
        members: data["members"]);
  }

  static Map<String, dynamic> toJson(Community community) {
    return {
      "communityID": community.communityID,
      "title": community.title,
      "desc": community.desc,
      "tags": community.tags,
      "posts": community.posts,
      "admin": community.admin,
      "members": community.members,
    };
  }
}
