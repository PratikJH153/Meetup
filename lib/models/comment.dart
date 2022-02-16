class Comment {
  final String? commentID;
  final String? userID;
  final String? username;
  final String? userProfile;
  final String? message;
  final String? timeStamp;

  Comment({
    this.commentID,
    this.userID,
    this.username,
    this.userProfile,
    this.message,
    this.timeStamp,
  });

  factory Comment.fromJson(Map data) {
    return Comment(
      commentID: data["_id"],
      userID: data["userID"]["_id"],
      userProfile: data["userID"]["profileURL"],
      username: data["userID"]["username"],
      timeStamp: data["timestamp"],
      message: data["message"],
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      "_id": comment.commentID,
      "message": comment.message,
      "userID": comment.userID,
      "username": comment.username,
      "userProfile": comment.userProfile,
      "timestamp": comment.timeStamp,
    };
  }
}
