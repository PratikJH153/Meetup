class Comment {
  final String? commentID;
  final String? userID;
  final String? username;
  final String? userProfile;
  final String? message;
  final String? timeStamp;

  Comment(
      {this.commentID, this.userID, this.username, this.userProfile, this.message, this.timeStamp});

  factory Comment.fromJson(Map<dynamic, dynamic> data) {
    return Comment(
      commentID: data["_id"],
      username: data["userID"]["username"],
      userID: data["userID"]["_id"],
      userProfile: data["userID"]["profileURL"],
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
      "timestamp": comment.timeStamp,
      "userProfile": comment.userProfile,
    };
  }
}
